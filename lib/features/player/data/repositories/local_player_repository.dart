import 'dart:async';

import 'package:audiobooks/core/audio/audio_playback_service.dart';
import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/playback_progress.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/player/domain/repositories/player_repository.dart';
import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';
import 'package:audiobooks/features/settings/domain/repositories/playback_settings_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PlayerRepository)
class LocalPlayerRepository implements PlayerRepository {
  LocalPlayerRepository(this._service, this._audiobooks, this._settings) {
    _subscription = _service.snapshots.listen(_handleSnapshot);
  }

  static const _writeInterval = Duration(seconds: 10);

  final AudioPlaybackService _service;
  final AudiobookRepository _audiobooks;
  final PlaybackSettingsRepository _settings;
  // Retains the progress listener for the lifetime of this singleton.
  // ignore: unused_field
  late final StreamSubscription<AudioPlaybackSnapshot> _subscription;

  Audiobook? _activeBook;
  AudioPlaybackSnapshot _latest = const AudioPlaybackSnapshot();
  DateTime? _lastProgressWrite;
  String? _lastChapterId;
  Duration _openedAt = Duration.zero;
  bool _recording = false;

  @override
  Stream<AudioPlaybackSnapshot> get playback => _service.snapshots;

  @override
  Future<void> open(
    Audiobook audiobook, {
    String? chapterId,
    Duration? position,
  }) async {
    _activeBook = audiobook;
    _latest = const AudioPlaybackSnapshot();
    _lastProgressWrite = null;
    _lastChapterId = null;
    _openedAt = Duration.zero;
    // Nothing is worth writing until this book is actually being listened to.
    _recording = false;

    final settings = await _loadSettings();

    if (chapterId != null || position != null) {
      await _service.load(
        audiobook,
        chapterId: chapterId,
        position: position ?? Duration.zero,
      );
      return _service.setSpeed(settings.speed);
    }

    // A book played to the end resumes at the end, where play does nothing.
    // Starting it over is what a listener coming back to it expects.
    final resume = audiobook.isFinished
        ? null
        : await _storedProgress(audiobook.id);
    _lastChapterId = resume?.chapterId;
    // Picking a book back up a moment before it was left is the listener's
    // choice, and it never steps back past the start of what it resumes into.
    _openedAt = _stepBack(
      resume?.bookPosition ?? Duration.zero,
      settings.resumeRewind,
    );
    await _service.load(
      audiobook,
      chapterId: resume?.chapterId,
      // Without a chapter the engine reads this as a whole book offset.
      position: resume == null
          ? Duration.zero
          : _stepBack(
              resume.chapterId == null ? resume.bookPosition : resume.position,
              settings.resumeRewind,
            ),
    );
    return _service.setSpeed(settings.speed);
  }

  @override
  Future<void> play() => _service.play();

  @override
  Future<void> pause() => _service.pause();

  @override
  Future<void> seek(Duration chapterPosition) => _service.seek(chapterPosition);

  @override
  Future<void> skipBy(Duration offset) => _service.skipBy(offset);

  @override
  Future<void> nextChapter() => _service.skipToNextChapter();

  @override
  Future<void> previousChapter() => _service.skipToPreviousChapter();

  @override
  Future<void> selectChapter(String chapterId) =>
      _service.seekToChapter(chapterId);

  @override
  Future<void> setSpeed(double speed) => _service.setSpeed(speed);

  @override
  Future<void> saveProgress() async {
    final book = _activeBook;
    if (book == null || !_recording || _latest.bookId != book.id) return;
    await _write(book.id, _latest);
  }

  /// The defaults a book opens on. A store that cannot be read leaves the
  /// player on the ordinary ones rather than refusing to open the book.
  Future<PlaybackSettings> _loadSettings() async {
    try {
      return await _settings.loadPlaybackSettings();
    } catch (_) {
      return const PlaybackSettings();
    }
  }

  Duration _stepBack(Duration position, Duration by) {
    final result = position - by;
    return result.isNegative ? Duration.zero : result;
  }

  Future<PlaybackProgress?> _storedProgress(String bookId) async {
    try {
      return await _audiobooks.findProgress(bookId);
    } catch (_) {
      // A book that cannot report where it was left still opens from the start.
      return null;
    }
  }

  void _handleSnapshot(AudioPlaybackSnapshot snapshot) {
    _latest = snapshot;
    final book = _activeBook;
    if (book == null || snapshot.bookId != book.id) return;
    if (!_isRecording(snapshot)) return;

    final now = DateTime.now();
    final chapterChanged = snapshot.chapterId != _lastChapterId;
    final due =
        _lastProgressWrite == null ||
        now.difference(_lastProgressWrite!) >= _writeInterval;
    final settled =
        snapshot.status == PlaybackStatus.paused ||
        snapshot.status == PlaybackStatus.completed;
    if (!due && !settled && !chapterChanged) return;

    _lastChapterId = snapshot.chapterId;
    _lastProgressWrite = now;
    unawaited(_write(book.id, snapshot));
  }

  /// Whether this snapshot describes a book being listened to rather than one
  /// still opening.
  ///
  /// A book reports position zero while it loads, and the resume seek lands
  /// only once playback is under way. Writing anything before then would erase
  /// the very place we are resuming to, so recording waits for the first real
  /// playing snapshot and continues from there.
  bool _isRecording(AudioPlaybackSnapshot snapshot) {
    if (_recording) return true;
    if (snapshot.status != PlaybackStatus.playing) return false;
    if (_openedAt > Duration.zero && snapshot.bookPosition == Duration.zero) {
      return false;
    }
    return _recording = true;
  }

  Future<void> _write(String bookId, AudioPlaybackSnapshot snapshot) async {
    try {
      await _audiobooks.updateProgress(
        PlaybackProgress(
          bookId: bookId,
          chapterId: snapshot.chapterId,
          position: snapshot.position,
          bookPosition: snapshot.bookPosition,
          updatedAt: DateTime.now(),
        ),
        isFinished: snapshot.status == PlaybackStatus.completed,
      );
    } catch (_) {
      // Progress is written continuously, so a failed write is not worth
      // interrupting playback for: the next one will carry the same place.
    }
  }
}
