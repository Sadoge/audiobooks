import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';

/// Owns the platform audio engine and survives presentation-route changes.
abstract interface class AudioPlaybackService {
  Stream<AudioPlaybackSnapshot> get snapshots;

  Future<void> load(Audiobook audiobook, {String? chapterId});

  Future<void> play();

  Future<void> pause();

  Future<void> seek(Duration position);

  Future<void> skipToNextChapter();

  Future<void> skipToPreviousChapter();

  Future<void> setSpeed(double speed);

  Future<void> stop();

  Future<void> dispose();
}
