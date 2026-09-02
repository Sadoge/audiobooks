import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_file_metadata.freezed.dart';

/// A chapter marker embedded in a media file, timed against that file.
///
/// Only a start. Where a chapter ends is the next marker's start, which is how
/// the player already reads a book, so an end time a container happens to
/// carry would be discarded downstream. Should a layout ever need real gaps
/// between chapters, an `end` belongs here.
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

    /// What to call the book this file makes on its own.
    String? title,

    /// What to call this one file inside a book made of several.
    ///
    /// Named for the part it plays rather than the tag it came from, because
    /// the tag differs by container and only a parser knows which it is
    /// reading: an MP3 keeps the work's name in its album and the chapter's in
    /// its title, while an M4B has one name for both.
    String? trackTitle,
    String? author,
    String? narrator,
    @Default(<EmbeddedChapter>[]) List<EmbeddedChapter> chapters,
  }) = _AudioFileMetadata;
}
