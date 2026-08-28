import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_state.freezed.dart';

enum PlayerViewStatus { loading, ready, failure }

@freezed
abstract class PlayerViewState with _$PlayerViewState {
  const factory PlayerViewState({
    @Default(PlayerViewStatus.loading) PlayerViewStatus status,
    Audiobook? book,
    @Default(AudioPlaybackSnapshot()) AudioPlaybackSnapshot playback,
    String? errorMessage,
  }) = _PlayerViewState;
}
