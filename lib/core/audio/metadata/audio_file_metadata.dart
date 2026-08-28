import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_file_metadata.freezed.dart';

/// A chapter marker embedded in a media file, timed against that file.
@freezed
abstract class EmbeddedChapter with _$EmbeddedChapter {
  const factory EmbeddedChapter({
    required String title,
    required Duration start,
  }) = _EmbeddedChapter;
}

/// What a single media file can tell us about itself before playback starts.
@freezed
abstract class AudioFileMetadata with _$AudioFileMetadata {
  const factory AudioFileMetadata({
    @Default(Duration.zero) Duration duration,
    String? title,
    String? author,
    String? narrator,
    @Default(<EmbeddedChapter>[]) List<EmbeddedChapter> chapters,
  }) = _AudioFileMetadata;
}
