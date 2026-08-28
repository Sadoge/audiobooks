import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_progress.freezed.dart';

/// Where a listener stopped, kept so returning to a book resumes it.
@freezed
abstract class PlaybackProgress with _$PlaybackProgress {
  const factory PlaybackProgress({
    required String bookId,

    /// Null for books that have no chapters at all.
    String? chapterId,

    /// Offset inside [chapterId], or inside the book when it has no chapters.
    required Duration position,

    /// Offset on the whole book timeline, used for library progress.
    @Default(Duration.zero) Duration bookPosition,
    required DateTime updatedAt,
  }) = _PlaybackProgress;
}
