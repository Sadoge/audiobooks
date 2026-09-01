import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/core/audio/audio_playback_service.dart';
import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/core/audio/just_audio_playback_service.dart';
import 'package:audiobooks/core/audio/listening_session.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';
import 'package:audiobooks/features/settings/domain/repositories/playback_settings_repository.dart';
import 'package:injectable/injectable.dart';

/// The book, on the lock screen and in the notification shade.
///
/// This is the app's [AudioPlaybackService]: everything above it opens books
/// and works the transport through this object, and it passes that straight
/// down to the engine. What it adds is the other direction. It publishes what
/// is playing where the operating system can see it, and it accepts the same
/// commands back from the lock screen, the notification, a headset button, a
/// car stereo, or a watch.
///
/// Two conventions make that mapping honest rather than approximate:
///
/// * **A chapter is the media item.** The system's scrubber, elapsed time and
///   remaining time therefore measure the chapter, exactly as the app's own
///   scrubber does, and a system seek is already a chapter position.
/// * **Skip is by chapter, and rewind and fast-forward are by the intervals
///   set in Settings.** The buttons a listener finds on the lock screen do what
///   the same-looking keys on the wheel do.
@lazySingleton
class AudiobookAudioHandler extends BaseAudioHandler
    implements AudioPlaybackService {
  AudiobookAudioHandler(
    @Named(JustAudioPlaybackService.engine) this._engine,
    this._settings,
    this._session,
  ) {
    _playback = _engine.snapshots.listen(_publish);
    _interruptions = _session.interruptions.listen(_handleInterruption);
  }

  final AudioPlaybackService _engine;
  final PlaybackSettingsRepository _settings;
  final ListeningSession _session;

  late final StreamSubscription<AudioPlaybackSnapshot> _playback;
  late final StreamSubscription<ListeningInterruption> _interruptions;

  Audiobook? _book;
  AudioPlaybackSnapshot _latest = const AudioPlaybackSnapshot();
  PlaybackSettings _intervals = const PlaybackSettings();

  /// Resolved once per book, because reading it means touching the disk and
  /// the engine reports its position many times a second.
  Uri? _artwork;

  /// The last thing handed to the system, so that a tick that changes nothing
  /// it shows is not handed over again.
  MediaItem? _published;

  /// Whether it was an interruption that stopped playback, and so whether
  /// playback is this app's to resume when the interruption ends.
  bool _pausedByInterruption = false;

  @override
  Stream<AudioPlaybackSnapshot> get snapshots => _engine.snapshots;

  @override
  Future<void> load(
    Audiobook audiobook, {
    String? chapterId,
    Duration position = Duration.zero,
  }) async {
    _book = audiobook;
    _pausedByInterruption = false;
    // The lock screen's skip keys are labelled with the same intervals the
    // wheel's are, so the stored ones are read as the book opens.
    _intervals = await _readIntervals();
    _artwork = _artworkFor(audiobook);
    // A newly opened book always announces itself, even one whose chapters
    // carry the same names and lengths as the book before it.
    _published = null;
    await _session.configure();
    queue.add(_queueFor(audiobook));
    await _engine.load(audiobook, chapterId: chapterId, position: position);
  }

  // Commands. Each one arrives either from the app's own transport or from the
  // system's, and there is deliberately only one implementation of each.

  @override
  Future<void> play() {
    _pausedByInterruption = false;
    return _engine.play();
  }

  @override
  Future<void> pause() {
    _pausedByInterruption = false;
    return _engine.pause();
  }

  /// A seek is a position inside the chapter, which is what both scrubbers —
  /// the app's and the system's — are measuring.
  @override
  Future<void> seek(Duration chapterPosition) => _engine.seek(chapterPosition);

  @override
  Future<void> skipBy(Duration offset) => _engine.skipBy(offset);

  @override
  Future<void> seekToChapter(String chapterId) =>
      _engine.seekToChapter(chapterId);

  @override
  Future<void> skipToNextChapter() => _engine.skipToNextChapter();

  @override
  Future<void> skipToPreviousChapter() => _engine.skipToPreviousChapter();

  @override
  Future<void> setSpeed(double speed) => _engine.setSpeed(speed);

  @override
  Future<void> stop() async {
    _pausedByInterruption = false;
    await _engine.stop();
    await super.stop();
  }

  /// The system's next and previous are the book's chapters, which is the only
  /// division of an audiobook a listener would expect to land on.
  @override
  Future<void> skipToNext() => skipToNextChapter();

  @override
  Future<void> skipToPrevious() => skipToPreviousChapter();

  @override
  Future<void> skipToQueueItem(int index) {
    final chapter = _chapterAt(index);
    if (chapter == null) return Future<void>.value();
    return seekToChapter(chapter.id);
  }

  /// Stepping, not scrubbing: the lock screen's skip keys cross a chapter end
  /// the same way the wheel's do, rather than stopping at it.
  @override
  Future<void> fastForward() => skipBy(_intervals.forwardInterval);

  @override
  Future<void> rewind() => skipBy(-_intervals.rewindInterval);

  @override
  Future<void> seekForward(bool begin) =>
      begin ? fastForward() : Future<void>.value();

  @override
  Future<void> seekBackward(bool begin) =>
      begin ? rewind() : Future<void>.value();

  /// A listener who gives an interruption the audio back expects the book to
  /// carry on where it left off; one who pressed pause themselves does not.
  void _handleInterruption(ListeningInterruption interruption) {
    switch (interruption) {
      case ListeningInterruption.paused:
        if (_latest.status != PlaybackStatus.playing) return;
        _pausedByInterruption = true;
        unawaited(_engine.pause());
      case ListeningInterruption.resumed:
        if (!_pausedByInterruption) return;
        _pausedByInterruption = false;
        unawaited(_engine.play());
      case ListeningInterruption.ended:
        _pausedByInterruption = false;
        if (_latest.status != PlaybackStatus.playing) return;
        unawaited(_engine.pause());
    }
  }

  Future<PlaybackSettings> _readIntervals() async {
    try {
      return await _settings.loadPlaybackSettings();
    } catch (_) {
      // Skip keys that step by the ordinary intervals are better than a book
      // that will not open because its settings could not be read.
      return const PlaybackSettings();
    }
  }

  // Publication. Everything below turns one engine snapshot into what the
  // operating system shows and offers.

  void _publish(AudioPlaybackSnapshot snapshot) {
    _latest = snapshot;
    final book = _book;
    if (book == null || snapshot.bookId != book.id) return;

    // The state carries the position and so is published on every tick. What
    // is playing changes only at a chapter boundary, and republishing it would
    // have the system fetch the artwork again and blink the notification.
    final item = _mediaItemFor(book, snapshot);
    if (_hasChanged(item)) {
      _published = item;
      mediaItem.add(item);
    }
    playbackState.add(_stateFor(snapshot));
  }

  /// [MediaItem] compares by id alone, but a chapter whose length the engine
  /// has just worked out is worth publishing again under the same id.
  bool _hasChanged(MediaItem item) {
    final current = _published;
    return current == null ||
        current.id != item.id ||
        current.duration != item.duration;
  }

  PlaybackState _stateFor(AudioPlaybackSnapshot snapshot) {
    final playing = snapshot.status == PlaybackStatus.playing;
    final chapters = snapshot.chapterCount > 1;
    final controls = <MediaControl>[
      if (chapters) MediaControl.skipToPrevious,
      MediaControl.rewind,
      if (playing) MediaControl.pause else MediaControl.play,
      MediaControl.fastForward,
      if (chapters) MediaControl.skipToNext,
    ];

    return PlaybackState(
      controls: controls,
      // Three keys fit the collapsed Android notification, and play or pause
      // is always the middle one. A book with chapters spends the outer two on
      // them; a book without spends them on rewind and forward.
      androidCompactActionIndices: chapters
          ? const <int>[0, 2, 4]
          : const <int>[0, 1, 2],
      systemActions: const <MediaAction>{
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
        MediaAction.rewind,
        MediaAction.fastForward,
        MediaAction.setSpeed,
        MediaAction.playPause,
      },
      processingState: _processingStateFor(snapshot.status),
      playing: playing,
      updatePosition: snapshot.position,
      bufferedPosition: snapshot.bufferedPosition,
      speed: snapshot.speed,
      queueIndex: snapshot.chapterIndex >= 0 ? snapshot.chapterIndex : null,
      errorMessage: snapshot.errorMessage,
    );
  }

  AudioProcessingState _processingStateFor(PlaybackStatus status) =>
      switch (status) {
        PlaybackStatus.idle => AudioProcessingState.idle,
        PlaybackStatus.loading => AudioProcessingState.loading,
        PlaybackStatus.ready ||
        PlaybackStatus.playing ||
        PlaybackStatus.paused => AudioProcessingState.ready,
        PlaybackStatus.completed => AudioProcessingState.completed,
        PlaybackStatus.failed => AudioProcessingState.error,
      };

  /// The chapter playing now, as the system sees it. Its own length comes from
  /// the engine, which is the only thing that knows how long an untagged file
  /// really runs.
  MediaItem _mediaItemFor(Audiobook book, AudioPlaybackSnapshot snapshot) {
    final chapter = _chapterAt(snapshot.chapterIndex);
    return _mediaItem(
      book,
      chapter: chapter,
      duration: snapshot.duration > Duration.zero
          ? snapshot.duration
          : chapter?.duration ?? book.duration,
    );
  }

  /// Every chapter, so that a car stereo or a watch can list them and pick one.
  /// A book without chapters is a queue of one: itself.
  List<MediaItem> _queueFor(Audiobook book) => book.chapters.isEmpty
      ? <MediaItem>[_mediaItem(book, duration: book.duration)]
      : book.chapters
            .map(
              (chapter) =>
                  _mediaItem(book, chapter: chapter, duration: chapter.duration),
            )
            .toList(growable: false);

  /// What the lock screen reads: the chapter as the track, the book as the
  /// album, and the book's own artwork.
  MediaItem _mediaItem(
    Audiobook book, {
    AudiobookChapter? chapter,
    required Duration duration,
  }) => MediaItem(
    id: chapter?.id ?? book.id,
    title: chapter?.title ?? book.title,
    album: book.title,
    // A narrator is who you are listening to; without one the author stands in.
    artist: book.narrator ?? book.author,
    genre: 'Audiobook',
    duration: duration > Duration.zero ? duration : null,
    artUri: _artwork,
    displayTitle: chapter?.title ?? book.title,
    displaySubtitle: book.title,
    displayDescription: book.author,
    extras: <String, dynamic>{'bookId': book.id},
  );

  /// A cover the system can actually load, or none at all rather than a broken
  /// reference: the artwork is a file this app copied, and a book imported
  /// before covers were read may not have one yet.
  static Uri? _artworkFor(Audiobook book) {
    final path = book.coverPath;
    if (path == null || path.isEmpty) return null;
    return File(path).existsSync() ? Uri.file(path) : null;
  }

  AudiobookChapter? _chapterAt(int index) {
    final chapters = _book?.chapters ?? const <AudiobookChapter>[];
    return index >= 0 && index < chapters.length ? chapters[index] : null;
  }

  @override
  Future<void> dispose() async {
    await _playback.cancel();
    await _interruptions.cancel();
    await _engine.dispose();
  }
}
