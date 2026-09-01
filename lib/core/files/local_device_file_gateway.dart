import 'dart:io';

import 'package:audiobooks/core/audio/metadata/cover_art.dart';
import 'package:audiobooks/core/errors/app_failure.dart';
import 'package:audiobooks/core/files/device_file_gateway.dart';
import 'package:audiobooks/core/files/picked_audio_file.dart';
import 'package:audiobooks/core/images/square_cover_encoder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@LazySingleton(as: DeviceFileGateway)
class LocalDeviceFileGateway implements DeviceFileGateway {
  static const _supportedExtensions = ['mp3', 'm4a', 'm4b', 'aac'];
  static const _square = SquareCoverEncoder();

  /// The shape of a cover this app has written, which is what makes replacing
  /// one safe: audio a listener imported can never match it.
  static final _storedCover = RegExp(
    '^cover-[0-9]+[.](${CoverArt.supportedExtensions.join('|')})\$',
  );

  /// File names taggers and download tools give to a folder's cover, in the
  /// order they are trusted.
  static const _coverFileNames = [
    'cover',
    'folder',
    'front',
    'album',
    'albumart',
    'artwork',
  ];

  @override
  Future<List<PickedAudioFile>> pickAudioFiles({
    bool allowMultiple = true,
  }) async {
    final result = allowMultiple
        ? await FilePicker.pickFiles(
            type: FileType.custom,
            allowedExtensions: _supportedExtensions,
          )
        : [
            ?await FilePicker.pickFile(
              type: FileType.custom,
              allowedExtensions: _supportedExtensions,
            ),
          ];
    if (result.isEmpty) return const [];

    return Future.wait(
      result.map(
        (file) async => PickedAudioFile(
          name: file.name,
          sizeBytes: await file.length(),
          extension: (file.extension ?? '').toLowerCase(),
          path: file.path,
        ),
      ),
    );
  }

  @override
  Future<String?> pickCoverImage() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: CoverArt.supportedExtensions,
    );
    return file?.path;
  }

  @override
  Future<String> persist(PickedAudioFile file, {required String bookId}) async {
    final sourcePath = file.path;
    if (sourcePath == null || !await File(sourcePath).exists()) {
      throw const FileAccessFailure(
        'The selected file is no longer available. Choose it again.',
      );
    }

    try {
      final directory = await _bookDirectory(bookId);
      final safeName = file.name.replaceAll(RegExp(r'[^a-zA-Z0-9._ -]'), '_');
      final destination = '${directory.path}${Platform.pathSeparator}$safeName';
      await File(sourcePath).copy(destination);
      return destination;
    } catch (error) {
      throw FileAccessFailure(
        'The selected audio file could not be stored for offline use.',
        cause: error,
      );
    }
  }

  @override
  Future<String?> persistCoverBytes(
    CoverArt cover, {
    required String bookId,
  }) async {
    try {
      final art = await _square.square(cover) ?? cover;
      final directory = await _bookDirectory(bookId);
      final destination = _coverDestination(directory, art.extension);
      await File(destination).writeAsBytes(art.bytes, flush: true);
      await _removeOtherCovers(directory, keep: destination);
      return destination;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> persistCoverFile(
    String sourcePath, {
    required String bookId,
  }) async {
    try {
      final source = File(sourcePath);
      if (!await source.exists()) return null;
      if (await source.length() > CoverArt.maxBytes) return null;

      final extension = _imageExtensionOf(sourcePath);
      if (extension == null) return null;

      final directory = await _bookDirectory(bookId);
      // An image the picker or a folder handed over is squared like any
      // other; one this app cannot read is copied across untouched.
      final original = CoverArt.from(await source.readAsBytes());
      if (original == null) {
        final destination = _coverDestination(directory, extension);
        await source.copy(destination);
        await _removeOtherCovers(directory, keep: destination);
        return destination;
      }

      final art = await _square.square(original) ?? original;
      final destination = _coverDestination(directory, art.extension);
      await File(destination).writeAsBytes(art.bytes, flush: true);
      await _removeOtherCovers(directory, keep: destination);
      return destination;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> findCoverBeside(PickedAudioFile file) async {
    final sourcePath = file.path;
    if (sourcePath == null) return null;

    try {
      final folder = File(sourcePath).parent;
      if (!await folder.exists()) return null;

      final images = <String, String>{};
      await for (final entity in folder.list(followLinks: false)) {
        if (entity is! File) continue;
        final name = entity.path.split(Platform.pathSeparator).last;
        if (_imageExtensionOf(name) == null) continue;
        images[_withoutExtension(name).toLowerCase()] = entity.path;
      }
      if (images.isEmpty) return null;

      // An image named after the book or after the usual cover names is the
      // cover; so is a lone image, which is what a ripped folder holds.
      for (final candidate in [
        _withoutExtension(file.name).toLowerCase(),
        ..._coverFileNames,
      ]) {
        if (images[candidate] case final match?) return match;
      }
      return images.length == 1 ? images.values.first : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteBookFiles(String bookId) async {
    try {
      final documents = await getApplicationDocumentsDirectory();
      final directory = Directory(_bookPath(documents.path, bookId));
      if (await directory.exists()) await directory.delete(recursive: true);
    } catch (_) {
      // The book is already out of the library; files left behind are only
      // storage, and are overwritten if it is imported again.
    }
  }

  @override
  Future<int?> storedMediaBytes() async {
    try {
      final documents = await getApplicationDocumentsDirectory();
      final media = Directory(_mediaPath(documents.path));
      if (!await media.exists()) return 0;

      var total = 0;
      await for (final entity in media.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File) total += await entity.length();
      }
      return total;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> canRead(String durablePathOrUri) =>
      File(durablePathOrUri).exists();

  Future<Directory> _bookDirectory(String bookId) async {
    final documents = await getApplicationDocumentsDirectory();
    return Directory(
      _bookPath(documents.path, bookId),
    ).create(recursive: true);
  }

  String _mediaPath(String documentsPath) =>
      '$documentsPath${Platform.pathSeparator}media';

  String _bookPath(String documentsPath, String bookId) =>
      '${_mediaPath(documentsPath)}${Platform.pathSeparator}$bookId';

  /// Every cover gets a fresh name so that replacing one is visible
  /// immediately: Flutter caches decoded images by path.
  String _coverDestination(Directory directory, String extension) =>
      '${directory.path}${Platform.pathSeparator}'
      'cover-${DateTime.now().microsecondsSinceEpoch}.$extension';

  Future<void> _removeOtherCovers(
    Directory directory, {
    required String keep,
  }) async {
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is! File || entity.path == keep) continue;
      final name = entity.path.split(Platform.pathSeparator).last;
      if (_storedCover.hasMatch(name)) await entity.delete();
    }
  }

  String? _imageExtensionOf(String path) {
    final dot = path.lastIndexOf('.');
    if (dot <= 0) return null;
    final extension = path.substring(dot + 1).toLowerCase();
    return CoverArt.supportedExtensions.contains(extension) ? extension : null;
  }

  String _withoutExtension(String name) {
    final dot = name.lastIndexOf('.');
    return dot <= 0 ? name : name.substring(0, dot);
  }
}
