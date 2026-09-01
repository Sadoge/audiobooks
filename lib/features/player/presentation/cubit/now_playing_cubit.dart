import 'dart:async';

import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/player/domain/repositories/player_repository.dart';
import 'package:audiobooks/features/player/presentation/cubit/now_playing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Follows whatever is playing, wherever the listener happens to be.
///
/// The player page has its own cubit, opened and closed with the page. This
/// one is opened once with the app and never closed, because playback now
/// outlives every screen: a book carries on with the app in the background,
/// and the Library needs to say so whether or not the player was ever drawn.
@lazySingleton
class NowPlayingCubit extends Cubit<NowPlayingState> {
  NowPlayingCubit(this._player, this._audiobooks)
    : super(const NowPlayingState()) {
    _subscription = _player.playback.listen(_onPlayback);
  }

  final PlayerRepository _player;
  final AudiobookRepository _audiobooks;
  late final StreamSubscription<AudioPlaybackSnapshot> _subscription;

  /// The book being looked up, so that a burst of snapshots for a book that
  /// has just opened does not start a lookup each.
  String? _resolving;

  Future<void> togglePlayback() =>
      state.isPlaying ? _player.pause() : _player.play();

  Future<void> nextChapter() => _player.nextChapter();

  /// Restarts the chapter first, then steps back a chapter, the way the
  /// player's own wheel key and every physical transport control does.
  Future<void> previousChapter() => _player.previousChapter();

  void _onPlayback(AudioPlaybackSnapshot playback) {
    if (isClosed) return;
    emit(state.copyWith(playback: playback));

    final bookId = playback.bookId;
    if (bookId == null || bookId == state.book?.id || bookId == _resolving) {
      return;
    }
    _resolving = bookId;
    unawaited(_resolveBook(bookId));
  }

  Future<void> _resolveBook(String bookId) async {
    try {
      final book = await _audiobooks.findById(bookId);
      // A snapshot for another book may have arrived while this was in flight;
      // the bar follows the engine, not the slower of the two.
      if (isClosed || book == null || state.playback.bookId != bookId) return;
      emit(state.copyWith(book: book));
    } catch (_) {
      // Without a title there is nothing to put on the bar, and the Library
      // below it is unharmed. The next book that opens tries again.
    } finally {
      if (_resolving == bookId) _resolving = null;
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
