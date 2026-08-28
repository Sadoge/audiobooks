import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';

/// Reads duration, tags, and embedded chapter markers from a local media file.
abstract interface class AudioMetadataService {
  /// Never throws: an unreadable or unsupported file yields empty metadata so
  /// an import degrades to a chapterless book instead of failing.
  Future<AudioFileMetadata> read(String path);
}
