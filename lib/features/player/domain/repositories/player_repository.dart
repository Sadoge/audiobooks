import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';

abstract interface class PlayerRepository {
  Stream<AudioPlaybackSnapshot> get playback;

  /// Opens [audiobook]. With no chapter or position given, playback picks up
  /// wherever this book was last left.
  Future<void> open(
    Audiobook audiobook, {
    String? chapterId,
    Duration? position,
  });

  Future<void> play();

  Future<void> pause();

  Future<void> seek(Duration chapterPosition);

  Future<void> skipBy(Duration offset);

  Future<void> nextChapter();

  Future<void> previousChapter();

  Future<void> selectChapter(String chapterId);

  Future<void> setSpeed(double speed);

  /// Stores the current position now rather than at the next interval.
  Future<void> saveProgress();
}
