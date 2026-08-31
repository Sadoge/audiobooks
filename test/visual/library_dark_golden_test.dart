import 'package:audiobooks/app/theme/app_theme.dart';
import 'package:audiobooks/app/widgets/retro_widgets.dart';
import 'package:audiobooks/features/library/presentation/widgets/empty_library_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dark empty library visual', (tester) async {
    await tester.binding.setSurfaceSize(const Size(402, 874));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        home: Scaffold(
          appBar: const ChromeAppBar(
            title: Text('Library'),
            actions: [
              IconButton(
                tooltip: 'Settings',
                onPressed: null,
                icon: Icon(Icons.settings_outlined),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyLibraryView(onImport: () {}),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/library_dark.png'),
    );
  });
}
