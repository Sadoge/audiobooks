import 'package:audiobooks/app/theme/app_theme.dart';
import 'package:audiobooks/features/library/presentation/widgets/empty_library_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the empty state and invokes the import action', (
    tester,
  ) async {
    var importRequested = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: EmptyLibraryView(onImport: () => importRequested = true),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No audiobooks yet'), findsOneWidget);
    expect(find.text('Import Audiobooks'), findsOneWidget);

    await tester.tap(find.text('Import Audiobooks'));
    expect(importRequested, isTrue);
  });

  testWidgets('renders in dark mode', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: Scaffold(body: EmptyLibraryView(onImport: () {})),
      ),
    );
    await tester.pumpAndSettle();

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    final context = tester.element(find.byType(Scaffold));
    expect(scaffold, isNotNull);
    expect(Theme.of(context).brightness, Brightness.dark);
  });
}
