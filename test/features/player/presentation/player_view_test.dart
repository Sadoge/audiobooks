import 'package:audiobooks/app/theme/app_theme.dart';
import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/player/presentation/cubit/player_cubit.dart';
import 'package:audiobooks/features/player/presentation/cubit/player_state.dart';
import 'package:audiobooks/features/player/presentation/pages/player_page.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPlayerCubit extends MockCubit<PlayerViewState>
    implements PlayerCubit {}

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
  AudiobookChapter(
    id: 'chapter-3',
    bookId: 'book-1',
    title: 'Chapter Three · Departure',
    index: 2,
    filePath: '/audio/chapter-three.m4a',
    duration: Duration(minutes: 28),
  ),
];

Audiobook _book({List<AudiobookChapter> chapters = _chapters}) => Audiobook(
  id: 'book-1',
  title: 'The Quiet Listening Room',
  author: 'Local Audiobooks',
  dateAdded: DateTime(2026),
  fileType: AudioFileType.m4a,
  chapters: chapters,
);

const _playback = AudioPlaybackSnapshot(
  status: PlaybackStatus.paused,
  bookId: 'book-1',
  chapterId: 'chapter-1',
  chapterIndex: 0,
  chapterCount: 3,
  position: Duration(minutes: 18),
  duration: Duration(minutes: 42),
  bookPosition: Duration(minutes: 18),
  bookDuration: Duration(minutes: 105),
  speed: 1.25,
);

_MockPlayerCubit _cubitFor(PlayerViewState state) {
  final cubit = _MockPlayerCubit();
  when(() => cubit.state).thenReturn(state);
  when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
  when(() => cubit.togglePlayback()).thenAnswer((_) async {});
  when(() => cubit.selectChapter(any())).thenAnswer((_) async {});
  return cubit;
}

Future<void> _pumpPlayer(WidgetTester tester, PlayerCubit cubit) =>
    tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: BlocProvider<PlayerCubit>.value(
          value: cubit,
          child: const PlayerView(),
        ),
      ),
    );

void main() {
  testWidgets('desktop player keeps artwork and controls side by side', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1100, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = _cubitFor(
      PlayerViewState(
        status: PlayerViewStatus.ready,
        book: _book(),
        playback: _playback,
      ),
    );

    await _pumpPlayer(tester, cubit);
    await tester.pumpAndSettle();

    expect(find.text('The Quiet Listening Room'), findsNWidgets(3));
    // The chapter appears in the heading only; the list moved to a sheet.
    expect(find.text('Chapter One · Arrival'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('1.25x'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    verify(() => cubit.togglePlayback()).called(1);
  });

  testWidgets('shows what is left of the book between the chapter times', (
    tester,
  ) async {
    final cubit = _cubitFor(
      PlayerViewState(
        status: PlayerViewStatus.ready,
        book: _book(),
        playback: _playback,
      ),
    );

    await _pumpPlayer(tester, cubit);
    await tester.pumpAndSettle();

    // Chapter time on either side, the whole book in the middle.
    expect(find.text('18:00'), findsOneWidget);
    expect(find.text('-24:00'), findsOneWidget);
    expect(find.text('1:27:00 left in book'), findsOneWidget);
    // The separate whole-book bar is gone.
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('says nothing about the book when it has no chapters', (
    tester,
  ) async {
    final cubit = _cubitFor(
      PlayerViewState(
        status: PlayerViewStatus.ready,
        book: _book(chapters: const []),
        playback: const AudioPlaybackSnapshot(
          status: PlaybackStatus.paused,
          bookId: 'book-1',
          position: Duration(minutes: 18),
          duration: Duration(minutes: 105),
          bookPosition: Duration(minutes: 18),
          bookDuration: Duration(minutes: 105),
        ),
      ),
    );

    await _pumpPlayer(tester, cubit);
    await tester.pumpAndSettle();

    expect(find.textContaining('left in book'), findsNothing);
  });

  testWidgets('opens every chapter in a sheet and plays the one tapped', (
    tester,
  ) async {
    final cubit = _cubitFor(
      PlayerViewState(
        status: PlayerViewStatus.ready,
        book: _book(),
        playback: _playback,
      ),
    );

    await _pumpPlayer(tester, cubit);
    await tester.pumpAndSettle();

    expect(find.text('Chapter Three · Departure'), findsNothing);

    await tester.tap(find.text('Chapter One · Arrival'));
    await tester.pumpAndSettle();

    expect(find.text('Chapters'), findsOneWidget);
    expect(find.text('Chapter Two · The Long Hall'), findsOneWidget);
    expect(find.text('Chapter Three · Departure'), findsOneWidget);
    // Each chapter carries its own length.
    expect(find.text('35:00'), findsOneWidget);
    expect(find.text('28:00'), findsOneWidget);

    await tester.tap(find.text('Chapter Three · Departure'));
    await tester.pumpAndSettle();

    verify(() => cubit.selectChapter('chapter-3')).called(1);
    expect(find.text('Chapters'), findsNothing);
  });

  testWidgets('a book with one chapter offers no chapter sheet', (
    tester,
  ) async {
    final cubit = _cubitFor(
      PlayerViewState(
        status: PlayerViewStatus.ready,
        book: _book(chapters: [_chapters.first]),
        playback: _playback,
      ),
    );

    await _pumpPlayer(tester, cubit);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Chapter One · Arrival'));
    await tester.pumpAndSettle();

    expect(find.text('Chapters'), findsNothing);
  });
}
