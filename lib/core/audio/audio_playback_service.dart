import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';

/// Owns the platform audio engine and survives presentation-route changes.
///
/// Positions crossing this boundary are chapter relative, except where a name
/// says otherwise, so callers never have to know whether a book is one file or
/// many.
abstract interface class AudioPlaybackService {
  Stream<AudioPlaybackSnapshot> get snapshots;

  /// Opens [audiobook] at [position] inside [chapterId].
  ///
  /// When [chapterId] is null, [position] is read as a whole book offset and
  /// the matching chapter is resolved from it.
  Future<void> load(
    Audiobook audiobook, {
    String? chapterId,
    Duration position = Duration.zero,
  });

  Future<void> play();

  Future<void> pause();

  Future<void> seek(Duration chapterPosition);

  /// Moves by [offset] along the book, crossing chapter boundaries.
  Future<void> skipBy(Duration offset);

  /// Jumps to the start of a chapter without reopening the book.
  Future<void> seekToChapter(String chapterId);

  Future<void> skipToNextChapter();

  Future<void> skipToPreviousChapter();

  Future<void> setSpeed(double speed);

  Future<void> stop();

  Future<void> dispose();
}
