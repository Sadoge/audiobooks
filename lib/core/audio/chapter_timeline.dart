import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';

/// Translates between whole book time and per chapter time.
///
/// Two layouts reach the player, and this is the only place that needs to know
/// which one it is looking at:
///
/// * **One file per chapter**, played as a playlist. Every chapter starts at
///   zero inside its own file, and the book timeline is those files end to end.
/// * **One file holding every chapter**, played as a single source. A chapter
///   starts at its marker inside that file, so file time is book time.
///
/// Everything above this class works in book time and chapter time only.
class ChapterTimeline {
  const ChapterTimeline._(
    this._starts, {
    required this.chapters,
    required this.isSingleFile,
    required this.bookDuration,
  });

  static const ChapterTimeline empty = ChapterTimeline._(
    [],
    chapters: [],
    isSingleFile: true,
    bookDuration: Duration.zero,
  );

  factory ChapterTimeline.of(Audiobook book) {
    final chapters = book.chapters;
    if (chapters.isEmpty) {
      return ChapterTimeline._(
        const [],
        chapters: const [],
        isSingleFile: true,
        bookDuration: book.duration,
      );
    }

    final isSingleFile = chapters.every(
      (chapter) => chapter.filePath == chapters.first.filePath,
    );

    final starts = <Duration>[];
    if (isSingleFile) {
      starts.addAll(chapters.map((chapter) => chapter.startPosition));
    } else {
      var elapsed = Duration.zero;
      for (final chapter in chapters) {
        starts.add(elapsed);
        elapsed += chapter.duration;
      }
    }

    return ChapterTimeline._(
      starts,
      chapters: chapters,
      isSingleFile: isSingleFile,
      bookDuration: _bookDurationFor(book, chapters, isSingleFile, starts),
    );
  }

  static Duration _bookDurationFor(
    Audiobook book,
    List<AudiobookChapter> chapters,
    bool isSingleFile,
    List<Duration> starts,
  ) {
    if (isSingleFile) {
      final lastMarker = starts.last + chapters.last.duration;
      return book.duration > lastMarker ? book.duration : lastMarker;
    }
    final total = chapters.fold(
      Duration.zero,
      (sum, chapter) => sum + chapter.duration,
    );
    return total > Duration.zero ? total : book.duration;
  }

  final List<AudiobookChapter> chapters;

  /// Whether every chapter is a time range inside one shared media file.
  final bool isSingleFile;

  final Duration bookDuration;

  final List<Duration> _starts;

  bool get isEmpty => chapters.isEmpty;

  int get length => chapters.length;

  /// Fills in a duration only the audio engine can know, for books imported
  /// before their media could be probed.
  ChapterTimeline withBookDuration(Duration duration) =>
      duration <= bookDuration
      ? this
      : ChapterTimeline._(
          _starts,
          chapters: chapters,
          isSingleFile: isSingleFile,
          bookDuration: duration,
        );

  AudiobookChapter? chapterAt(int index) =>
      index >= 0 && index < chapters.length ? chapters[index] : null;

  /// Where the chapter begins on the book timeline.
  Duration startOf(int index) =>
      index >= 0 && index < _starts.length ? _starts[index] : Duration.zero;

  /// Where the chapter begins inside its own media file.
  Duration fileStartOf(int index) => isSingleFile ? startOf(index) : Duration.zero;

  Duration endOf(int index) => index >= 0 && index < _starts.length - 1
      ? _starts[index + 1]
      : bookDuration;

  Duration durationOf(int index) {
    final span = endOf(index) - startOf(index);
    if (span > Duration.zero) return span;
    return chapterAt(index)?.duration ?? Duration.zero;
  }

  /// The chapter playing at a point on the book timeline, or `-1` when the
  /// book has no chapters.
  int indexAt(Duration bookPosition) {
    if (_starts.isEmpty) return -1;
    var index = 0;
    for (var candidate = 0; candidate < _starts.length; candidate++) {
      if (_starts[candidate] <= bookPosition) {
        index = candidate;
      } else {
        break;
      }
    }
    return index;
  }

  int indexOf(String? chapterId) => chapterId == null
      ? -1
      : chapters.indexWhere((chapter) => chapter.id == chapterId);

  Duration toBookPosition(int index, Duration chapterPosition) {
    final position = startOf(index) + chapterPosition;
    return position.isNegative ? Duration.zero : position;
  }

  Duration toChapterPosition(int index, Duration bookPosition) {
    final position = bookPosition - startOf(index);
    return position.isNegative ? Duration.zero : position;
  }
}
