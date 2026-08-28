import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';
import 'package:audiobooks/core/audio/metadata/audio_metadata_service.dart';
import 'package:audiobooks/core/audio/metadata/byte_source.dart';
import 'package:audiobooks/core/audio/metadata/cover_art.dart';
import 'package:audiobooks/core/audio/metadata/id3_cover_art_parser.dart';
import 'package:audiobooks/core/audio/metadata/mp4_metadata_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

/// Reads what a file declares about itself, then asks the audio engine for
/// anything the container did not answer.
///
/// The container is tried first because it is cheap and it is the only place
/// chapter markers live. The engine probe is the fallback for formats without
/// a readable header, chiefly MP3.
@LazySingleton(as: AudioMetadataService)
class LocalAudioMetadataService implements AudioMetadataService {
  const LocalAudioMetadataService();

  static const _parser = Mp4MetadataParser();
  static const _id3 = Id3CoverArtParser();

  @override
  Future<AudioFileMetadata> read(String path) async {
    final parsed = await _readContainer(path);
    if (parsed != null && parsed.duration > Duration.zero) return parsed;

    final probed = await _probeDuration(path);
    return (parsed ?? const AudioFileMetadata()).copyWith(duration: probed);
  }

  /// MP3 keeps its artwork in an ID3 tag at the head of the file and MP4
  /// keeps it in a `covr` box, so the first bytes decide which reader answers.
  @override
  Future<CoverArt?> readCoverArt(String path) async {
    ByteSource? source;
    try {
      source = FileByteSource.open(path);
      final head = await source.read(0, 3);
      final tagged =
          head.length == 3 &&
          head[0] == 0x49 &&
          head[1] == 0x44 &&
          head[2] == 0x33;
      return tagged
          ? await _id3.parse(source)
          : await _parser.parseCoverArt(source);
    } catch (_) {
      return null;
    } finally {
      await source?.close();
    }
  }

  Future<AudioFileMetadata?> _readContainer(String path) async {
    ByteSource? source;
    try {
      source = FileByteSource.open(path);
      return await _parser.parse(source);
    } catch (_) {
      return null;
    } finally {
      await source?.close();
    }
  }

  Future<Duration> _probeDuration(String path) async {
    final player = AudioPlayer();
    try {
      return await player.setAudioSource(AudioSource.file(path)) ??
          Duration.zero;
    } catch (_) {
      return Duration.zero;
    } finally {
      await player.dispose();
    }
  }
}
