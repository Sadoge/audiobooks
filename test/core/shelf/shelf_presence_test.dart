import 'package:audiobooks/core/shelf/shelf_presence.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:flutter_test/flutter_test.dart';

Audiobook _book({
  String id = 'local-1',
  String title = 'A Quiet Book',
  String author = 'A. Reader',
  Duration duration = const Duration(hours: 3),
  String? shelfKey,
}) => Audiobook(
  id: id,
  title: title,
  author: author,
  dateAdded: DateTime.utc(2026, 9, 1),
  fileType: AudioFileType.mp3,
  duration: duration,
  shelfKey: shelfKey,
);

bool _isPresent(
  List<Audiobook> library, {
  String key = 'shelf-key',
  String title = 'A Quiet Book',
  String author = 'A. Reader',
  Duration duration = const Duration(hours: 3),
}) => ShelfPresence.isInLibrary(
  library,
  key: key,
  title: title,
  author: author,
  duration: duration,
);

void main() {
  test('an empty library has nothing', () {
    expect(_isPresent(const []), isFalse);
  });

  test('recognises a book that carries the shelf key', () {
    final library = [_book(title: 'Renamed Since', shelfKey: 'shelf-key')];

    expect(_isPresent(library), isTrue);
  });

  test('recognises the same book imported by hand on both devices', () {
    final library = [_book()];

    expect(_isPresent(library), isTrue);
  });

  test('sees past punctuation and case', () {
    final library = [_book(title: 'the  HOBBIT!', author: 'J.R.R. Tolkien')];

    expect(
      _isPresent(library, title: 'The Hobbit', author: 'J R R Tolkien'),
      isTrue,
    );
  });

  test('allows the small disagreement two encodings have about length', () {
    final library = [_book(duration: const Duration(hours: 3, seconds: 20))];

    expect(_isPresent(library), isTrue);
  });

  test('holds an abridgement to be a different book', () {
    final library = [_book(duration: const Duration(hours: 2))];

    expect(_isPresent(library), isFalse);
  });

  test('a book imported before its length was known still matches', () {
    final library = [_book(duration: Duration.zero)];

    expect(_isPresent(library), isTrue);
  });

  test('another book by the same author is not this one', () {
    final library = [_book(title: 'A Louder Book')];

    expect(_isPresent(library), isFalse);
  });

  test('the same title by another author is not this one', () {
    final library = [_book(author: 'Someone Else')];

    expect(_isPresent(library), isFalse);
  });
}
