import 'package:audiobooks/app/theme/app_theme.dart';
import 'package:audiobooks/features/library/presentation/widgets/library_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('offers importing, the shared library, and settings over any '
      'library', (tester) async {
    var imports = 0;
    var shared = 0;
    var settings = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          appBar: LibraryAppBar(
            onImport: () => imports++,
            onShared: () => shared++,
            onSettings: () => settings++,
          ),
          body: const SizedBox.shrink(),
        ),
      ),
    );

    expect(find.text('Library'), findsOneWidget);

    await tester.tap(find.byTooltip('Import audiobooks'));
    await tester.tap(find.byTooltip('Shared library'));
    await tester.tap(find.byTooltip('Settings'));

    expect(imports, 1);
    expect(shared, 1);
    expect(settings, 1);
  });
}
