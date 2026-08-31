import 'dart:async';

import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/player/domain/repositories/player_repository.dart';
import 'package:audiobooks/features/player/presentation/cubit/player_state.dart';
import 'package:audiobooks/features/settings/domain/repositories/playback_settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PlayerCubit extends Cubit<PlayerViewState> {
  PlayerCubit(this._player, this._audiobooks, this._settings)
    : super(const PlayerViewState());

  final PlayerRepository _player;
  final AudiobookRepository _audiobooks;
  final PlaybackSettingsRepository _settings;
  StreamSubscription<AudioPlaybackSnapshot>? _subscription;

  /// Opens a book. Without [chapterId] it continues from the stored place.
  Future<void> load(String bookId, {String? chapterId}) async {
    emit(const PlayerViewState());
    // The wheel is labelled with the intervals it will actually step by, so
    // the defaults are read before anything is drawn.
    final settings = await _settings.loadPlaybackSettings();
    final book = await _audiobooks.findById(bookId);
    if (book == null) {
      emit(
        PlayerViewState(
          status: PlayerViewStatus.failure,
          settings: settings,
          errorMessage: 'This audiobook is no longer in your library.',
        ),
      );
      return;
    }

    await _subscription?.cancel();
    _subscription = _player.playback
        .where((snapshot) => snapshot.bookId == book.id)
        .listen(
          (playback) => emit(
            state.copyWith(
              status: playback.status == PlaybackStatus.failed
                  ? PlayerViewStatus.failure
                  : PlayerViewStatus.ready,
              book: book,
              playback: playback,
              errorMessage: playback.errorMessage,
            ),
          ),
        );

    emit(state.copyWith(book: book, settings: settings));
    await _player.open(book, chapterId: chapterId);
  }

  Future<void> togglePlayback() =>
      state.playback.status == PlaybackStatus.playing
      ? _player.pause()
      : _player.play();

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> rewind() => _player.skipBy(-state.settings.rewindInterval);

  Future<void> forward() => _player.skipBy(state.settings.forwardInterval);

  Future<void> nextChapter() => _player.nextChapter();

  Future<void> previousChapter() => _player.previousChapter();

  Future<void> selectChapter(String chapterId) async {
    await _player.selectChapter(chapterId);
    await _player.play();
  }

  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> close() async {
    // Leaving the player is the moment a listener most expects to be
    // remembered, so do not wait for the next interval write.
    await _player.saveProgress();
    await _subscription?.cancel();
    return super.close();
  }
}
