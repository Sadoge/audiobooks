import 'package:audiobooks/core/files/picked_audio_file.dart';

/// Isolates document-provider access and future security-scoped URI handling.
abstract interface class DeviceFileGateway {
  Future<List<PickedAudioFile>> pickAudioFiles({bool allowMultiple = true});

  /// Copies provider-backed temporary files into app-owned durable storage.
  /// The copy is streamed by the platform file APIs and is never loaded whole.
  Future<String> persist(PickedAudioFile file, {required String bookId});

  Future<bool> canRead(String durablePathOrUri);
}
