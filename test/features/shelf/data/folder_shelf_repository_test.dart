import 'dart:convert';
import 'dart:io';

import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';
import 'package:audiobooks/core/audio/metadata/audio_metadata_service.dart';
import 'package:audiobooks/core/audio/metadata/cover_art.dart';
import 'package:audiobooks/core/database/app_database.dart';
import 'package:audiobooks/core/errors/app_failure.dart';
import 'package:audiobooks/core/files/media_storage.dart';
import 'package:audiobooks/core/shelf/shelf_folder.dart';
import 'package:audiobooks/core/shelf/shelf_folder_gateway.dart';
import 'package:audiobooks/core/shelf/shelf_manifest.dart';
import 'package:audiobooks/features/library/data/repositories/local_audiobook_repository.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/shelf/data/repositories/folder_shelf_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeShelfFolderGateway implements ShelfFolderGateway {
  _FakeShelfFolderGateway(this.folder);

  ShelfFolder? folder;

  @override
  Future<ShelfFolder?> current() async => folder;

  @override
  Future<ShelfFolder?> choose() async => folder;

  @override
  Future<void> forget() async => folder = null;
}

class _FakeMetadataService implements AudioMetadataService {
  const _FakeMetadataService(this.duration);

  final Duration duration;

  @override
  Future<AudioFileMetadata> read(String path) async =>
      AudioFileMetadata(duration: duration);

  @override
  Future<CoverArt?> readCoverArt(String path) async => null;
}

class _TempMediaStorage extends MediaStorage {
  _TempMediaStorage(this._root);

  final Directory _root;

  @override
  Future<Directory> root() async => _root;
}

void main() {
  late Directory shared;
  late Directory media;
  late Directory books;
  late AppDatabase database;
  late LocalAudiobookRepository library;
  late _FakeShelfFolderGateway folders;
  late FolderShelfRepository repository;

  setUp(() async {
    shared = await Directory.systemTemp.createTemp('shelf-shared');
    media = await Directory.systemTemp.createTemp('shelf-media');
    books = await Directory('${shared.path}/books').create(recursive: true);
    database = AppDatabase.forTesting(NativeDatabase.memory());
    library = LocalAudiobookRepository(database);
    folders = _FakeShelfFolderGateway(
      ShelfFolder(location: shared.path, access: ShelfFolderAccess.directory),
    );
    repository = FolderShelfRepository(
      folders,
      library,
      _TempMediaStorage(media),
      const _FakeMetadataService(Duration(hours: 1)),
    );
  });

  tearDown(() async {
    await database.close();
    await shared.delete(recursive: true);
    if (await media.exists()) await media.delete(recursive: true);
  });

  /// Puts a published book in the shared folder, the way another device would.
  Future<Directory> publishToFolder({
    String key = 'a-quiet-book-1',
    String title = 'A Quiet Book',
    String author = 'A. Reader',
    Duration duration = const Duration(hours: 2),
    Map<String, String> files = const {'01.mp3': 'first', '02.mp3': 'second'},
    bool withCover = true,
    bool withManifest = true,
    String? corruptManifest,
    int? understateFirstFileSize,
  }) async {
    final directory = await Directory('${books.path}/$key').create();
    final entries = <ShelfManifestFile>[];
    for (final entry in files.entries) {
      final file = File('${directory.path}/${entry.key}');
      await file.writeAsString(entry.value);
      entries.add(
        ShelfManifestFile(
          name: entry.key,
          sizeBytes: entries.isEmpty && understateFirstFileSize != null
              ? understateFirstFileSize
              : entry.value.length,
        ),
      );
    }
    if (withCover) {
      await File('${directory.path}/cover.jpg').writeAsString('art');
    }

    if (corruptManifest != null) {
      await File(
        '${directory.path}/${ShelfManifest.fileName}',
      ).writeAsString(corruptManifest);
      return directory;
    }
    if (!withManifest) return directory;

    final manifest = ShelfManifest(
      key: key,
      title: title,
      author: author,
      fileType: AudioFileType.mp3,
      duration: duration,
      cover: withCover ? 'cover.jpg' : null,
      files: entries,
      chapters: [
        for (var index = 0; index < files.length; index++)
          ShelfManifestChapter(
            title: 'Chapter ${index + 1}',
            file: files.keys.elementAt(index),
            start: Duration.zero,
            duration: Duration(minutes: 30),
          ),
      ],
    );
    await File(
      '${directory.path}/${ShelfManifest.fileName}',
    ).writeAsString(jsonEncode(manifest.toJson()));
    return directory;
  }

  Audiobook localBook({
    String id = 'local-1',
    String title = 'A Quiet Book',
    String author = 'A. Reader',
    Duration duration = const Duration(hours: 2),
    String? shelfKey,
    String? sourcePath,
  }) => Audiobook(
    id: id,
    title: title,
    author: author,
    dateAdded: DateTime.utc(2026, 9, 1),
    fileType: AudioFileType.mp3,
    duration: duration,
    shelfKey: shelfKey,
    sourcePath: sourcePath,
  );

  group('reading the shelf', () {
    test('offers a book the library does not have', () async {
      await publishToFolder();

      final shelf = await repository.booksNotInLibrary();

      expect(shelf, hasLength(1));
      expect(shelf.single.key, 'a-quiet-book-1');
      expect(shelf.single.title, 'A Quiet Book');
      expect(shelf.single.duration, const Duration(hours: 2));
      expect(shelf.single.chapterCount, 2);
      expect(shelf.single.totalBytes, 'first'.length + 'second'.length);
      expect(shelf.single.coverPath, isNotNull);
    });

    test('leaves out a book that came off this shelf already', () async {
      await publishToFolder();
      await library.save(
        localBook(title: 'Renamed On This Device', shelfKey: 'a-quiet-book-1'),
      );

      expect(await repository.booksNotInLibrary(), isEmpty);
    });

    test('leaves out the same book imported by hand on this device', () async {
      await publishToFolder();
      await library.save(localBook());

      expect(await repository.booksNotInLibrary(), isEmpty);
    });

    test('still offers a book the library merely resembles', () async {
      await publishToFolder();
      await library.save(localBook(title: 'A Different Book'));

      expect(await repository.booksNotInLibrary(), hasLength(1));
    });

    test('waits for a book that is still arriving', () async {
      // The manifest promises more than has landed, which is what a book
      // halfway up from another device looks like.
      await publishToFolder(understateFirstFileSize: 9999);

      expect(await repository.booksNotInLibrary(), isEmpty);
    });

    test('skips a folder whose manifest cannot be read', () async {
      await publishToFolder(corruptManifest: 'not json at all');

      expect(await repository.booksNotInLibrary(), isEmpty);
    });

    test('offers a folder of audio dropped in without a manifest', () async {
      await publishToFolder(
        key: 'Dropped In By Hand',
        withManifest: false,
        withCover: false,
      );

      final shelf = await repository.booksNotInLibrary();

      expect(shelf, hasLength(1));
      expect(shelf.single.title, 'Dropped In By Hand');
      expect(shelf.single.duration, Duration.zero);
    });

    test('ignores a folder holding nothing to play', () async {
      final directory = await Directory('${books.path}/notes').create();
      await File('${directory.path}/readme.txt').writeAsString('hello');

      expect(await repository.booksNotInLibrary(), isEmpty);
    });

    test('ignores a folder still being published by this device', () async {
      await publishToFolder(key: '.publishing-something');

      expect(await repository.booksNotInLibrary(), isEmpty);
    });

    test('has nothing to say when no folder has been chosen', () async {
      folders.folder = null;

      expect(await repository.booksNotInLibrary(), isEmpty);
    });

    test('has nothing to say when the folder cannot be opened', () async {
      folders.folder = const ShelfFolder(
        location: 'content://com.example/tree/opaque',
        access: ShelfFolderAccess.documentTree,
      );

      expect(await repository.booksNotInLibrary(), isEmpty);
    });
  });

  group('downloading', () {
    test('brings the book in with its chapters and cover', () async {
      await publishToFolder();

      final book = await repository.download('a-quiet-book-1');

      expect(book.title, 'A Quiet Book');
      expect(book.shelfKey, 'a-quiet-book-1');
      expect(book.duration, const Duration(hours: 2));
      expect(book.chapters, hasLength(2));
      expect(await File(book.chapters.first.filePath).readAsString(), 'first');
      expect(await File(book.coverPath!).exists(), isTrue);
      expect(await library.findById(book.id), isNotNull);
    });

    test('leaves the shelf once it is in the library', () async {
      await publishToFolder();
      await repository.download('a-quiet-book-1');

      expect(await repository.booksNotInLibrary(), isEmpty);
    });

    test('writes only into a folder of its own', () async {
      // A book already on the device, with audio of its own on disk.
      final existing = await Directory('${media.path}/existing').create();
      final guarded = File('${existing.path}/01.mp3');
      await guarded.writeAsString('do not touch');
      await library.save(
        localBook(
          id: 'existing',
          title: 'Something Else',
          sourcePath: guarded.path,
        ),
      );

      await publishToFolder();
      final book = await repository.download('a-quiet-book-1');

      expect(await guarded.readAsString(), 'do not touch');
      expect(book.id, isNot('existing'));
      expect(book.chapters.first.filePath, isNot(guarded.path));
    });

    test('refuses a book the library gained in the meantime', () async {
      await publishToFolder();
      await library.save(localBook());

      expect(
        () => repository.download('a-quiet-book-1'),
        throwsA(isA<FileAccessFailure>()),
      );
    });

    test('reports how far along it is', () async {
      await publishToFolder();
      final seen = <int>[];

      await repository.download(
        'a-quiet-book-1',
        onProgress: (copied, total) => seen.add(copied),
      );

      expect(seen, isNotEmpty);
      expect(seen.last, 'first'.length + 'second'.length);
    });

    test('asks the audio how long it runs when no manifest said', () async {
      await publishToFolder(
        key: 'Dropped In By Hand',
        withManifest: false,
        withCover: false,
      );

      final book = await repository.download('Dropped In By Hand');

      // Two files, each an hour according to the metadata service.
      expect(book.duration, const Duration(hours: 2));
    });

    test('leaves nothing behind when a book cannot be copied', () async {
      final directory = await publishToFolder();
      await File('${directory.path}/02.mp3').delete();

      await expectLater(
        repository.download('a-quiet-book-1'),
        throwsA(isA<FileAccessFailure>()),
      );
      expect(await media.list().isEmpty, isTrue);
      expect(await library.watchAll().first, isEmpty);
    });

    test('says so when the book is not on the shelf', () async {
      expect(
        () => repository.download('never-published'),
        throwsA(isA<FileAccessFailure>()),
      );
    });

    test('says so when no folder has been chosen', () async {
      folders.folder = null;

      expect(
        () => repository.download('a-quiet-book-1'),
        throwsA(isA<FileAccessFailure>()),
      );
    });
  });

  group('publishing', () {
    Future<Audiobook> bookOnDevice() async {
      final directory = await Directory('${media.path}/local-1').create();
      await File('${directory.path}/01.mp3').writeAsString('first');
      await File('${directory.path}/cover.jpg').writeAsString('art');
      final book =
          localBook(
            title: 'A Local Book',
            sourcePath: '${directory.path}/01.mp3',
          ).copyWith(
            coverPath: '${directory.path}/cover.jpg',
            chapters: [
              AudiobookChapter(
                id: 'local-1-chapter-0',
                bookId: 'local-1',
                title: 'Only',
                index: 0,
                filePath: '${directory.path}/01.mp3',
              ),
            ],
          );
      await library.save(book);
      return book;
    }

    test('writes the audio, the cover, and a manifest', () async {
      final book = await bookOnDevice();

      await repository.publish(book);

      final published = books.listSync().whereType<Directory>().single;
      expect(await File('${published.path}/01.mp3').readAsString(), 'first');
      expect(await File('${published.path}/cover.jpg').exists(), isTrue);

      final manifest = ShelfManifest.fromJson(
        jsonDecode(
          await File(
            '${published.path}/${ShelfManifest.fileName}',
          ).readAsString(),
        ),
      );
      expect(manifest, isNotNull);
      expect(manifest!.title, 'A Local Book');
      expect(manifest.chapters.single.file, '01.mp3');
    });

    test('remembers the key on the book it published', () async {
      final book = await bookOnDevice();

      await repository.publish(book);

      final saved = await library.findById(book.id);
      expect(saved!.shelfKey, isNotNull);
      expect(saved.shelfKey, startsWith('a-local-book-'));
    });

    test('leaves what another device published exactly as it is', () async {
      final book = await bookOnDevice();
      await repository.publish(book);
      final published = books.listSync().whereType<Directory>().single;
      await File('${published.path}/01.mp3').writeAsString('theirs');

      // The same book, published again from a device that has since changed
      // its copy. What is in the folder wins.
      await repository.publish((await library.findById(book.id))!);

      expect(await File('${published.path}/01.mp3').readAsString(), 'theirs');
    });

    test('leaves no staging folder behind when publishing fails', () async {
      final book = localBook(title: 'Gone Missing', sourcePath: null);
      await library.save(book);

      await expectLater(
        repository.publish(book),
        throwsA(isA<FileAccessFailure>()),
      );
      expect(books.listSync(), isEmpty);
    });
  });
}
