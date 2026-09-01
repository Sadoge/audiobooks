import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_state.freezed.dart';

enum PlayerViewStatus { loading, ready, failure }

@freezed
abstract class PlayerViewState with _$PlayerViewState {
  const factory PlayerViewState({
    @Default(PlayerViewStatus.loading) PlayerViewStatus status,
    Audiobook? book,
    @Default(AudioPlaybackSnapshot()) AudioPlaybackSnapshot playback,

    /// The defaults this sitting started from: what the wheel's skip keys
    /// step by, and the speed the book was opened at.
    @Default(PlaybackSettings()) PlaybackSettings settings,
    String? errorMessage,
  }) = _PlayerViewState;
}
