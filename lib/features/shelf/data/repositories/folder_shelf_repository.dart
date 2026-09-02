import 'dart:convert';
import 'dart:io';

import 'package:audiobooks/core/audio/metadata/audio_metadata_service.dart';
import 'package:audiobooks/core/errors/app_failure.dart';
import 'package:audiobooks/core/files/media_storage.dart';
import 'package:audiobooks/core/shelf/shelf_folder.dart';
import 'package:audiobooks/core/shelf/shelf_folder_gateway.dart';
import 'package:audiobooks/core/shelf/shelf_manifest.dart';
import 'package:audiobooks/core/shelf/shelf_presence.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/shelf/domain/entities/shelf_book.dart';
import 'package:audiobooks/features/shelf/domain/repositories/shelf_repository.dart';
import 'package:injectable/injectable.dart';

/// The shared library folder, read as a shelf.
///
/// Two things are true of everything here, and they are what make a folder
/// shared by several devices safe to work in:
///
/// Nothing already on this device is written over. A download always builds a
/// book folder of its own under a freshly minted id, so it cannot land on the
/// files of a book already in the library even if the same book is downloaded
/// twice.
///
/// Nothing another device published is written over either. Publishing a book
/// whose key is already in the folder leaves what is there alone, so two
/// devices publishing the same book race to be first rather than corrupting
/// each other.
@LazySingleton(as: ShelfRepository)
class FolderShelfRepository implements ShelfRepository {
  FolderShelfRepository(
    this._folders,
    this._library,
    this._storage,
    this._metadata,
  );

  final ShelfFolderGateway _folders;
  final AudiobookRepository _library;
  final MediaStorage _storage;
  final AudioMetadataService _metadata;

  /// The folder inside the shared folder that books live in, so that the
  /// listener can keep other things beside it without the app reading them.
  static const _booksDirectory = 'books';

  static const _audioExtensions = {'mp3', 'm4a', 'm4b', 'aac'};
  static const _coverExtensions = {'jpg', 'jpeg', 'png', 'webp'};

  @override
  Future<ShelfFolder?> folder() => _folders.current();

  @override
  Future<ShelfFolder?> chooseFolder() => _folders.choose();

  @override
  Future<void> forgetFolder() => _folders.forget();

  @override
  Future<List<ShelfBook>> booksNotInLibrary() async {
    final books = await _readShelf();
    if (books.isEmpty) return const [];

    final library = await _library.watchAll().first;
    return [
      for (final entry in books)
        if (!ShelfPresence.isInLibrary(
          library,
          key: entry.book.key,
          title: entry.book.title,
          author: entry.book.author,
          duration: entry.book.duration,
        ))
          entry.book,
    ];
  }

  @override
  Future<Audiobook> download(
    String key, {
    void Function(int copied, int total)? onProgress,
  }) async {
    // Asked for first, so that a folder that has gone away explains itself
    // rather than reading as a book that is no longer on the shelf.
    await _readableRoot();

    final entry = (await _readShelf())
        .where((candidate) => candidate.book.key == key)
        .firstOrNull;
    if (entry == null) {
      throw const FileAccessFailure(
        'That book is no longer in the shared folder.',
      );
    }

    // The library may have gained the book since the shelf was drawn — the
    // listener downloaded it on another screen, or imported it by hand. Adding
    // a second copy is never what was meant.
    final library = await _library.watchAll().first;
    if (ShelfPresence.isInLibrary(
      library,
      key: entry.book.key,
      title: entry.book.title,
      author: entry.book.author,
      duration: entry.book.duration,
    )) {
      throw const FileAccessFailure('That book is already in your library.');
    }

    // A fresh id, so the folder written to is one no book has ever used.
    final id = '${DateTime.now().microsecondsSinceEpoch}';
    final destination = await _storage.bookDirectory(id);

    try {
      return await _copyIntoLibrary(
        entry,
        id: id,
        into: destination,
        onProgress: onProgress,
      );
    } catch (error) {
      // A half-copied book is worse than none: it would sit in storage with
      // nothing pointing at it. Nothing outside this folder was touched.
      if (await destination.exists()) {
        await destination.delete(recursive: true);
      }
      if (error is AppFailure) rethrow;
      throw FileAccessFailure(
        'That book could not be downloaded from the shared folder.',
        cause: error,
      );
    }
  }

  @override
  Future<void> publish(Audiobook book) async {
    final root = await _readableRoot();
    final key = book.shelfKey ?? _keyFor(book);
    final target = Directory(_join(root.path, key));

    // Another device may have published this book already. What is there is
    // left exactly as it is.
    if (await target.exists()) {
      if (book.shelfKey == null) {
        await _library.save(book.copyWith(shelfKey: key));
      }
      return;
    }

    final staging = Directory(_join(root.path, '.publishing-$key'));
    try {
      if (await staging.exists()) await staging.delete(recursive: true);
      await staging.create(recursive: true);

      final files = <ShelfManifestFile>[];
      final sources = _sourceFilesOf(book);
      if (sources.isEmpty) {
        throw const FileAccessFailure(
          'That book has no audio on this device to publish.',
        );
      }

      for (final source in sources) {
        final name = _nameOf(source);
        final copied = File(_join(staging.path, name));
        await File(source).copy(copied.path);
        files.add(
          ShelfManifestFile(name: name, sizeBytes: await copied.length()),
        );
      }

      String? cover;
      if (book.coverPath case final path? when await File(path).exists()) {
        cover = 'cover.${_extensionOf(path)}';
        await File(path).copy(_join(staging.path, cover));
      }

      final manifest = ShelfManifest(
        key: key,
        title: book.title,
        author: book.author,
        narrator: book.narrator,
        fileType: book.fileType,
        duration: book.duration,
        cover: cover,
        publishedAt: DateTime.now(),
        files: files,
        chapters: [
          for (final chapter in book.chapters)
            ShelfManifestChapter(
              title: chapter.title,
              file: _nameOf(chapter.filePath),
              start: chapter.startPosition,
              duration: chapter.duration,
            ),
        ],
      );

      // Written last, so a folder that is still arriving on another device is
      // never mistaken for a book that is ready to read.
      await File(_join(staging.path, ShelfManifest.fileName)).writeAsString(
        const JsonEncoder.withIndent('  ').convert(manifest.toJson()),
        flush: true,
      );

      await staging.rename(target.path);
      await _library.save(book.copyWith(shelfKey: key));
    } catch (error) {
      if (await staging.exists()) await staging.delete(recursive: true);
      if (error is AppFailure) rethrow;
      throw FileAccessFailure(
        'That book could not be published to the shared folder.',
        cause: error,
      );
    }
  }

  /// Copies a shelf book's files into a folder of its own and records it.
  Future<Audiobook> _copyIntoLibrary(
    _ShelfEntry entry, {
    required String id,
    required Directory into,
    void Function(int copied, int total)? onProgress,
  }) async {
    final total = entry.book.totalBytes;
    var copied = 0;
    final landed = <String, String>{};

    for (final file in entry.files) {
      final source = File(_join(entry.directory.path, file));
      final destination = _join(into.path, file);
      await _copy(source, destination, (chunk) {
        copied += chunk;
        onProgress?.call(copied, total);
      });
      landed[file] = destination;
    }

    String? cover;
    if (entry.cover case final name?) {
      final source = File(_join(entry.directory.path, name));
      if (await source.exists()) {
        cover = _join(into.path, name);
        await source.copy(cover);
      }
    }

    final manifest = entry.manifest;
    final first = landed[entry.files.first]!;

    // A folder without a manifest says nothing about how long the book runs,
    // so the audio is asked once it is here and reading it costs nothing.
    var duration = manifest?.duration ?? Duration.zero;
    if (duration == Duration.zero) {
      for (final path in landed.values) {
        duration += (await _metadata.read(path)).duration;
      }
    }

    final chapters = _chaptersFor(
      entry,
      bookId: id,
      landed: landed,
      totalDuration: duration,
    );

    final book = Audiobook(
      id: id,
      title: entry.book.title,
      author: entry.book.author,
      narrator: entry.book.narrator,
      dateAdded: DateTime.now(),
      fileType: entry.book.fileType,
      sourcePath: first,
      coverPath: cover,
      duration: duration,
      shelfKey: entry.book.key,
      chapters: chapters,
    );
    await _library.save(book);
    return book;
  }

  List<AudiobookChapter> _chaptersFor(
    _ShelfEntry entry, {
    required String bookId,
    required Map<String, String> landed,
    required Duration totalDuration,
  }) {
    final manifest = entry.manifest;
    if (manifest != null && manifest.chapters.isNotEmpty) {
      return [
        for (var index = 0; index < manifest.chapters.length; index++)
          AudiobookChapter(
            id: '$bookId-chapter-$index',
            bookId: bookId,
            title: manifest.chapters[index].title,
            index: index,
            filePath: landed[manifest.chapters[index].file]!,
            startPosition: manifest.chapters[index].start,
            duration: manifest.chapters[index].duration,
          ),
      ];
    }

    // A book that arrived as several files is a book with a chapter per file,
    // which is the shape the importer gives one too.
    if (entry.files.length < 2) return const [];
    return [
      for (var index = 0; index < entry.files.length; index++)
        AudiobookChapter(
          id: '$bookId-chapter-$index',
          bookId: bookId,
          title: _withoutExtension(entry.files[index]),
          index: index,
          filePath: landed[entry.files[index]]!,
        ),
    ];
  }

  /// Everything in the shared folder that reads as a complete book.
  Future<List<_ShelfEntry>> _readShelf() async {
    final Directory root;
    try {
      root = await _readableRoot();
    } on AppFailure {
      return const [];
    }
    if (!await root.exists()) return const [];

    final entries = <_ShelfEntry>[];
    await for (final entity in root.list(followLinks: false)) {
      if (entity is! Directory) continue;
      // A folder still being written by this device is not a book yet.
      if (_nameOf(entity.path).startsWith('.')) continue;

      final entry = await _readBook(entity);
      if (entry != null) entries.add(entry);
    }
    entries.sort(
      (a, b) =>
          a.book.title.toLowerCase().compareTo(b.book.title.toLowerCase()),
    );
    return entries;
  }

  /// Reads one book folder, or gives back null when it is not a book, or is
  /// not finished arriving.
  Future<_ShelfEntry?> _readBook(Directory directory) async {
    final present = <String, int>{};
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is! File) continue;
      present[_nameOf(entity.path)] = await entity.length();
    }

    final manifestFile = File(_join(directory.path, ShelfManifest.fileName));
    if (await manifestFile.exists()) {
      ShelfManifest? manifest;
      try {
        manifest = ShelfManifest.fromJson(
          jsonDecode(await manifestFile.readAsString()),
        );
      } catch (_) {
        manifest = null;
      }
      if (manifest == null) return null;

      // Every file the manifest promises has to be here, and be the size it
      // was published at. A file still on its way up from another device is
      // short, and the book waits for the next look.
      for (final file in manifest.files) {
        if (present[file.name] != file.sizeBytes) return null;
      }

      return _ShelfEntry(
        directory: directory,
        manifest: manifest,
        files: [for (final file in manifest.files) file.name],
        cover: manifest.cover,
        book: ShelfBook(
          key: manifest.key,
          title: manifest.title,
          author: manifest.author,
          narrator: manifest.narrator,
          fileType: manifest.fileType,
          totalBytes: manifest.totalBytes,
          coverPath: manifest.cover == null
              ? null
              : _join(directory.path, manifest.cover!),
          duration: manifest.duration,
          chapterCount: manifest.chapters.length,
        ),
      );
    }

    // No manifest: a folder of audio the listener dropped in themselves. What
    // the filesystem alone can say is enough to offer it, and nothing here
    // opens the audio — in a folder held online-only by a sync service that
    // would pull the whole book down just to draw a row.
    final audio =
        present.keys
            .where((name) => _audioExtensions.contains(_extensionOf(name)))
            .toList()
          ..sort();
    if (audio.isEmpty) return null;

    final key = _nameOf(directory.path);
    final cover = present.keys
        .where((name) => _coverExtensions.contains(_extensionOf(name)))
        .firstOrNull;

    return _ShelfEntry(
      directory: directory,
      manifest: null,
      files: audio,
      cover: cover,
      book: ShelfBook(
        key: key,
        title: key,
        author: 'Unknown Author',
        fileType: _fileTypeFor(_extensionOf(audio.first)),
        totalBytes: audio.fold(0, (total, name) => total + present[name]!),
        coverPath: cover == null ? null : _join(directory.path, cover),
        chapterCount: audio.length < 2 ? 0 : audio.length,
      ),
    );
  }

  /// The `books` folder inside the chosen folder, or a failure explaining why
  /// there is nothing to read.
  Future<Directory> _readableRoot() async {
    final folder = await _folders.current();
    if (folder == null) {
      throw const FileAccessFailure(
        'No shared library folder has been chosen.',
      );
    }
    if (!folder.isReadable) {
      throw const FileAccessFailure(
        'That folder cannot be opened directly. Choose one that your sync '
        'service keeps on this device.',
      );
    }
    return Directory(_join(folder.location, _booksDirectory));
  }

  /// The audio on this device that a book is made of, in playing order.
  List<String> _sourceFilesOf(Audiobook book) {
    if (book.chapters.isEmpty) {
      return [?book.sourcePath];
    }
    // A single file carrying markers is one file, however many chapters it
    // has, so the same path is never copied twice.
    final ordered = <String>[];
    for (final chapter in book.chapters) {
      if (!ordered.contains(chapter.filePath)) ordered.add(chapter.filePath);
    }
    return ordered;
  }

  Future<void> _copy(
    File source,
    String destination,
    void Function(int chunk) onChunk,
  ) async {
    if (!await source.exists()) {
      throw FileAccessFailure(
        'A file this book is made of is missing from the shared folder: '
        '${_nameOf(source.path)}.',
      );
    }

    final sink = File(destination).openWrite();
    try {
      await for (final chunk in source.openRead()) {
        sink.add(chunk);
        onChunk(chunk.length);
      }
      await sink.flush();
    } finally {
      await sink.close();
    }
  }

  /// A folder name for a book being published: readable, and unlikely to
  /// collide with another book the listener owns.
  String _keyFor(Audiobook book) {
    final slug = book.title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final stem = slug.isEmpty ? 'book' : slug;
    return '$stem-${book.id}';
  }

  AudioFileType _fileTypeFor(String extension) =>
      AudioFileType.values
          .where((type) => type.name == extension)
          .firstOrNull ??
      AudioFileType.mp3;

  String _join(String directory, String name) =>
      '$directory${Platform.pathSeparator}$name';

  String _nameOf(String path) => path.split(RegExp(r'[/\\]')).last;

  String _extensionOf(String name) {
    final dot = name.lastIndexOf('.');
    return dot <= 0 ? '' : name.substring(dot + 1).toLowerCase();
  }

  String _withoutExtension(String name) {
    final dot = name.lastIndexOf('.');
    return dot <= 0 ? name : name.substring(0, dot);
  }
}

/// A book folder that has been read: what it holds, and what it says it is.
class _ShelfEntry {
  const _ShelfEntry({
    required this.directory,
    required this.manifest,
    required this.files,
    required this.book,
    this.cover,
  });

  final Directory directory;

  /// Null for a folder of audio with no manifest beside it.
  final ShelfManifest? manifest;

  /// The audio file names, in playing order.
  final List<String> files;
  final String? cover;
  final ShelfBook book;
}
