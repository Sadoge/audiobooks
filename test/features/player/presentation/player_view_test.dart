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

void main() {
  testWidgets('desktop player keeps artwork and controls side by side', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1100, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    const chapter = AudiobookChapter(
      id: 'chapter-1',
      bookId: 'book-1',
      title: 'Chapter One · Arrival',
      index: 0,
      filePath: '/audio/chapter-one.m4a',
      duration: Duration(minutes: 42),
    );
    final book = Audiobook(
      id: 'book-1',
      title: 'The Quiet Listening Room',
      author: 'Local Audiobooks',
      dateAdded: DateTime(2026),
      fileType: AudioFileType.m4a,
      chapters: const [chapter],
    );
    final state = PlayerViewState(
      status: PlayerViewStatus.ready,
      book: book,
      playback: const AudioPlaybackSnapshot(
        status: PlaybackStatus.paused,
        bookId: 'book-1',
        chapterId: 'chapter-1',
        position: Duration(minutes: 18),
        duration: Duration(minutes: 42),
        speed: 1.25,
      ),
    );
    final cubit = _MockPlayerCubit();
    when(() => cubit.state).thenReturn(state);
    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => cubit.togglePlayback()).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: BlocProvider<PlayerCubit>.value(
          value: cubit,
          child: const PlayerView(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('The Quiet Listening Room'), findsNWidgets(3));
    expect(find.text('Chapter One · Arrival'), findsNWidgets(2));
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('1.25x'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    verify(() => cubit.togglePlayback()).called(1);
  });
}
