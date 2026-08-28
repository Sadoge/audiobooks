import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';

abstract interface class PlayerRepository {
  Stream<AudioPlaybackSnapshot> get playback;

  Future<void> open(Audiobook audiobook, {String? chapterId});

  Future<void> play();

  Future<void> pause();

  Future<void> seek(Duration position);

  Future<void> skipBy(Duration offset);

  Future<void> nextChapter();

  Future<void> previousChapter();

  Future<void> setSpeed(double speed);
}
