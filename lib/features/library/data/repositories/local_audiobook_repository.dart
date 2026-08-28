import 'package:audiobooks/core/database/app_database.dart';
import 'package:audiobooks/core/errors/app_failure.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/library/domain/entities/bookmark.dart';
import 'package:audiobooks/features/library/domain/entities/playback_progress.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AudiobookRepository)
class LocalAudiobookRepository implements AudiobookRepository {
  LocalAudiobookRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<Audiobook>> watchAll() {
    final query = _database.select(_database.audiobookRows)
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.dateAdded, mode: OrderingMode.desc),
      ]);

    return query.watch().asyncMap((rows) async {
      try {
        return Future.wait(rows.map(_toAudiobook));
      } catch (error) {
        throw DatabaseFailure(
          'The local audiobook library could not be read.',
          cause: error,
        );
      }
    });
  }

  @override
  Future<Audiobook?> findById(String id) async {
    try {
      final row = await (_database.select(
        _database.audiobookRows,
      )..where((table) => table.id.equals(id))).getSingleOrNull();
      return row == null ? null : _toAudiobook(row);
    } catch (error) {
      throw DatabaseFailure(
        'This audiobook could not be read from the local library.',
        cause: error,
      );
    }
  }

  @override
  Future<void> save(Audiobook audiobook) async {
    try {
      await _database.transaction(() async {
        await _database
            .into(_database.audiobookRows)
            .insertOnConflictUpdate(
              AudiobookRowsCompanion(
                id: Value(audiobook.id),
                title: Value(audiobook.title),
                author: Value(audiobook.author),
                narrator: Value(audiobook.narrator),
                coverPath: Value(audiobook.coverPath),
                durationMs: Value(audiobook.duration.inMilliseconds),
                currentPositionMs: Value(
                  audiobook.currentPosition.inMilliseconds,
                ),
                dateAdded: Value(audiobook.dateAdded),
                lastPlayedAt: Value(audiobook.lastPlayedAt),
                isFinished: Value(audiobook.isFinished),
                fileType: Value(audiobook.fileType.name),
                sourcePath: Value(audiobook.sourcePath),
              ),
            );

        await (_database.delete(
          _database.audiobookChapterRows,
        )..where((row) => row.bookId.equals(audiobook.id))).go();

        if (audiobook.chapters.isNotEmpty) {
          await _database.batch((batch) {
            batch.insertAll(
              _database.audiobookChapterRows,
              audiobook.chapters
                  .map(
                    (chapter) => AudiobookChapterRowsCompanion.insert(
                      id: chapter.id,
                      bookId: chapter.bookId,
                      title: chapter.title,
                      chapterIndex: chapter.index,
                      filePath: chapter.filePath,
                      durationMs: Value(chapter.duration.inMilliseconds),
                      startPositionMs: Value(
                        chapter.startPosition.inMilliseconds,
                      ),
                    ),
                  )
                  .toList(growable: false),
            );
          });
        }
      });
    } catch (error) {
      throw DatabaseFailure(
        'The audiobook could not be saved to the local library.',
        cause: error,
      );
    }
  }

  @override
  Future<void> remove(String id) async {
    try {
      await (_database.delete(
        _database.audiobookRows,
      )..where((row) => row.id.equals(id))).go();
    } catch (error) {
      throw DatabaseFailure(
        'The audiobook could not be removed from the local library.',
        cause: error,
      );
    }
  }

  @override
  Future<void> updateProgress(
    PlaybackProgress progress, {
    required bool isFinished,
  }) async {
    try {
      await _database.transaction(() async {
        await _database
            .into(_database.playbackProgressRows)
            .insertOnConflictUpdate(
              PlaybackProgressRowsCompanion.insert(
                bookId: progress.bookId,
                chapterId: progress.chapterId,
                positionMs: progress.position.inMilliseconds,
                updatedAt: progress.updatedAt,
              ),
            );
        await (_database.update(
          _database.audiobookRows,
        )..where((row) => row.id.equals(progress.bookId))).write(
          AudiobookRowsCompanion(
            currentPositionMs: Value(progress.position.inMilliseconds),
            lastPlayedAt: Value(progress.updatedAt),
            isFinished: Value(isFinished),
          ),
        );
      });
    } catch (error) {
      throw DatabaseFailure(
        'Listening progress could not be saved.',
        cause: error,
      );
    }
  }

  @override
  Stream<List<Bookmark>> watchBookmarks(String bookId) {
    final query = _database.select(_database.bookmarkRows)
      ..where((row) => row.bookId.equals(bookId))
      ..orderBy([(row) => OrderingTerm.asc(row.positionMs)]);
    return query.watch().map(
      (rows) => rows.map(_toBookmark).toList(growable: false),
    );
  }

  @override
  Future<void> saveBookmark(Bookmark bookmark) async {
    try {
      await _database
          .into(_database.bookmarkRows)
          .insertOnConflictUpdate(
            BookmarkRowsCompanion.insert(
              id: bookmark.id,
              bookId: bookmark.bookId,
              chapterId: bookmark.chapterId,
              positionMs: bookmark.position.inMilliseconds,
              title: bookmark.title,
              createdAt: bookmark.createdAt,
            ),
          );
    } catch (error) {
      throw DatabaseFailure('The bookmark could not be saved.', cause: error);
    }
  }

  @override
  Future<void> removeBookmark(String id) async {
    try {
      await (_database.delete(
        _database.bookmarkRows,
      )..where((row) => row.id.equals(id))).go();
    } catch (error) {
      throw DatabaseFailure('The bookmark could not be removed.', cause: error);
    }
  }

  Future<Audiobook> _toAudiobook(AudiobookRow row) async {
    final chapterRows =
        await (_database.select(_database.audiobookChapterRows)
              ..where((chapter) => chapter.bookId.equals(row.id))
              ..orderBy([(chapter) => OrderingTerm.asc(chapter.chapterIndex)]))
            .get();

    return Audiobook(
      id: row.id,
      title: row.title,
      author: row.author,
      narrator: row.narrator,
      coverPath: row.coverPath,
      duration: Duration(milliseconds: row.durationMs),
      currentPosition: Duration(milliseconds: row.currentPositionMs),
      dateAdded: row.dateAdded,
      lastPlayedAt: row.lastPlayedAt,
      isFinished: row.isFinished,
      fileType: AudioFileType.values.byName(row.fileType),
      sourcePath: row.sourcePath,
      chapters: chapterRows
          .map(
            (chapter) => AudiobookChapter(
              id: chapter.id,
              bookId: chapter.bookId,
              title: chapter.title,
              index: chapter.chapterIndex,
              filePath: chapter.filePath,
              duration: Duration(milliseconds: chapter.durationMs),
              startPosition: Duration(milliseconds: chapter.startPositionMs),
            ),
          )
          .toList(growable: false),
    );
  }

  Bookmark _toBookmark(BookmarkRow row) => Bookmark(
    id: row.id,
    bookId: row.bookId,
    chapterId: row.chapterId,
    position: Duration(milliseconds: row.positionMs),
    title: row.title,
    createdAt: row.createdAt,
  );
}
