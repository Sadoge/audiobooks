import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/player/domain/repositories/player_repository.dart';
import 'package:audiobooks/features/player/presentation/cubit/player_cubit.dart';
import 'package:audiobooks/features/player/presentation/cubit/player_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPlayerRepository extends Mock implements PlayerRepository {}

class _MockAudiobookRepository extends Mock implements AudiobookRepository {}

void main() {
  late _MockPlayerRepository player;
  late _MockAudiobookRepository audiobooks;

  const chapter = AudiobookChapter(
    id: 'chapter-1',
    bookId: 'book-1',
    title: 'Chapter One',
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
  const playback = AudioPlaybackSnapshot(
    status: PlaybackStatus.paused,
    bookId: 'book-1',
    chapterId: 'chapter-1',
    position: Duration(minutes: 12),
    duration: Duration(minutes: 42),
  );

  setUp(() {
    player = _MockPlayerRepository();
    audiobooks = _MockAudiobookRepository();
    when(() => audiobooks.findById(book.id)).thenAnswer((_) async => book);
    when(() => player.playback).thenAnswer((_) => Stream.value(playback));
    when(
      () => player.open(
        book,
        chapterId: any(named: 'chapterId'),
        position: any(named: 'position'),
      ),
    ).thenAnswer((_) async {});
    when(() => player.play()).thenAnswer((_) async {});
    when(() => player.saveProgress()).thenAnswer((_) async {});
    when(() => player.selectChapter(any())).thenAnswer((_) async {});
  });

  test('loads a local audiobook and exposes playback state', () async {
    final cubit = PlayerCubit(player, audiobooks);
    addTearDown(cubit.close);

    await cubit.load(book.id);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, PlayerViewStatus.ready);
    expect(cubit.state.book, book);
    expect(cubit.state.playback, playback);
    verify(() => player.open(book)).called(1);
  });

  test('opening without a chapter leaves the stored place to decide', () async {
    final cubit = PlayerCubit(player, audiobooks);
    addTearDown(cubit.close);

    await cubit.load(book.id);

    verify(() => player.open(book, chapterId: null)).called(1);
  });

  test('selecting a chapter seeks instead of reopening the book', () async {
    final cubit = PlayerCubit(player, audiobooks);
    addTearDown(cubit.close);
    await cubit.load(book.id);
    await Future<void>.delayed(Duration.zero);
    clearInteractions(player);

    await cubit.selectChapter('chapter-1');

    verify(() => player.selectChapter('chapter-1')).called(1);
    verify(() => player.play()).called(1);
    verifyNever(
      () => player.open(
        book,
        chapterId: any(named: 'chapterId'),
        position: any(named: 'position'),
      ),
    );
  });

  test('stores the current place when the player is closed', () async {
    final cubit = PlayerCubit(player, audiobooks);
    await cubit.load(book.id);
    await Future<void>.delayed(Duration.zero);

    await cubit.close();

    verify(() => player.saveProgress()).called(1);
  });

  test('starts playback when the loaded audiobook is paused', () async {
    final cubit = PlayerCubit(player, audiobooks);
    addTearDown(cubit.close);
    await cubit.load(book.id);
    await Future<void>.delayed(Duration.zero);

    await cubit.togglePlayback();

    verify(() => player.play()).called(1);
  });
}
