import 'package:audiobooks/core/audio/chapter_timeline.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:flutter_test/flutter_test.dart';

Audiobook _book({
  List<AudiobookChapter> chapters = const [],
  Duration duration = Duration.zero,
}) => Audiobook(
  id: 'book-1',
  title: 'A Book',
  author: 'An Author',
  dateAdded: DateTime.utc(2026),
  fileType: AudioFileType.m4b,
  sourcePath: '/library/book.m4b',
  duration: duration,
  chapters: chapters,
);

void main() {
  group('one file per chapter', () {
    final book = _book(
      chapters: const [
        AudiobookChapter(
          id: 'c0',
          bookId: 'book-1',
          title: 'One',
          index: 0,
          filePath: '/library/01.mp3',
          duration: Duration(minutes: 10),
        ),
        AudiobookChapter(
          id: 'c1',
          bookId: 'book-1',
          title: 'Two',
          index: 1,
          filePath: '/library/02.mp3',
          duration: Duration(minutes: 20),
        ),
        AudiobookChapter(
          id: 'c2',
          bookId: 'book-1',
          title: 'Three',
          index: 2,
          filePath: '/library/03.mp3',
          duration: Duration(minutes: 30),
        ),
      ],
    );

    test('lays the files end to end on the book timeline', () {
      final timeline = ChapterTimeline.of(book);

      expect(timeline.isSingleFile, isFalse);
      expect(timeline.startOf(0), Duration.zero);
      expect(timeline.startOf(1), const Duration(minutes: 10));
      expect(timeline.startOf(2), const Duration(minutes: 30));
      expect(timeline.bookDuration, const Duration(minutes: 60));
    });

    test('a chapter starts at zero inside its own file', () {
      final timeline = ChapterTimeline.of(book);

      expect(timeline.fileStartOf(1), Duration.zero);
      expect(timeline.fileStartOf(2), Duration.zero);
    });

    test('converts between chapter time and book time', () {
      final timeline = ChapterTimeline.of(book);

      expect(
        timeline.toBookPosition(1, const Duration(minutes: 5)),
        const Duration(minutes: 15),
      );
      expect(
        timeline.toChapterPosition(1, const Duration(minutes: 15)),
        const Duration(minutes: 5),
      );
      expect(timeline.indexAt(const Duration(minutes: 15)), 1);
      expect(timeline.indexAt(const Duration(minutes: 45)), 2);
    });
  });

  group('one file holding every chapter', () {
    final book = _book(
      duration: const Duration(minutes: 60),
      chapters: const [
        AudiobookChapter(
          id: 'c0',
          bookId: 'book-1',
          title: 'One',
          index: 0,
          filePath: '/library/book.m4b',
        ),
        AudiobookChapter(
          id: 'c1',
          bookId: 'book-1',
          title: 'Two',
          index: 1,
          filePath: '/library/book.m4b',
          startPosition: Duration(minutes: 10),
        ),
        AudiobookChapter(
          id: 'c2',
          bookId: 'book-1',
          title: 'Three',
          index: 2,
          filePath: '/library/book.m4b',
          startPosition: Duration(minutes: 30),
        ),
      ],
    );

    test('reads markers as offsets inside the shared file', () {
      final timeline = ChapterTimeline.of(book);

      expect(timeline.isSingleFile, isTrue);
      expect(timeline.startOf(2), const Duration(minutes: 30));
      expect(timeline.fileStartOf(2), const Duration(minutes: 30));
      expect(timeline.bookDuration, const Duration(minutes: 60));
    });

    test('a chapter runs until the next marker', () {
      final timeline = ChapterTimeline.of(book);

      expect(timeline.durationOf(0), const Duration(minutes: 10));
      expect(timeline.durationOf(1), const Duration(minutes: 20));
      // The last chapter runs to the end of the file.
      expect(timeline.durationOf(2), const Duration(minutes: 30));
    });

    test('finds the chapter playing at a point in the file', () {
      final timeline = ChapterTimeline.of(book);

      expect(timeline.indexAt(Duration.zero), 0);
      expect(timeline.indexAt(const Duration(minutes: 9, seconds: 59)), 0);
      expect(timeline.indexAt(const Duration(minutes: 10)), 1);
      expect(timeline.indexAt(const Duration(minutes: 59)), 2);
    });

    test('takes a longer duration from the engine when tags understate it', () {
      final timeline = ChapterTimeline.of(
        _book(duration: Duration.zero, chapters: book.chapters),
      ).withBookDuration(const Duration(minutes: 75));

      expect(timeline.bookDuration, const Duration(minutes: 75));
      expect(timeline.durationOf(2), const Duration(minutes: 45));
    });
  });

  group('a book with no chapters', () {
    test('reports an empty timeline that still knows the book length', () {
      final timeline = ChapterTimeline.of(
        _book(duration: const Duration(minutes: 45)),
      );

      expect(timeline.isEmpty, isTrue);
      expect(timeline.length, 0);
      expect(timeline.indexAt(const Duration(minutes: 5)), -1);
      expect(timeline.chapterAt(0), isNull);
      expect(timeline.bookDuration, const Duration(minutes: 45));
      // Chapter time and book time are the same thing here.
      expect(
        timeline.toBookPosition(-1, const Duration(minutes: 5)),
        const Duration(minutes: 5),
      );
    });
  });

  test('resolves a chapter by id and rejects an unknown one', () {
    final timeline = ChapterTimeline.of(
      _book(
        chapters: const [
          AudiobookChapter(
            id: 'c0',
            bookId: 'book-1',
            title: 'One',
            index: 0,
            filePath: '/library/01.mp3',
            duration: Duration(minutes: 10),
          ),
        ],
      ),
    );

    expect(timeline.indexOf('c0'), 0);
    expect(timeline.indexOf('missing'), -1);
    expect(timeline.indexOf(null), -1);
  });
}
