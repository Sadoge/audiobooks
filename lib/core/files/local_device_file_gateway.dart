import 'dart:io';

import 'package:audiobooks/core/errors/app_failure.dart';
import 'package:audiobooks/core/files/device_file_gateway.dart';
import 'package:audiobooks/core/files/picked_audio_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@LazySingleton(as: DeviceFileGateway)
class LocalDeviceFileGateway implements DeviceFileGateway {
  static const _supportedExtensions = ['mp3', 'm4a', 'm4b', 'aac'];

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
  Future<String> persist(PickedAudioFile file, {required String bookId}) async {
    final sourcePath = file.path;
    if (sourcePath == null || !await File(sourcePath).exists()) {
      throw const FileAccessFailure(
        'The selected file is no longer available. Choose it again.',
      );
    }

    try {
      final documents = await getApplicationDocumentsDirectory();
      final directory = Directory(
        '${documents.path}${Platform.pathSeparator}media'
        '${Platform.pathSeparator}$bookId',
      );
      await directory.create(recursive: true);
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
  Future<bool> canRead(String durablePathOrUri) =>
      File(durablePathOrUri).exists();
}
