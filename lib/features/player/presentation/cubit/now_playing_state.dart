import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'now_playing_state.freezed.dart';

/// What is on the player right now, as seen from anywhere but the player.
@freezed
abstract class NowPlayingState with _$NowPlayingState {
  const factory NowPlayingState({
    Audiobook? book,
    @Default(AudioPlaybackSnapshot()) AudioPlaybackSnapshot playback,
  }) = _NowPlayingState;

  const NowPlayingState._();

  /// Whether there is a book loaded worth offering a way back to.
  ///
  /// A book that failed to open is not one: there is nothing to return to and
  /// the player already said so.
  bool get hasBook =>
      book != null &&
      playback.bookId == book!.id &&
      playback.status != PlaybackStatus.idle &&
      playback.status != PlaybackStatus.failed;

  bool get isPlaying => playback.status == PlaybackStatus.playing;

  /// The chapter playing now, when the book is divided into any.
  String? get chapterTitle {
    final chapters = book?.chapters ?? const [];
    final index = playback.chapterIndex;
    if (chapters.length < 2 || index < 0 || index >= chapters.length) {
      return null;
    }
    return chapters[index].title;
  }
}
