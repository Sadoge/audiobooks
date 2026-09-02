import 'package:audiobooks/features/library/domain/entities/audiobook.dart';

/// The `shelf.json` sitting beside a published book's audio.
///
/// It exists so that reading the shelf never has to open the audio. Lifting
/// tags out of an MP3 means reading the file, and in a folder kept online-only
/// by a sync client that means pulling hundreds of megabytes down to draw one
/// row. A manifest costs a few hundred bytes.
///
/// It also carries the size of every file it names, which is what tells a
/// reader that a book has finished arriving: a book uploads file by file, so
/// one that is short of what the manifest promises is still on its way.
class ShelfManifest {
  const ShelfManifest({
    required this.key,
    required this.title,
    required this.author,
    required this.fileType,
    required this.duration,
    required this.files,
    required this.chapters,
    this.narrator,
    this.cover,
    this.publishedAt,
  });

  /// Bumped only when a reader could not make sense of an older folder.
  static const formatVersion = 1;

  static const fileName = 'shelf.json';

  final String key;
  final String title;
  final String author;
  final String? narrator;
  final AudioFileType fileType;
  final Duration duration;

  /// The cover's file name inside the book folder, when it has one.
  final String? cover;
  final DateTime? publishedAt;

  /// Every audio file the book is made of, in the order they play.
  final List<ShelfManifestFile> files;

  /// Empty for a book that is one unmarked file.
  final List<ShelfManifestChapter> chapters;

  int get totalBytes => files.fold(0, (total, file) => total + file.sizeBytes);

  Map<String, Object?> toJson() => {
    'formatVersion': formatVersion,
    'key': key,
    'title': title,
    'author': author,
    if (narrator != null) 'narrator': narrator,
    'fileType': fileType.name,
    'durationMs': duration.inMilliseconds,
    if (cover != null) 'cover': cover,
    if (publishedAt != null) 'publishedAt': publishedAt!.toIso8601String(),
    'files': [for (final file in files) file.toJson()],
    'chapters': [for (final chapter in chapters) chapter.toJson()],
  };

  /// Reads a manifest, or gives back null when it is not one this app wrote
  /// and can still understand.
  ///
  /// Anything malformed is a book that is skipped rather than an error shown
  /// to the listener: a folder synced from elsewhere may hold all sorts of
  /// things, and none of them are the listener's mistake.
  static ShelfManifest? fromJson(Object? decoded) {
    if (decoded is! Map<String, Object?>) return null;

    final version = decoded['formatVersion'];
    if (version is! int || version > formatVersion) return null;

    final key = decoded['key'];
    final title = decoded['title'];
    final author = decoded['author'];
    if (key is! String || key.isEmpty) return null;
    if (title is! String || title.isEmpty) return null;
    if (author is! String) return null;

    final rawFiles = decoded['files'];
    if (rawFiles is! List || rawFiles.isEmpty) return null;
    final files = <ShelfManifestFile>[];
    for (final entry in rawFiles) {
      final file = ShelfManifestFile.fromJson(entry);
      if (file == null) return null;
      files.add(file);
    }

    final chapters = <ShelfManifestChapter>[];
    if (decoded['chapters'] case final List rawChapters) {
      for (final entry in rawChapters) {
        final chapter = ShelfManifestChapter.fromJson(entry);
        if (chapter == null) return null;
        chapters.add(chapter);
      }
    }

    // A chapter naming a file the manifest does not list would import as a
    // book with a gap in it, so the whole manifest is refused instead.
    final names = {for (final file in files) file.name};
    if (chapters.any((chapter) => !names.contains(chapter.file))) return null;

    return ShelfManifest(
      key: key,
      title: title,
      author: author,
      narrator: decoded['narrator'] as String?,
      fileType:
          AudioFileType.values
              .where((type) => type.name == decoded['fileType'])
              .firstOrNull ??
          AudioFileType.mp3,
      duration: Duration(
        milliseconds: switch (decoded['durationMs']) {
          final int value when value >= 0 => value,
          _ => 0,
        },
      ),
      cover: decoded['cover'] as String?,
      publishedAt: switch (decoded['publishedAt']) {
        final String value => DateTime.tryParse(value),
        _ => null,
      },
      files: files,
      chapters: chapters,
    );
  }
}

class ShelfManifestFile {
  const ShelfManifestFile({required this.name, required this.sizeBytes});

  final String name;
  final int sizeBytes;

  Map<String, Object?> toJson() => {'name': name, 'sizeBytes': sizeBytes};

  static ShelfManifestFile? fromJson(Object? decoded) {
    if (decoded is! Map<String, Object?>) return null;
    final name = decoded['name'];
    final size = decoded['sizeBytes'];
    if (name is! String || name.isEmpty || !_isPlainFileName(name)) return null;
    if (size is! int || size < 0) return null;
    return ShelfManifestFile(name: name, sizeBytes: size);
  }
}

class ShelfManifestChapter {
  const ShelfManifestChapter({
    required this.title,
    required this.file,
    required this.start,
    required this.duration,
  });

  final String title;

  /// The file this chapter plays out of, which for a book split across files
  /// is its own, and for a marked single file is the one file.
  final String file;

  /// Where the chapter begins inside [file].
  final Duration start;
  final Duration duration;

  Map<String, Object?> toJson() => {
    'title': title,
    'file': file,
    'startMs': start.inMilliseconds,
    'durationMs': duration.inMilliseconds,
  };

  static ShelfManifestChapter? fromJson(Object? decoded) {
    if (decoded is! Map<String, Object?>) return null;
    final title = decoded['title'];
    final file = decoded['file'];
    if (title is! String) return null;
    if (file is! String || file.isEmpty || !_isPlainFileName(file)) return null;

    return ShelfManifestChapter(
      title: title,
      file: file,
      start: Duration(
        milliseconds: switch (decoded['startMs']) {
          final int value when value >= 0 => value,
          _ => 0,
        },
      ),
      duration: Duration(
        milliseconds: switch (decoded['durationMs']) {
          final int value when value >= 0 => value,
          _ => 0,
        },
      ),
    );
  }
}

/// Whether a name is a file sitting directly in the book's folder.
///
/// A manifest arrives from another device and is not trusted to be honest: a
/// name carrying a separator or a parent reference would otherwise let a
/// folder reach out of itself and be copied over something else entirely.
bool _isPlainFileName(String name) =>
    !name.contains('/') &&
    !name.contains(r'\') &&
    name != '.' &&
    name != '..' &&
    !name.startsWith('.');
