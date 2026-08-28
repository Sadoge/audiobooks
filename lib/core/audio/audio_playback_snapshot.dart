import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_playback_snapshot.freezed.dart';

enum PlaybackStatus { idle, loading, ready, playing, paused, completed, failed }

@freezed
abstract class AudioPlaybackSnapshot with _$AudioPlaybackSnapshot {
  const factory AudioPlaybackSnapshot({
    @Default(PlaybackStatus.idle) PlaybackStatus status,
    String? bookId,
    String? chapterId,
    @Default(Duration.zero) Duration position,
    @Default(Duration.zero) Duration bufferedPosition,
    @Default(Duration.zero) Duration duration,
    @Default(1) double speed,
    String? errorMessage,
  }) = _AudioPlaybackSnapshot;
}
