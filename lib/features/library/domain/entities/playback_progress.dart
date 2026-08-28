import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_progress.freezed.dart';

@freezed
abstract class PlaybackProgress with _$PlaybackProgress {
  const factory PlaybackProgress({
    required String bookId,
    required String chapterId,
    required Duration position,
    required DateTime updatedAt,
  }) = _PlaybackProgress;
}
