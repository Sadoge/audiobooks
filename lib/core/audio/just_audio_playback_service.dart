import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:audiobooks/core/audio/audio_playback_service.dart';
import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/core/audio/chapter_timeline.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

@LazySingleton(as: AudioPlaybackService)
class JustAudioPlaybackService implements AudioPlaybackService {
  JustAudioPlaybackService() {
    _subscriptions.addAll([
      _player.playerStateStream.listen((_) => _emitSnapshot()),
      _player.positionStream.listen((_) => _emitSnapshot()),
      _player.bufferedPositionStream.listen((_) => _emitSnapshot()),
      _player.durationStream.listen((_) => _emitSnapshot()),
      _player.speedStream.listen((_) => _emitSnapshot()),
      _player.currentIndexStream.listen((_) => _emitSnapshot()),
      _player.errorStream.listen(
        (error) => _emitSnapshot(errorMessage: error.message),
      ),
    ]);
  }

  final AudioPlayer _player = AudioPlayer();
  final StreamController<AudioPlaybackSnapshot> _snapshots =
      StreamController<AudioPlaybackSnapshot>.broadcast();
  final List<StreamSubscription<Object?>> _subscriptions = [];

  Audiobook? _book;
  ChapterTimeline _timeline = ChapterTimeline.empty;

  @override
  Stream<AudioPlaybackSnapshot> get snapshots => _snapshots.stream;

  @override
  Future<void> load(
    Audiobook audiobook, {
    String? chapterId,
    Duration position = Duration.zero,
  }) async {
    _book = audiobook;
    _timeline = ChapterTimeline.of(audiobook);
    _emitSnapshot(statusOverride: PlaybackStatus.loading);

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    final sources = _audioSourcesFor(audiobook);
    if (sources.isEmpty) {
      _emitSnapshot(errorMessage: 'This audiobook has no readable audio file.');
      return;
    }

    final index = _resolveIndex(chapterId, position);
    final chapterPosition = _resolveChapterPosition(chapterId, position, index);

    try {
      await _player.setAudioSources(
        sources,
        // A book kept in one file is a single source, so a chapter is reached
        // by seeking into it rather than by selecting a playlist item.
        initialIndex: sources.length == 1 ? 0 : index,
        initialPosition: sources.length == 1
            ? _timeline.toBookPosition(index, chapterPosition)
            : chapterPosition,
        preload: true,
      );
      _emitSnapshot(statusOverride: PlaybackStatus.ready);
    } on PlayerException catch (error) {
      _emitSnapshot(errorMessage: error.message);
    } catch (error) {
      _emitSnapshot(errorMessage: 'This audiobook could not be opened.');
    }
  }

  /// One source per chapter, unless every chapter lives in the same file.
  List<AudioSource> _audioSourcesFor(Audiobook audiobook) {
    if (audiobook.chapters.isNotEmpty && !_timeline.isSingleFile) {
      return audiobook.chapters
          .map((chapter) => AudioSource.file(chapter.filePath))
          .toList(growable: false);
    }
    final path = audiobook.chapters.isNotEmpty
        ? audiobook.chapters.first.filePath
        : audiobook.sourcePath;
    if (path == null || path.isEmpty) return const [];
    return [AudioSource.file(path)];
  }

  int _resolveIndex(String? chapterId, Duration position) {
    final requested = _timeline.indexOf(chapterId);
    if (requested >= 0) return requested;
    if (_timeline.isEmpty) return 0;
    // Without a chapter the caller gave us a whole book offset.
    final resolved = _timeline.indexAt(position);
    return resolved < 0 ? 0 : resolved;
  }

  Duration _resolveChapterPosition(
    String? chapterId,
    Duration position,
    int index,
  ) => _timeline.indexOf(chapterId) >= 0
      ? position
      : _timeline.toChapterPosition(index, position);

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration chapterPosition) => _seekToBookPosition(
    _timeline.toBookPosition(_currentIndex(), chapterPosition),
  );

  @override
  Future<void> skipBy(Duration offset) =>
      _seekToBookPosition(_clampToBook(_currentBookPosition() + offset));

  @override
  Future<void> seekToChapter(String chapterId) {
    final index = _timeline.indexOf(chapterId);
    if (index < 0) return Future<void>.value();
    return _seekToBookPosition(_timeline.startOf(index));
  }

  @override
  Future<void> skipToNextChapter() {
    final index = _currentIndex();
    if (index < 0 || index + 1 >= _timeline.length) {
      return Future<void>.value();
    }
    return _seekToBookPosition(_timeline.startOf(index + 1));
  }

  @override
  Future<void> skipToPreviousChapter() {
    final index = _currentIndex();
    if (index < 0) return _player.seek(Duration.zero);

    // Restart the chapter first, the way a physical transport control does.
    final chapterStart = _timeline.startOf(index);
    final elapsed = _currentBookPosition() - chapterStart;
    if (elapsed > const Duration(seconds: 3) || index == 0) {
      return _seekToBookPosition(chapterStart);
    }
    return _seekToBookPosition(_timeline.startOf(index - 1));
  }

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> stop() => _player.stop();

  Future<void> _seekToBookPosition(Duration bookPosition) {
    if (_timeline.isEmpty || _timeline.isSingleFile) {
      return _player.seek(bookPosition);
    }
    final index = _timeline.indexAt(bookPosition);
    return _player.seek(
      _timeline.toChapterPosition(index, bookPosition),
      index: index,
    );
  }

  int _currentIndex() {
    if (_timeline.isEmpty) return -1;
    if (_timeline.isSingleFile) return _timeline.indexAt(_player.position);
    final index = _player.currentIndex ?? 0;
    return index.clamp(0, _timeline.length - 1);
  }

  Duration _currentBookPosition() {
    if (_timeline.isEmpty || _timeline.isSingleFile) return _player.position;
    return _timeline.toBookPosition(_currentIndex(), _player.position);
  }

  Duration _bookDuration() {
    if (!_timeline.isEmpty) return _timeline.bookDuration;
    final media = _player.duration ?? Duration.zero;
    return media > Duration.zero ? media : _book?.duration ?? Duration.zero;
  }

  Duration _clampToBook(Duration bookPosition) {
    if (bookPosition.isNegative) return Duration.zero;
    final duration = _bookDuration();
    return duration > Duration.zero && bookPosition > duration
        ? duration
        : bookPosition;
  }

  void _emitSnapshot({PlaybackStatus? statusOverride, String? errorMessage}) {
    if (_snapshots.isClosed) return;
    final mediaDuration = _player.duration ?? Duration.zero;
    if (_timeline.isSingleFile && mediaDuration > Duration.zero) {
      // Only the engine knows how long an untagged file really is.
      _timeline = _timeline.withBookDuration(mediaDuration);
    }

    final index = _currentIndex();
    final bookPosition = _currentBookPosition();
    final chapterStart = _timeline.startOf(index);

    final Duration position;
    final Duration duration;
    if (_timeline.isEmpty) {
      position = _player.position;
      duration = mediaDuration > Duration.zero
          ? mediaDuration
          : _book?.duration ?? Duration.zero;
    } else if (_timeline.isSingleFile) {
      position = _timeline.toChapterPosition(index, bookPosition);
      duration = _timeline.durationOf(index);
    } else {
      position = _player.position;
      duration = mediaDuration > Duration.zero
          ? mediaDuration
          : _timeline.durationOf(index);
    }

    final buffered = _timeline.isSingleFile && !_timeline.isEmpty
        ? _player.bufferedPosition - chapterStart
        : _player.bufferedPosition;

    _snapshots.add(
      AudioPlaybackSnapshot(
        status: errorMessage == null
            ? statusOverride ?? _statusFor(_player.playerState)
            : PlaybackStatus.failed,
        bookId: _book?.id,
        chapterId: _timeline.chapterAt(index)?.id,
        chapterIndex: index,
        chapterCount: _timeline.length,
        position: position,
        bufferedPosition: buffered.isNegative ? Duration.zero : buffered,
        duration: duration,
        bookPosition: bookPosition,
        bookDuration: _bookDuration(),
        speed: _player.speed,
        errorMessage: errorMessage,
      ),
    );
  }

  PlaybackStatus _statusFor(PlayerState state) {
    if (state.processingState == ProcessingState.completed) {
      return PlaybackStatus.completed;
    }
    if (state.processingState == ProcessingState.loading ||
        state.processingState == ProcessingState.buffering) {
      return PlaybackStatus.loading;
    }
    if (state.processingState == ProcessingState.ready) {
      return state.playing ? PlaybackStatus.playing : PlaybackStatus.paused;
    }
    return PlaybackStatus.idle;
  }

  @override
  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    await _player.dispose();
    await _snapshots.close();
  }
}
