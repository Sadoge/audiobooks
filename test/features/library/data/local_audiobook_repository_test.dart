import 'package:audiobooks/core/database/app_database.dart';
import 'package:audiobooks/features/library/data/repositories/local_audiobook_repository.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/library/domain/entities/playback_progress.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late LocalAudiobookRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = LocalAudiobookRepository(database);
  });

  tearDown(() => database.close());

  test('saves and restores a book with ordered chapters', () async {
    final book = Audiobook(
      id: 'book-1',
      title: 'A Quiet Book',
      author: 'A. Reader',
      dateAdded: DateTime.utc(2026, 8, 28),
      fileType: AudioFileType.m4a,
      chapters: const [
        AudiobookChapter(
          id: 'chapter-2',
          bookId: 'book-1',
          title: 'Second',
          index: 1,
          filePath: '/audio/02.m4a',
        ),
        AudiobookChapter(
          id: 'chapter-1',
          bookId: 'book-1',
          title: 'First',
          index: 0,
          filePath: '/audio/01.m4a',
        ),
      ],
    );

    await repository.save(book);
    final restored = await repository.findById(book.id);

    expect(restored, isNotNull);
    expect(restored!.title, book.title);
    expect(restored.chapters.map((chapter) => chapter.title), [
      'First',
      'Second',
    ]);
  });

  test('stores and returns the chapter and minute last listened to', () async {
    final book = Audiobook(
      id: 'book-1',
      title: 'A Quiet Book',
      author: 'A. Reader',
      dateAdded: DateTime.utc(2026, 8, 28),
      fileType: AudioFileType.m4b,
      duration: const Duration(hours: 3),
      chapters: const [
        AudiobookChapter(
          id: 'chapter-1',
          bookId: 'book-1',
          title: 'First',
          index: 0,
          filePath: '/audio/book.m4b',
        ),
        AudiobookChapter(
          id: 'chapter-2',
          bookId: 'book-1',
          title: 'Second',
          index: 1,
          filePath: '/audio/book.m4b',
          startPosition: Duration(hours: 1),
        ),
      ],
    );
    await repository.save(book);

    await repository.updateProgress(
      PlaybackProgress(
        bookId: book.id,
        chapterId: 'chapter-2',
        position: const Duration(minutes: 12),
        bookPosition: const Duration(hours: 1, minutes: 12),
        updatedAt: DateTime.utc(2026, 8, 28, 10),
      ),
      isFinished: false,
    );

    final progress = await repository.findProgress(book.id);
    expect(progress, isNotNull);
    expect(progress!.chapterId, 'chapter-2');
    expect(progress.position, const Duration(minutes: 12));
    expect(progress.bookPosition, const Duration(hours: 1, minutes: 12));

    // The library reads the whole book offset off the book itself.
    final stored = await repository.findById(book.id);
    expect(stored!.currentPosition, const Duration(hours: 1, minutes: 12));
    expect(stored.isFinished, isFalse);
  });

  test('stores progress for a book that has no chapters', () async {
    final book = Audiobook(
      id: 'book-1',
      title: 'One Long File',
      author: 'A. Reader',
      dateAdded: DateTime.utc(2026, 8, 28),
      fileType: AudioFileType.mp3,
      sourcePath: '/audio/book.mp3',
    );
    await repository.save(book);

    await repository.updateProgress(
      PlaybackProgress(
        bookId: book.id,
        position: const Duration(minutes: 42),
        bookPosition: const Duration(minutes: 42),
        updatedAt: DateTime.utc(2026, 8, 28, 10),
      ),
      isFinished: false,
    );

    final progress = await repository.findProgress(book.id);
    expect(progress!.chapterId, isNull);
    expect(progress.position, const Duration(minutes: 42));
  });

  test('re-saving a book keeps the place already stored', () async {
    final book = Audiobook(
      id: 'book-1',
      title: 'A Quiet Book',
      author: 'A. Reader',
      dateAdded: DateTime.utc(2026, 8, 28),
      fileType: AudioFileType.m4b,
      chapters: const [
        AudiobookChapter(
          id: 'chapter-1',
          bookId: 'book-1',
          title: 'First',
          index: 0,
          filePath: '/audio/book.m4b',
        ),
      ],
    );
    await repository.save(book);
    await repository.updateProgress(
      PlaybackProgress(
        bookId: book.id,
        chapterId: 'chapter-1',
        position: const Duration(minutes: 5),
        bookPosition: const Duration(minutes: 5),
        updatedAt: DateTime.utc(2026, 8, 28, 10),
      ),
      isFinished: false,
    );

    // Saving rewrites the chapter rows, which must not take progress with it.
    await repository.save(book.copyWith(title: 'A Quiet Book, Revised'));

    final progress = await repository.findProgress(book.id);
    expect(progress, isNotNull);
    expect(progress!.position, const Duration(minutes: 5));
  });

  test('has no progress for a book that was never opened', () async {
    expect(await repository.findProgress('missing'), isNull);
  });

  test('removing a book takes its chapters and progress with it', () async {
    final book = Audiobook(
      id: 'book-1',
      title: 'A Quiet Book',
      author: 'A. Reader',
      dateAdded: DateTime.utc(2026, 8, 28),
      fileType: AudioFileType.mp3,
      chapters: const [
        AudiobookChapter(
          id: 'chapter-1',
          bookId: 'book-1',
          title: 'First',
          index: 0,
          filePath: '/audio/01.mp3',
        ),
      ],
    );

    await repository.save(book);
    await repository.updateProgress(
      PlaybackProgress(
        bookId: book.id,
        chapterId: 'chapter-1',
        position: const Duration(minutes: 5),
        bookPosition: const Duration(minutes: 5),
        updatedAt: DateTime.utc(2026, 8, 28),
      ),
      isFinished: false,
    );

    await repository.remove(book.id);

    expect(await repository.findById(book.id), isNull);
    expect(await repository.findProgress(book.id), isNull);
    expect(
      await database.select(database.audiobookChapterRows).get(),
      isEmpty,
    );
  });
}
