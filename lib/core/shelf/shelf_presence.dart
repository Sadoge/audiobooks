import 'package:audiobooks/features/library/domain/entities/audiobook.dart';

/// Deciding whether a book on the shelf is already in the library.
///
/// The shelf offers what the listener does not have; the library holds what
/// they do. Nothing appears on both, so this is what keeps the two apart.
///
/// A book is recognised two ways. The first is exact: a book that came off
/// this shelf, or was published to it, carries the shelf's own key. The second
/// catches the case the key cannot — the same book imported by hand on two
/// devices, which has no key in common — by comparing what a listener would
/// compare: the title, the author, and roughly how long it runs.
abstract final class ShelfPresence {
  /// Durations are compared loosely. Two encodings of the same recording
  /// rarely agree to the second, while an abridgement differs by far more
  /// than this.
  static const _tolerance = Duration(seconds: 30);
  static const _proportionalTolerance = 0.01;

  /// Whether [library] already holds the book identified by [key].
  static bool isInLibrary(
    List<Audiobook> library, {
    required String key,
    required String title,
    required String author,
    required Duration duration,
  }) {
    for (final book in library) {
      if (book.shelfKey == key) return true;
      if (_looksLikeTheSameBook(
        book,
        title: title,
        author: author,
        duration: duration,
      )) {
        return true;
      }
    }
    return false;
  }

  static bool _looksLikeTheSameBook(
    Audiobook book, {
    required String title,
    required String author,
    required Duration duration,
  }) {
    if (normalise(book.title) != normalise(title)) return false;
    if (normalise(book.author) != normalise(author)) return false;

    // A book imported before its length was known has nothing to compare, and
    // the title and author agreeing is enough.
    if (book.duration == Duration.zero || duration == Duration.zero) {
      return true;
    }

    final difference = (book.duration - duration).abs();
    final allowed = Duration(
      microseconds: (duration.inMicroseconds * _proportionalTolerance).round(),
    );
    return difference <= (allowed > _tolerance ? allowed : _tolerance);
  }

  /// Reduces a title or an author to what two devices would agree on, so that
  /// "The Hobbit" and "the hobbit." are the same book.
  ///
  /// Visible for testing.
  static String normalise(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
