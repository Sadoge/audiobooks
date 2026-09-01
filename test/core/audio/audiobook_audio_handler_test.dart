import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/core/audio/audio_playback_service.dart';
import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/core/audio/audiobook_audio_handler.dart';
import 'package:audiobooks/core/audio/listening_session.dart';
import 'package:audiobooks/core/audio/playback_notification_permission.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';
import 'package:audiobooks/features/settings/domain/repositories/playback_settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockEngine extends Mock implements AudioPlaybackService {}

class _MockSettings extends Mock implements PlaybackSettingsRepository {}

/// The system's permission sheet, which a listener has already answered yes to.
class _FakePermission implements PlaybackNotificationPermission {
  int asked = 0;

  @override
  Future<bool> ensureGranted() async {
    asked++;
    return true;
  }

  @override
  Future<bool?> isGranted() async => true;

  @override
  Future<void> openSettings() async {}
}

class _FakeSession implements ListeningSession {
  final _events = StreamController<ListeningInterruption>.broadcast();
  int configured = 0;

  @override
  Future<void> configure() async => configured++;

  @override
  Stream<ListeningInterruption> get interruptions => _events.stream;

  void send(ListeningInterruption interruption) => _events.add(interruption);

  Future<void> close() => _events.close();
}

const _chapters = [
  AudiobookChapter(
    id: 'chapter-1',
    bookId: 'book-1',
    title: 'Chapter One · Arrival',
    index: 0,
    filePath: '/audio/chapter-one.m4a',
    duration: Duration(minutes: 42),
  ),
  AudiobookChapter(
    id: 'chapter-2',
    bookId: 'book-1',
    title: 'Chapter Two · The Long Hall',
    index: 1,
    filePath: '/audio/chapter-two.m4a',
    duration: Duration(minutes: 35),
  ),
];

Audiobook _book({
  List<AudiobookChapter> chapters = _chapters,
  String? narrator,
}) => Audiobook(
  id: 'book-1',
  title: 'The Quiet Listening Room',
  author: 'Local Audiobooks',
  narrator: narrator,
  dateAdded: DateTime(2026),
  fileType: AudioFileType.m4a,
  duration: const Duration(minutes: 77),
  chapters: chapters,
);

void main() {
  late _MockEngine engine;
  late _MockSettings settings;
  late _FakeSession session;
  late _FakePermission permission;
  late StreamController<AudioPlaybackSnapshot> snapshots;
  late AudiobookAudioHandler handler;

  const settled = PlaybackSettings(
    rewindInterval: Duration(seconds: 10),
    forwardInterval: Duration(seconds: 45),
  );

  setUpAll(() {
    registerFallbackValue(Duration.zero);
    registerFallbackValue(_book());
  });

  setUp(() {
    engine = _MockEngine();
    settings = _MockSettings();
    session = _FakeSession();
    permission = _FakePermission();
    snapshots = StreamController<AudioPlaybackSnapshot>.broadcast();

    when(() => engine.snapshots).thenAnswer((_) => snapshots.stream);
    when(
      () => engine.load(
        any(),
        chapterId: any(named: 'chapterId'),
        position: any(named: 'position'),
      ),
    ).thenAnswer((_) async {});
    when(() => engine.play()).thenAnswer((_) async {});
    when(() => engine.pause()).thenAnswer((_) async {});
    when(() => engine.stop()).thenAnswer((_) async {});
    when(() => engine.seek(any())).thenAnswer((_) async {});
    when(() => engine.skipBy(any())).thenAnswer((_) async {});
    when(() => engine.seekToChapter(any())).thenAnswer((_) async {});
    when(() => engine.skipToNextChapter()).thenAnswer((_) async {});
    when(() => engine.skipToPreviousChapter()).thenAnswer((_) async {});
    when(() => engine.setSpeed(any())).thenAnswer((_) async {});
    when(() => engine.dispose()).thenAnswer((_) async {});
    when(
      () => settings.loadPlaybackSettings(),
    ).thenAnswer((_) async => settled);

    handler = AudiobookAudioHandler(engine, settings, session, permission);
  });

  tearDown(() async {
    await snapshots.close();
    await session.close();
  });

  /// Pushes a snapshot and lets the handler publish from it.
  Future<void> emit(AudioPlaybackSnapshot snapshot) async {
    snapshots.add(snapshot);
    await Future<void>.delayed(Duration.zero);
  }

  group('opening a book', () {
    test('claims the audio session and lists the chapters', () async {
      final book = _book();
      await handler.load(book);

      expect(session.configured, 1);
      // The notification the lock screen is made of needs asking for on
      // Android 13 and later, and a book opening is when it starts to matter.
      expect(permission.asked, 1);
      verify(
        () => engine.load(book, chapterId: null, position: Duration.zero),
      ).called(1);
      expect(
        handler.queue.value.map((item) => item.title),
        ['Chapter One · Arrival', 'Chapter Two · The Long Hall'],
      );
      expect(handler.queue.value.every((item) => item.album == book.title), isTrue);
    });

    test('a book without chapters is a queue of one, the book itself', () async {
      await handler.load(_book(chapters: const []));

      expect(handler.queue.value, hasLength(1));
      expect(handler.queue.value.single.title, 'The Quiet Listening Room');
      expect(handler.queue.value.single.duration, const Duration(minutes: 77));
    });
  });

  group('what the lock screen is told', () {
    test('shows the chapter as the track and the book as the album', () async {
      await handler.load(_book(narrator: 'A Narrator'));
      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          chapterId: 'chapter-2',
          chapterIndex: 1,
          chapterCount: 2,
          position: Duration(minutes: 3),
          duration: Duration(minutes: 35),
        ),
      );

      final item = handler.mediaItem.value!;
      expect(item.title, 'Chapter Two · The Long Hall');
      expect(item.album, 'The Quiet Listening Room');
      expect(item.duration, const Duration(minutes: 35));
      expect(item.extras!['bookId'], 'book-1');
    });

    test('names the narrator when there is one, and the author when not', () async {
      await handler.load(_book(narrator: 'A Narrator'));
      await emit(const AudioPlaybackSnapshot(bookId: 'book-1', chapterIndex: 0));
      expect(handler.mediaItem.value!.artist, 'A Narrator');

      await handler.load(_book());
      await emit(const AudioPlaybackSnapshot(bookId: 'book-1', chapterIndex: 0));
      expect(handler.mediaItem.value!.artist, 'Local Audiobooks');
    });

    test('reports playing, the position, and the speed', () async {
      await handler.load(_book());
      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          chapterId: 'chapter-1',
          chapterIndex: 0,
          chapterCount: 2,
          position: Duration(minutes: 9),
          bufferedPosition: Duration(minutes: 11),
          speed: 1.5,
        ),
      );

      final state = handler.playbackState.value;
      expect(state.playing, isTrue);
      expect(state.processingState, AudioProcessingState.ready);
      // The reported position, not `position`, which the system extrapolates
      // from it with a clock so the lock screen can tick between updates.
      expect(state.updatePosition, const Duration(minutes: 9));
      expect(state.bufferedPosition, const Duration(minutes: 11));
      expect(state.speed, 1.5);
      expect(state.queueIndex, 0);
    });

    test('offers pause while playing and play while paused', () async {
      await handler.load(_book());

      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          chapterCount: 2,
        ),
      );
      expect(
        handler.playbackState.value.controls,
        contains(MediaControl.pause),
      );

      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.paused,
          bookId: 'book-1',
          chapterCount: 2,
        ),
      );
      expect(handler.playbackState.value.controls, contains(MediaControl.play));
    });

    test('spends its keys on chapters only when the book has them', () async {
      await handler.load(_book());
      await emit(
        const AudioPlaybackSnapshot(bookId: 'book-1', chapterCount: 2),
      );
      expect(
        handler.playbackState.value.controls,
        containsAll([MediaControl.skipToPrevious, MediaControl.skipToNext]),
      );

      await handler.load(_book(chapters: const []));
      await emit(const AudioPlaybackSnapshot(bookId: 'book-1'));
      final controls = handler.playbackState.value.controls;
      expect(controls, isNot(contains(MediaControl.skipToNext)));
      expect(
        controls,
        containsAll([MediaControl.rewind, MediaControl.fastForward]),
      );
    });

    test('keeps play or pause among the keys the notification collapses to', () async {
      await handler.load(_book());
      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          chapterCount: 2,
        ),
      );

      final state = handler.playbackState.value;
      final compact = state.androidCompactActionIndices!;
      expect(compact, hasLength(3));
      expect(
        compact.map((index) => state.controls[index]),
        contains(MediaControl.pause),
      );
      expect(compact.every((index) => index < state.controls.length), isTrue);
    });

    test('carries an engine failure through as an error', () async {
      await handler.load(_book());
      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.failed,
          bookId: 'book-1',
          errorMessage: 'This audiobook could not be opened.',
        ),
      );

      expect(
        handler.playbackState.value.processingState,
        AudioProcessingState.error,
      );
      expect(
        handler.playbackState.value.errorMessage,
        'This audiobook could not be opened.',
      );
    });

    test('republishes only when what is playing actually changes', () async {
      await handler.load(_book());
      final published = <MediaItem>[];
      final watching = handler.mediaItem.listen((item) {
        if (item != null) published.add(item);
      });
      addTearDown(watching.cancel);

      // A chapter ticking along.
      for (var second = 0; second < 4; second++) {
        await emit(
          AudioPlaybackSnapshot(
            status: PlaybackStatus.playing,
            bookId: 'book-1',
            chapterId: 'chapter-1',
            chapterCount: 2,
            duration: const Duration(minutes: 42),
            position: Duration(seconds: second),
          ),
        );
      }
      expect(published, hasLength(1));

      // Over the boundary into the next one.
      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          chapterId: 'chapter-2',
          chapterIndex: 1,
          chapterCount: 2,
          duration: Duration(minutes: 35),
        ),
      );
      expect(published, hasLength(2));
      expect(published.last.title, 'Chapter Two · The Long Hall');
    });

    test('publishes again once the engine works out a length', () async {
      await handler.load(_book(chapters: const []));
      final published = <MediaItem>[];
      final watching = handler.mediaItem.listen((item) {
        if (item != null) published.add(item);
      });
      addTearDown(watching.cancel);

      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.loading,
          bookId: 'book-1',
        ),
      );
      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          duration: Duration(minutes: 91),
        ),
      );

      expect(published.last.duration, const Duration(minutes: 91));
    });

    test('says nothing about a book that is not the one it opened', () async {
      await handler.load(_book());
      await emit(const AudioPlaybackSnapshot(bookId: 'another-book'));

      expect(handler.mediaItem.value, isNull);
    });
  });

  group('commands from the system', () {
    setUp(() => handler.load(_book()));

    test('play and pause reach the engine', () async {
      await handler.play();
      await handler.pause();

      verify(() => engine.play()).called(1);
      verify(() => engine.pause()).called(1);
    });

    test('next and previous move by chapter', () async {
      await handler.skipToNext();
      await handler.skipToPrevious();

      verify(() => engine.skipToNextChapter()).called(1);
      verify(() => engine.skipToPreviousChapter()).called(1);
    });

    test('a queue item is the chapter it stands for', () async {
      await handler.skipToQueueItem(1);
      verify(() => engine.seekToChapter('chapter-2')).called(1);
    });

    test('an unknown queue item is left alone', () async {
      await handler.skipToQueueItem(9);
      verifyNever(() => engine.seekToChapter(any()));
    });

    test('a seek is a position inside the chapter', () async {
      await handler.seek(const Duration(minutes: 4));
      verify(() => engine.seek(const Duration(minutes: 4))).called(1);
    });

    test('skip keys step by the intervals chosen in settings', () async {
      await handler.fastForward();
      await handler.rewind();

      verify(() => engine.skipBy(const Duration(seconds: 45))).called(1);
      verify(() => engine.skipBy(const Duration(seconds: -10))).called(1);
    });

    test('a held skip key steps once, and does nothing on release', () async {
      await handler.seekForward(true);
      await handler.seekForward(false);

      verify(() => engine.skipBy(const Duration(seconds: 45))).called(1);
    });

    test('a headset click plays what is paused and pauses what is playing', () async {
      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.paused,
          bookId: 'book-1',
        ),
      );
      await handler.click();
      verify(() => engine.play()).called(1);

      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
        ),
      );
      await handler.click();
      verify(() => engine.pause()).called(1);
    });

    test('a double headset click moves on a chapter', () async {
      await handler.click(MediaButton.next);
      verify(() => engine.skipToNextChapter()).called(1);
    });
  });

  group('interruptions', () {
    Future<void> playing() => emit(
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
      ),
    );

    setUp(() => handler.load(_book()));

    test('a call pauses the book and giving it back resumes it', () async {
      await playing();

      session.send(ListeningInterruption.paused);
      await Future<void>.delayed(Duration.zero);
      verify(() => engine.pause()).called(1);

      session.send(ListeningInterruption.resumed);
      await Future<void>.delayed(Duration.zero);
      verify(() => engine.play()).called(1);
    });

    test('a book paused by the listener is not started again for them', () async {
      await playing();
      await handler.pause();

      session.send(ListeningInterruption.resumed);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => engine.play());
    });

    test('unplugged headphones pause the book and never resume it', () async {
      await playing();

      session.send(ListeningInterruption.ended);
      await Future<void>.delayed(Duration.zero);
      verify(() => engine.pause()).called(1);

      session.send(ListeningInterruption.resumed);
      await Future<void>.delayed(Duration.zero);
      verifyNever(() => engine.play());
    });

    test('a book already paused is left where it is', () async {
      await emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.paused,
          bookId: 'book-1',
        ),
      );

      session.send(ListeningInterruption.paused);
      await Future<void>.delayed(Duration.zero);

      verifyNever(() => engine.pause());
    });
  });

  test('disposing lets go of the engine', () async {
    await handler.dispose();
    verify(() => engine.dispose()).called(1);
  });
}
