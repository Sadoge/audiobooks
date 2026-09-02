import 'package:audiobooks/app/theme/app_theme.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/shelf/domain/entities/shelf_book.dart';
import 'package:audiobooks/features/shelf/presentation/widgets/shelf_book_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _book = ShelfBook(
  key: 'a-quiet-book-1',
  title: 'A Quiet Book',
  author: 'A. Reader',
  fileType: AudioFileType.mp3,
  totalBytes: 734003200,
  duration: Duration(hours: 8, minutes: 12),
  chapterCount: 14,
);

Future<void> pumpList(
  WidgetTester tester, {
  Map<String, double> downloading = const {},
  ValueChanged<ShelfBook>? onDownload,
}) => tester.pumpWidget(
  MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(
      body: CustomScrollView(
        slivers: [
          ShelfBookList(
            books: const [_book],
            downloading: downloading,
            onDownload: onDownload ?? (_) {},
          ),
        ],
      ),
    ),
  ),
);

void main() {
  testWidgets('a book not on this device offers itself', (tester) async {
    await pumpList(tester);

    expect(find.text('A Quiet Book'), findsOneWidget);
    expect(find.text('A. Reader'), findsOneWidget);
    // What it costs to bring across, and what it is made of.
    expect(find.textContaining('700 MB'), findsOneWidget);
    expect(find.textContaining('8h 12m'), findsOneWidget);
    expect(find.textContaining('14 chapters'), findsOneWidget);
    expect(find.byTooltip('Download A Quiet Book'), findsOneWidget);
  });

  testWidgets('the row and its key both start a download', (tester) async {
    final asked = <String>[];
    await pumpList(tester, onDownload: (book) => asked.add(book.key));

    await tester.tap(find.byTooltip('Download A Quiet Book'));
    await tester.tap(find.text('A Quiet Book'));

    expect(asked, ['a-quiet-book-1', 'a-quiet-book-1']);
  });

  testWidgets('a book on its way reports how far it has got', (tester) async {
    await pumpList(tester, downloading: const {'a-quiet-book-1': 0.42});

    expect(find.text('42%'), findsOneWidget);
    expect(find.byTooltip('Download A Quiet Book'), findsNothing);
  });

  testWidgets('a book already downloading is not asked for again', (
    tester,
  ) async {
    final asked = <String>[];
    await pumpList(
      tester,
      downloading: const {'a-quiet-book-1': 0.42},
      onDownload: (book) => asked.add(book.key),
    );

    await tester.tap(find.text('A Quiet Book'));

    expect(asked, isEmpty);
  });
}
