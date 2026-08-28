import 'dart:async';

import 'package:audiobooks/core/audio/audio_playback_service.dart';
import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/playback_progress.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/player/domain/repositories/player_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PlayerRepository)
class LocalPlayerRepository implements PlayerRepository {
  LocalPlayerRepository(this._service, this._audiobooks) {
    _subscription = _service.snapshots.listen(_handleSnapshot);
  }

  final AudioPlaybackService _service;
  final AudiobookRepository _audiobooks;
  // Retains the progress listener for the lifetime of this singleton.
  // ignore: unused_field
  late final StreamSubscription<AudioPlaybackSnapshot> _subscription;

  Audiobook? _activeBook;
  AudioPlaybackSnapshot _latest = const AudioPlaybackSnapshot();
  DateTime? _lastProgressWrite;

  @override
  Stream<AudioPlaybackSnapshot> get playback => _service.snapshots;

  @override
  Future<void> open(Audiobook audiobook, {String? chapterId}) async {
    _activeBook = audiobook;
    await _service.load(audiobook, chapterId: chapterId);
  }

  @override
  Future<void> play() => _service.play();

  @override
  Future<void> pause() => _service.pause();

  @override
  Future<void> seek(Duration position) => _service.seek(position);

  @override
  Future<void> skipBy(Duration offset) {
    final target = _latest.position + offset;
    final bounded = target < Duration.zero
        ? Duration.zero
        : _latest.duration > Duration.zero && target > _latest.duration
        ? _latest.duration
        : target;
    return _service.seek(bounded);
  }

  @override
  Future<void> nextChapter() => _service.skipToNextChapter();

  @override
  Future<void> previousChapter() => _service.skipToPreviousChapter();

  @override
  Future<void> setSpeed(double speed) => _service.setSpeed(speed);

  void _handleSnapshot(AudioPlaybackSnapshot snapshot) {
    _latest = snapshot;
    final book = _activeBook;
    if (book == null || snapshot.bookId != book.id) return;
    final chapterId = snapshot.chapterId;
    if (chapterId == null) return;

    final now = DateTime.now();
    final shouldWrite =
        _lastProgressWrite == null ||
        now.difference(_lastProgressWrite!) >= const Duration(seconds: 10) ||
        snapshot.status == PlaybackStatus.paused ||
        snapshot.status == PlaybackStatus.completed;
    if (!shouldWrite) return;

    _lastProgressWrite = now;
    unawaited(
      _audiobooks.updateProgress(
        PlaybackProgress(
          bookId: book.id,
          chapterId: chapterId,
          position: snapshot.position,
          updatedAt: now,
        ),
        isFinished: snapshot.status == PlaybackStatus.completed,
      ),
    );
  }
}
