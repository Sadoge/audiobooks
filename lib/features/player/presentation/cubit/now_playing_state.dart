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

  /// Whether the book is divided into chapters worth stepping between.
  ///
  /// The same test the player's wheel uses for its own chapter keys, so a book
  /// that offers them in one place offers them in the other.
  bool get hasChapters => (book?.chapters.length ?? 0) > 1;

  /// The chapter playing now, when the book is divided into any.
  String? get chapterTitle {
    final chapters = book?.chapters ?? const [];
    final index = playback.chapterIndex;
    if (chapters.length < 2 || index < 0 || index >= chapters.length) {
      return null;
    }
    return chapters[index].title;
  }

  /// Where the chapter has got to. The bar counts the chapter rather than the
  /// book, so its readout and the player's scrubber never disagree.
  Duration get position => playback.position;

  /// How long that chapter runs, falling back to what the library recorded
  /// until the engine has worked it out for itself.
  Duration get chapterDuration {
    if (playback.duration > Duration.zero) return playback.duration;
    final chapters = book?.chapters ?? const [];
    final index = playback.chapterIndex;
    if (index >= 0 && index < chapters.length) return chapters[index].duration;
    return book?.duration ?? Duration.zero;
  }

  /// What is left of the chapter, or null while nothing knows its length.
  Duration? get chapterRemaining {
    if (chapterDuration <= Duration.zero) return null;
    final left = chapterDuration - position;
    return left.isNegative ? Duration.zero : left;
  }

  /// How far through the chapter is, as a fraction, or null while its length
  /// is still unknown and a progress line would be a guess.
  double? get chapterProgress {
    final total = chapterDuration.inMilliseconds;
    if (total <= 0) return null;
    return (position.inMilliseconds / total).clamp(0.0, 1.0);
  }
}
