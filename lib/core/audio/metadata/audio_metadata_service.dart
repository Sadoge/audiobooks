import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';
import 'package:audiobooks/core/audio/metadata/cover_art.dart';

/// Reads duration, tags, embedded chapter markers, and cover art from a local
/// media file.
abstract interface class AudioMetadataService {
  /// Never throws: an unreadable or unsupported file yields empty metadata so
  /// an import degrades to a chapterless book instead of failing.
  Future<AudioFileMetadata> read(String path);

  /// The artwork stored inside the file, or null when it carries none.
  ///
  /// Never throws, and is read on its own so the bytes of a cover are only
  /// held while a book is being given one.
  Future<CoverArt?> readCoverArt(String path);
}
