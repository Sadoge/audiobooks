import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:audiobooks/core/audio/audio_playback_service.dart';
import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
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
  List<AudiobookChapter> _chapters = const [];

  @override
  Stream<AudioPlaybackSnapshot> get snapshots => _snapshots.stream;

  @override
  Future<void> load(Audiobook audiobook, {String? chapterId}) async {
    _book = audiobook;
    _chapters = audiobook.chapters;
    _emitSnapshot(statusOverride: PlaybackStatus.loading);

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    final sources = _audioSourcesFor(audiobook);
    if (sources.isEmpty) {
      _emitSnapshot(errorMessage: 'This audiobook has no readable audio file.');
      return;
    }

    final requestedIndex = chapterId == null
        ? 0
        : _chapters.indexWhere((chapter) => chapter.id == chapterId);
    final initialIndex = requestedIndex < 0 ? 0 : requestedIndex;

    try {
      await _player.setAudioSources(
        sources,
        initialIndex: initialIndex,
        initialPosition: audiobook.currentPosition,
        preload: true,
      );
      _emitSnapshot(statusOverride: PlaybackStatus.ready);
    } on PlayerException catch (error) {
      _emitSnapshot(errorMessage: error.message);
    } catch (error) {
      _emitSnapshot(errorMessage: 'This audiobook could not be opened.');
    }
  }

  List<AudioSource> _audioSourcesFor(Audiobook audiobook) {
    if (audiobook.chapters.isNotEmpty) {
      return audiobook.chapters
          .map((chapter) => AudioSource.file(chapter.filePath))
          .toList(growable: false);
    }
    final sourcePath = audiobook.sourcePath;
    if (sourcePath == null || sourcePath.isEmpty) return const [];
    return [AudioSource.file(sourcePath)];
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNextChapter() async {
    if (_player.hasNext) await _player.seekToNext();
  }

  @override
  Future<void> skipToPreviousChapter() async {
    if (_player.position > const Duration(seconds: 3)) {
      await _player.seek(Duration.zero);
    } else if (_player.hasPrevious) {
      await _player.seekToPrevious();
    }
  }

  @override
  Future<void> setSpeed(double speed) => _player.setSpeed(speed);

  @override
  Future<void> stop() => _player.stop();

  void _emitSnapshot({PlaybackStatus? statusOverride, String? errorMessage}) {
    if (_snapshots.isClosed) return;
    final playerState = _player.playerState;
    final status = statusOverride ?? _statusFor(playerState);
    final chapterIndex = _player.currentIndex ?? 0;
    final chapterId = chapterIndex >= 0 && chapterIndex < _chapters.length
        ? _chapters[chapterIndex].id
        : null;

    _snapshots.add(
      AudioPlaybackSnapshot(
        status: errorMessage == null ? status : PlaybackStatus.failed,
        bookId: _book?.id,
        chapterId: chapterId,
        position: _player.position,
        bufferedPosition: _player.bufferedPosition,
        duration: _player.duration ?? Duration.zero,
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
