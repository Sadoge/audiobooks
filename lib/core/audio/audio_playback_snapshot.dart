import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_playback_snapshot.freezed.dart';

enum PlaybackStatus { idle, loading, ready, playing, paused, completed, failed }

/// What the audio engine is doing right now.
///
/// Times come in two flavours. [position] and [duration] describe the chapter
/// being listened to, which is what the transport controls scrub. [bookPosition]
/// and [bookDuration] describe the whole book, which is what progress and
/// resume are stored against. For a book without chapters the two agree.
@freezed
abstract class AudioPlaybackSnapshot with _$AudioPlaybackSnapshot {
  const factory AudioPlaybackSnapshot({
    @Default(PlaybackStatus.idle) PlaybackStatus status,
    String? bookId,
    String? chapterId,
    @Default(-1) int chapterIndex,
    @Default(0) int chapterCount,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration bufferedPosition,
    @Default(Duration.zero) Duration duration,
    @Default(Duration.zero) Duration bookPosition,
    @Default(Duration.zero) Duration bookDuration,
    @Default(1) double speed,
    String? errorMessage,
  }) = _AudioPlaybackSnapshot;
}
