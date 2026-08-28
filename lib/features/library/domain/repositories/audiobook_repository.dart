import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/bookmark.dart';
import 'package:audiobooks/features/library/domain/entities/playback_progress.dart';

abstract interface class AudiobookRepository {
  Stream<List<Audiobook>> watchAll();

  Future<Audiobook?> findById(String id);

  Future<void> save(Audiobook audiobook);

  Future<void> remove(String id);

  Future<void> updateProgress(
    PlaybackProgress progress, {
    required bool isFinished,
  });

  /// Where the listener left this book, or null if it was never opened.
  Future<PlaybackProgress?> findProgress(String bookId);

  Stream<List<Bookmark>> watchBookmarks(String bookId);

  Future<void> saveBookmark(Bookmark bookmark);

  Future<void> removeBookmark(String id);
}
