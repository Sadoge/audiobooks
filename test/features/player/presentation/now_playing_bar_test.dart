import 'dart:async';

import 'package:audiobooks/app/theme/app_theme.dart';
import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/player/presentation/cubit/now_playing_cubit.dart';
import 'package:audiobooks/features/player/presentation/cubit/now_playing_state.dart';
import 'package:audiobooks/features/player/presentation/widgets/now_playing_bar.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockNowPlayingCubit extends MockCubit<NowPlayingState>
    implements NowPlayingCubit {}

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

final _book = Audiobook(
  id: 'book-1',
  title: 'The Quiet Listening Room',
  author: 'Local Audiobooks',
  dateAdded: DateTime(2026),
  fileType: AudioFileType.m4a,
  chapters: _chapters,
);

void main() {
  late _MockNowPlayingCubit cubit;
  late StreamController<NowPlayingState> states;
  final opened = <String>[];

  setUp(() {
    cubit = _MockNowPlayingCubit();
    states = StreamController<NowPlayingState>.broadcast();
    opened.clear();
    when(() => cubit.togglePlayback()).thenAnswer((_) async {});
  });

  tearDown(() => states.close());

  Future<void> pumpBar(WidgetTester tester, NowPlayingState state) {
    when(() => cubit.state).thenReturn(state);
    whenListen(cubit, states.stream, initialState: state);

    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: BlocProvider<NowPlayingCubit>.value(
          value: cubit,
          child: Scaffold(
            bottomNavigationBar: NowPlayingBar(onOpen: opened.add),
          ),
        ),
      ),
    );
  }

  /// Playback carrying on underneath, as the bar sees it.
  Future<void> update(WidgetTester tester, NowPlayingState state) async {
    when(() => cubit.state).thenReturn(state);
    states.add(state);
    await tester.pump();
  }

  testWidgets('stays out of the way when nothing is loaded', (tester) async {
    await pumpBar(tester, const NowPlayingState());

    expect(find.text('The Quiet Listening Room'), findsNothing);
    expect(find.byType(IconButton), findsNothing);
  });

  testWidgets('names the book and the chapter being listened to', (
    tester,
  ) async {
    await pumpBar(
      tester,
      NowPlayingState(
        book: _book,
        playback: const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          chapterIndex: 1,
          chapterCount: 2,
        ),
      ),
    );

    expect(find.text('The Quiet Listening Room'), findsOneWidget);
    expect(find.text('Chapter Two · The Long Hall'), findsOneWidget);
  });

  testWidgets('shows the author for a book with no chapters', (tester) async {
    await pumpBar(
      tester,
      NowPlayingState(
        book: _book.copyWith(chapters: const []),
        playback: const AudioPlaybackSnapshot(
          status: PlaybackStatus.paused,
          bookId: 'book-1',
        ),
      ),
    );

    expect(find.text('Local Audiobooks'), findsOneWidget);
  });

  testWidgets('offers pause while playing and play while paused', (
    tester,
  ) async {
    await pumpBar(
      tester,
      NowPlayingState(
        book: _book,
        playback: const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
        ),
      ),
    );
    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);

    await update(
      tester,
      NowPlayingState(
        book: _book,
        playback: const AudioPlaybackSnapshot(
          status: PlaybackStatus.paused,
          bookId: 'book-1',
        ),
      ),
    );
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    expect(find.byIcon(Icons.pause_rounded), findsNothing);
  });

  testWidgets('the key works the transport without leaving the library', (
    tester,
  ) async {
    await pumpBar(
      tester,
      NowPlayingState(
        book: _book,
        playback: const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.pause_rounded));
    await tester.pump();

    verify(() => cubit.togglePlayback()).called(1);
    expect(opened, isEmpty);
  });

  testWidgets('the strip itself is the way back to the player', (tester) async {
    await pumpBar(
      tester,
      NowPlayingState(
        book: _book,
        playback: const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
        ),
      ),
    );

    await tester.tap(find.text('The Quiet Listening Room'));
    await tester.pump();

    expect(opened, ['book-1']);
  });

  testWidgets('a listener can hear what is playing and reach it', (
    tester,
  ) async {
    await pumpBar(
      tester,
      NowPlayingState(
        book: _book,
        playback: const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
        ),
      ),
    );

    expect(
      find.bySemanticsLabel(
        'Now playing The Quiet Listening Room. Return to player',
      ),
      findsOneWidget,
    );
    expect(find.byTooltip('Pause'), findsOneWidget);
  });
}
