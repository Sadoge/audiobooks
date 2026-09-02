import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';
import 'package:audiobooks/core/audio/metadata/audio_metadata_service.dart';
import 'package:audiobooks/core/audio/metadata/byte_source.dart';
import 'package:audiobooks/core/audio/metadata/chapter_markers.dart';
import 'package:audiobooks/core/audio/metadata/cover_art.dart';
import 'package:audiobooks/core/audio/metadata/id3_cover_art_parser.dart';
import 'package:audiobooks/core/audio/metadata/id3_metadata_parser.dart';
import 'package:audiobooks/core/audio/metadata/mp4_metadata_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

/// Reads what a file declares about itself, then asks the audio engine for
/// anything the container did not answer.
///
/// The container is tried first because it is cheap and it is the only place
/// chapter markers live. The engine probe answers for a file whose header
/// declares no duration, chiefly MP3: an ID3 tag names the book and its
/// chapters but says nothing trustworthy about how long the audio runs.
@LazySingleton(as: AudioMetadataService)
class LocalAudioMetadataService implements AudioMetadataService {
  const LocalAudioMetadataService();

  static const _parser = Mp4MetadataParser();
  static const _id3 = Id3CoverArtParser();
  static const _id3Metadata = Id3MetadataParser();

  @override
  Future<AudioFileMetadata> read(String path) async {
    final parsed = await _readContainer(path) ?? const AudioFileMetadata();
    final duration = parsed.duration > Duration.zero
        ? parsed.duration
        : await _probeDuration(path);

    // Markers can only be measured against the media once its length is known,
    // which for an MP3 is not until the engine has answered.
    return parsed.copyWith(
      duration: duration,
      chapters: sanitiseChapters(parsed.chapters, duration),
    );
  }

  /// MP3 keeps its artwork in an ID3 tag at the head of the file and MP4
  /// keeps it in a `covr` box, so the first bytes decide which reader answers.
  @override
  Future<CoverArt?> readCoverArt(String path) async {
    ByteSource? source;
    try {
      source = FileByteSource.open(path);
      return await _isId3(source)
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
      return await _isId3(source)
          ? await _id3Metadata.parse(source)
          : await _parser.parse(source);
    } catch (_) {
      return null;
    } finally {
      await source?.close();
    }
  }

  /// Whether the file opens with an ID3 tag, which is what tells an MP3 from
  /// an MP4 before either reader is asked.
  Future<bool> _isId3(ByteSource source) async {
    final head = await source.read(0, 3);
    return head.length == 3 &&
        head[0] == 0x49 &&
        head[1] == 0x44 &&
        head[2] == 0x33;
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
