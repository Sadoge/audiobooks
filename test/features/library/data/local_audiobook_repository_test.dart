import 'package:audiobooks/core/database/app_database.dart';
import 'package:audiobooks/features/library/data/repositories/local_audiobook_repository.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
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

  test('removing a book removes it from the repository', () async {
    final book = Audiobook(
      id: 'book-1',
      title: 'A Quiet Book',
      author: 'A. Reader',
      dateAdded: DateTime.utc(2026, 8, 28),
      fileType: AudioFileType.mp3,
    );

    await repository.save(book);
    await repository.remove(book.id);

    expect(await repository.findById(book.id), isNull);
  });
}
