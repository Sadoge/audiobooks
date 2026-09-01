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
