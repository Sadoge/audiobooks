import 'dart:async';

import 'package:audiobooks/core/audio/audio_playback_service.dart';
import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/library/domain/entities/bookmark.dart';
import 'package:audiobooks/features/library/domain/entities/playback_progress.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/player/data/repositories/local_player_repository.dart';
import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';
import 'package:audiobooks/features/settings/domain/repositories/playback_settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeAudioPlaybackService service;
  late _FakeAudiobookRepository audiobooks;
  late _FakePlaybackSettingsRepository settings;
  late LocalPlayerRepository repository;

  setUp(() {
    service = _FakeAudioPlaybackService();
    audiobooks = _FakeAudiobookRepository();
    settings = _FakePlaybackSettingsRepository();
    repository = LocalPlayerRepository(service, audiobooks, settings);
  });

  tearDown(() => service.dispose());

  test('opens a new book at the beginning', () async {
    await repository.open(_book);

    expect(service.loadedChapterId, isNull);
    expect(service.loadedPosition, Duration.zero);
  });

  test('resumes the chapter and minute the listener stopped at', () async {
    audiobooks.progress = PlaybackProgress(
      bookId: _book.id,
      chapterId: 'chapter-2',
      position: const Duration(minutes: 7, seconds: 30),
      bookPosition: const Duration(minutes: 37, seconds: 30),
      updatedAt: DateTime.utc(2026),
    );

    await repository.open(_book);

    expect(service.loadedChapterId, 'chapter-2');
    expect(service.loadedPosition, const Duration(minutes: 7, seconds: 30));
  });

  test('resumes a chapterless book from its whole book offset', () async {
    audiobooks.progress = PlaybackProgress(
      bookId: _plainBook.id,
      position: const Duration(minutes: 42),
      bookPosition: const Duration(minutes: 42),
      updatedAt: DateTime.utc(2026),
    );

    await repository.open(_plainBook);

    expect(service.loadedChapterId, isNull);
    expect(service.loadedPosition, const Duration(minutes: 42));
  });

  test('starts a finished book over rather than at its last second', () async {
    audiobooks.progress = PlaybackProgress(
      bookId: _book.id,
      chapterId: 'chapter-3',
      position: const Duration(minutes: 30),
      bookPosition: const Duration(minutes: 90),
      updatedAt: DateTime.utc(2026),
    );

    await repository.open(_book.copyWith(isFinished: true));

    expect(service.loadedChapterId, isNull);
    expect(service.loadedPosition, Duration.zero);
  });

  test('an explicit chapter wins over the stored place', () async {
    audiobooks.progress = PlaybackProgress(
      bookId: _book.id,
      chapterId: 'chapter-2',
      position: const Duration(minutes: 7),
      bookPosition: const Duration(minutes: 37),
      updatedAt: DateTime.utc(2026),
    );

    await repository.open(_book, chapterId: 'chapter-1');

    expect(service.loadedChapterId, 'chapter-1');
    expect(service.loadedPosition, Duration.zero);
  });

  test('opens every book at the speed chosen in settings', () async {
    settings.settings = const PlaybackSettings(speed: 1.5);

    await repository.open(_book);

    expect(service.appliedSpeed, 1.5);
  });

  test('picks a resumed book up shortly before it was left', () async {
    settings.settings = const PlaybackSettings(
      resumeRewind: Duration(seconds: 30),
    );
    audiobooks.progress = PlaybackProgress(
      bookId: _book.id,
      chapterId: 'chapter-2',
      position: const Duration(minutes: 7, seconds: 30),
      bookPosition: const Duration(minutes: 37, seconds: 30),
      updatedAt: DateTime.utc(2026),
    );

    await repository.open(_book);

    expect(service.loadedChapterId, 'chapter-2');
    expect(service.loadedPosition, const Duration(minutes: 7));
  });

  test('never steps back past the start of what it resumes into', () async {
    settings.settings = const PlaybackSettings(
      resumeRewind: Duration(seconds: 30),
    );
    audiobooks.progress = PlaybackProgress(
      bookId: _book.id,
      chapterId: 'chapter-2',
      position: const Duration(seconds: 4),
      bookPosition: const Duration(minutes: 30, seconds: 4),
      updatedAt: DateTime.utc(2026),
    );

    await repository.open(_book);

    expect(service.loadedPosition, Duration.zero);
  });

  test('opens on the ordinary defaults when settings cannot be read', () async {
    settings.failOnRead = true;
    audiobooks.progress = PlaybackProgress(
      bookId: _book.id,
      chapterId: 'chapter-2',
      position: const Duration(minutes: 7),
      bookPosition: const Duration(minutes: 37),
      updatedAt: DateTime.utc(2026),
    );

    await repository.open(_book);

    expect(service.loadedChapterId, 'chapter-2');
    expect(service.loadedPosition, const Duration(minutes: 7));
    expect(service.appliedSpeed, 1.0);
  });

  test('records chapter and whole book position while playing', () async {
    await repository.open(_book);
    service.emit(
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
        chapterId: 'chapter-2',
        chapterIndex: 1,
        chapterCount: 3,
        position: Duration(minutes: 4),
        bookPosition: Duration(minutes: 34),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    final written = audiobooks.written.last;
    expect(written.chapterId, 'chapter-2');
    expect(written.position, const Duration(minutes: 4));
    expect(written.bookPosition, const Duration(minutes: 34));
  });

  test('records progress for a book that has no chapters', () async {
    await repository.open(_plainBook);
    service.emit(
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-2',
        position: Duration(minutes: 12),
        bookPosition: Duration(minutes: 12),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(audiobooks.written, hasLength(1));
    expect(audiobooks.written.single.chapterId, isNull);
    expect(audiobooks.written.single.position, const Duration(minutes: 12));
  });

  test('ignores the zero position a book reports while it opens', () async {
    audiobooks.progress = PlaybackProgress(
      bookId: _book.id,
      chapterId: 'chapter-2',
      position: const Duration(minutes: 7),
      bookPosition: const Duration(minutes: 37),
      updatedAt: DateTime.utc(2026),
    );

    await repository.open(_book);
    service
      ..emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.loading,
          bookId: 'book-1',
        ),
      )
      ..emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.paused,
          bookId: 'book-1',
          chapterId: 'chapter-1',
        ),
      )
      // A playing snapshot can still arrive before the resume seek lands.
      ..emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          chapterId: 'chapter-1',
        ),
      );
    await Future<void>.delayed(Duration.zero);

    expect(audiobooks.written, isEmpty);
  });

  test('records again once the resumed book is really playing', () async {
    audiobooks.progress = PlaybackProgress(
      bookId: _book.id,
      chapterId: 'chapter-2',
      position: const Duration(minutes: 7),
      bookPosition: const Duration(minutes: 37),
      updatedAt: DateTime.utc(2026),
    );

    await repository.open(_book);
    service
      ..emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          chapterId: 'chapter-2',
          position: Duration(minutes: 7, seconds: 1),
          bookPosition: Duration(minutes: 37, seconds: 1),
        ),
      )
      ..emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.paused,
          bookId: 'book-1',
          chapterId: 'chapter-2',
          position: Duration(minutes: 8),
          bookPosition: Duration(minutes: 38),
        ),
      );
    await Future<void>.delayed(Duration.zero);

    expect(audiobooks.written.last.bookPosition, const Duration(minutes: 38));
  });

  test('leaving a book untouched does not move its stored place', () async {
    audiobooks.progress = PlaybackProgress(
      bookId: _book.id,
      chapterId: 'chapter-2',
      position: const Duration(minutes: 7),
      bookPosition: const Duration(minutes: 37),
      updatedAt: DateTime.utc(2026),
    );

    await repository.open(_book);
    service.emit(
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.paused,
        bookId: 'book-1',
        chapterId: 'chapter-2',
        position: Duration(minutes: 7),
        bookPosition: Duration(minutes: 37),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    await repository.saveProgress();

    expect(audiobooks.written, isEmpty);
  });

  test('writes as soon as playback crosses into another chapter', () async {
    await repository.open(_book);
    service
      ..emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          chapterId: 'chapter-1',
          position: Duration(minutes: 29),
          bookPosition: Duration(minutes: 29),
        ),
      )
      ..emit(
        const AudioPlaybackSnapshot(
          status: PlaybackStatus.playing,
          bookId: 'book-1',
          chapterId: 'chapter-2',
          position: Duration(seconds: 1),
          bookPosition: Duration(minutes: 30, seconds: 1),
        ),
      );
    await Future<void>.delayed(Duration.zero);

    // The interval has not elapsed, so only the chapter change forced this.
    expect(audiobooks.written, hasLength(2));
    expect(audiobooks.written.last.chapterId, 'chapter-2');
  });

  test('saveProgress stores the latest place on demand', () async {
    await repository.open(_book);
    service.emit(
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
        chapterId: 'chapter-3',
        position: Duration(minutes: 1),
        bookPosition: Duration(minutes: 61),
      ),
    );
    service.emit(
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.paused,
        bookId: 'book-1',
        chapterId: 'chapter-3',
        position: Duration(minutes: 2),
        bookPosition: Duration(minutes: 62),
      ),
    );
    await Future<void>.delayed(Duration.zero);
    audiobooks.written.clear();

    await repository.saveProgress();

    expect(audiobooks.written.single.chapterId, 'chapter-3');
    expect(audiobooks.written.single.bookPosition, const Duration(minutes: 62));
  });

  test('marks the book finished when playback completes', () async {
    await repository.open(_book);
    service.emit(
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'book-1',
        chapterId: 'chapter-3',
        position: Duration(minutes: 29),
        bookPosition: Duration(minutes: 89),
      ),
    );
    service.emit(
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.completed,
        bookId: 'book-1',
        chapterId: 'chapter-3',
        position: Duration(minutes: 30),
        bookPosition: Duration(minutes: 90),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(audiobooks.finished, isTrue);
  });

  test('a snapshot from another book is not written to this one', () async {
    await repository.open(_book);
    service.emit(
      const AudioPlaybackSnapshot(
        status: PlaybackStatus.playing,
        bookId: 'a-different-book',
        position: Duration(minutes: 3),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(audiobooks.written, isEmpty);
  });

  test('opening still works when progress cannot be read', () async {
    audiobooks.failOnRead = true;

    await repository.open(_book);

    expect(service.loadedChapterId, isNull);
    expect(service.loadedPosition, Duration.zero);
  });
}

final _book = Audiobook(
  id: 'book-1',
  title: 'A Book',
  author: 'An Author',
  dateAdded: DateTime.utc(2026),
  fileType: AudioFileType.mp3,
  duration: const Duration(minutes: 90),
  chapters: const [
    AudiobookChapter(
      id: 'chapter-1',
      bookId: 'book-1',
      title: 'One',
      index: 0,
      filePath: '/library/01.mp3',
      duration: Duration(minutes: 30),
    ),
    AudiobookChapter(
      id: 'chapter-2',
      bookId: 'book-1',
      title: 'Two',
      index: 1,
      filePath: '/library/02.mp3',
      duration: Duration(minutes: 30),
    ),
    AudiobookChapter(
      id: 'chapter-3',
      bookId: 'book-1',
      title: 'Three',
      index: 2,
      filePath: '/library/03.mp3',
      duration: Duration(minutes: 30),
    ),
  ],
);

final _plainBook = Audiobook(
  id: 'book-2',
  title: 'One Long File',
  author: 'An Author',
  dateAdded: DateTime.utc(2026),
  fileType: AudioFileType.m4b,
  sourcePath: '/library/book.m4b',
  duration: const Duration(hours: 2),
);

class _FakeAudioPlaybackService implements AudioPlaybackService {
  final _controller = StreamController<AudioPlaybackSnapshot>.broadcast();

  String? loadedChapterId;
  Duration? loadedPosition;
  double? appliedSpeed;

  void emit(AudioPlaybackSnapshot snapshot) => _controller.add(snapshot);

  Future<void> dispose_() => _controller.close();

  @override
  Stream<AudioPlaybackSnapshot> get snapshots => _controller.stream;

  @override
  Future<void> load(
    Audiobook audiobook, {
    String? chapterId,
    Duration position = Duration.zero,
  }) async {
    loadedChapterId = chapterId;
    loadedPosition = position;
  }

  @override
  Future<void> play() async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> seek(Duration chapterPosition) async {}

  @override
  Future<void> skipBy(Duration offset) async {}

  @override
  Future<void> seekToChapter(String chapterId) async {}

  @override
  Future<void> skipToNextChapter() async {}

  @override
  Future<void> skipToPreviousChapter() async {}

  @override
  Future<void> setSpeed(double speed) async => appliedSpeed = speed;

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() => dispose_();
}

class _FakePlaybackSettingsRepository implements PlaybackSettingsRepository {
  PlaybackSettings settings = const PlaybackSettings();
  bool failOnRead = false;

  @override
  Future<PlaybackSettings> loadPlaybackSettings() async {
    if (failOnRead) throw StateError('unreadable');
    return settings;
  }

  @override
  Future<void> savePlaybackSettings(PlaybackSettings settings) async =>
      this.settings = settings;
}

class _FakeAudiobookRepository implements AudiobookRepository {
  final written = <PlaybackProgress>[];
  PlaybackProgress? progress;
  bool finished = false;
  bool failOnRead = false;

  @override
  Future<PlaybackProgress?> findProgress(String bookId) async {
    if (failOnRead) throw StateError('unreadable');
    return progress;
  }

  @override
  Future<void> updateProgress(
    PlaybackProgress progress, {
    required bool isFinished,
  }) async {
    written.add(progress);
    finished = isFinished;
  }

  @override
  Future<Audiobook?> findById(String id) async => null;

  @override
  Future<void> save(Audiobook audiobook) async {}

  @override
  Future<void> remove(String id) async {}

  @override
  Future<void> saveBookmark(Bookmark bookmark) async {}

  @override
  Future<void> removeBookmark(String id) async {}

  @override
  Stream<List<Audiobook>> watchAll() => const Stream.empty();

  @override
  Stream<List<Bookmark>> watchBookmarks(String bookId) => const Stream.empty();
}
