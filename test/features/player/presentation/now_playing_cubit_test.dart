import 'dart:async';

import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/player/domain/repositories/player_repository.dart';
import 'package:audiobooks/features/player/presentation/cubit/now_playing_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPlayerRepository extends Mock implements PlayerRepository {}

class _MockAudiobookRepository extends Mock implements AudiobookRepository {}

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
  String id = 'book-1',
  List<AudiobookChapter> chapters = _chapters,
}) => Audiobook(
  id: id,
  title: 'The Quiet Listening Room',
  author: 'Local Audiobooks',
  dateAdded: DateTime(2026),
  fileType: AudioFileType.m4a,
  chapters: chapters,
);

void main() {
  late _MockPlayerRepository player;
  late _MockAudiobookRepository audiobooks;
  late StreamController<AudioPlaybackSnapshot> playback;

  setUp(() {
    player = _MockPlayerRepository();
    audiobooks = _MockAudiobookRepository();
    playback = StreamController<AudioPlaybackSnapshot>.broadcast();

    when(() => player.playback).thenAnswer((_) => playback.stream);
    when(() => player.play()).thenAnswer((_) async {});
    when(() => player.pause()).thenAnswer((_) async {});
    when(() => player.nextChapter()).thenAnswer((_) async {});
    when(() => player.previousChapter()).thenAnswer((_) async {});
    when(() => audiobooks.findById('book-1')).thenAnswer((_) async => _book());
  });

  tearDown(() => playback.close());

  NowPlayingCubit build() => NowPlayingCubit(player, audiobooks);

  Future<void> emit(
    NowPlayingCubit cubit,
    AudioPlaybackSnapshot snapshot,
  ) async {
    playback.add(snapshot);
    await Future<void>.delayed(Duration.zero);
  }

  test('has nothing to show before a book is opened', () {
    final cubit = build();
    addTearDown(cubit.close);

    expect(cubit.state.hasBook, isFalse);
    expect(cubit.state.book, isNull);
  });

  test('picks up the book playing and looks it up once', () async {
    final cubit = build();
    addTearDown(cubit.close);

    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
        chapterIndex: 0,
        chapterCount: 2,
      ),
    );
    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
        chapterIndex: 0,
        chapterCount: 2,
        position: Duration(seconds: 4),
      ),
    );

    expect(cubit.state.hasBook, isTrue);
    expect(cubit.state.isPlaying, isTrue);
    expect(cubit.state.book!.title, 'The Quiet Listening Room');
    verify(() => audiobooks.findById('book-1')).called(1);
  });

  test('names the chapter being listened to', () async {
    final cubit = build();
    addTearDown(cubit.close);

    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
        chapterIndex: 1,
        chapterCount: 2,
      ),
    );

    expect(cubit.state.chapterTitle, 'Chapter Two · The Long Hall');
  });

  test('a book without chapters is named by itself alone', () async {
    when(
      () => audiobooks.findById('book-1'),
    ).thenAnswer((_) async => _book(chapters: const []));
    final cubit = build();
    addTearDown(cubit.close);

    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
      ),
    );

    expect(cubit.state.hasBook, isTrue);
    expect(cubit.state.chapterTitle, isNull);
  });

  test('shows nothing for a book that failed to open', () async {
    final cubit = build();
    addTearDown(cubit.close);

    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.failed,
        bookId: 'book-1',
        errorMessage: 'This audiobook could not be opened.',
      ),
    );

    expect(cubit.state.hasBook, isFalse);
  });

  test('a library that cannot be read leaves the bar off', () async {
    when(() => audiobooks.findById('book-1')).thenThrow(Exception('no store'));
    final cubit = build();
    addTearDown(cubit.close);

    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
      ),
    );

    expect(cubit.state.hasBook, isFalse);
  });

  test('follows the engine on to a second book', () async {
    when(
      () => audiobooks.findById('book-2'),
    ).thenAnswer((_) async => _book(id: 'book-2', chapters: const []));
    final cubit = build();
    addTearDown(cubit.close);

    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
      ),
    );
    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-2',
      ),
    );

    expect(cubit.state.book!.id, 'book-2');
  });

  test('offers chapter keys only on a book divided into any', () async {
    when(
      () => audiobooks.findById('book-2'),
    ).thenAnswer((_) async => _book(id: 'book-2', chapters: const []));
    final cubit = build();
    addTearDown(cubit.close);

    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
      ),
    );
    expect(cubit.state.hasChapters, isTrue);

    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-2',
      ),
    );
    expect(cubit.state.hasChapters, isFalse);
  });

  test('the chapter keys reach the transport', () async {
    final cubit = build();
    addTearDown(cubit.close);

    await cubit.nextChapter();
    await cubit.previousChapter();

    verify(() => player.nextChapter()).called(1);
    verify(() => player.previousChapter()).called(1);
  });

  group('the counter', () {
    test('measures the chapter, elapsed and remaining', () async {
      final cubit = build();
      addTearDown(cubit.close);

      await emit(
        cubit,
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          chapterIndex: 0,
          chapterCount: 2,
          position: Duration(minutes: 12),
          duration: Duration(minutes: 42),
        ),
      );

      expect(cubit.state.position, const Duration(minutes: 12));
      expect(cubit.state.chapterDuration, const Duration(minutes: 42));
      expect(cubit.state.chapterRemaining, const Duration(minutes: 30));
      expect(cubit.state.chapterProgress, closeTo(12 / 42, 0.001));
    });

    test('falls back to the length the library recorded', () async {
      final cubit = build();
      addTearDown(cubit.close);

      await emit(
        cubit,
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.loading,
          bookId: 'book-1',
          chapterIndex: 1,
          chapterCount: 2,
        ),
      );

      expect(cubit.state.chapterDuration, const Duration(minutes: 35));
    });

    test('knows nothing until some length is', () async {
      when(() => audiobooks.findById('book-1')).thenAnswer(
        (_) async => _book(chapters: const []),
      );
      final cubit = build();
      addTearDown(cubit.close);

      await emit(
        cubit,
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.loading,
          bookId: 'book-1',
          position: Duration(seconds: 3),
        ),
      );

      expect(cubit.state.chapterProgress, isNull);
      expect(cubit.state.chapterRemaining, isNull);
    });

    test('never runs past the end of the chapter', () async {
      final cubit = build();
      addTearDown(cubit.close);

      await emit(
        cubit,
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.completed,
          bookId: 'book-1',
          chapterIndex: 0,
          chapterCount: 2,
          position: Duration(minutes: 43),
          duration: Duration(minutes: 42),
        ),
      );

      expect(cubit.state.chapterProgress, 1.0);
      expect(cubit.state.chapterRemaining, Duration.zero);
    });
  });

  test('the key plays what is paused and pauses what is playing', () async {
    final cubit = build();
    addTearDown(cubit.close);

    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.paused,
        bookId: 'book-1',
      ),
    );
    await cubit.togglePlayback();
    verify(() => player.play()).called(1);

    await emit(
      cubit,
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
      ),
    );
    await cubit.togglePlayback();
    verify(() => player.pause()).called(1);
  });
}
