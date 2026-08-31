import 'package:audiobooks/app/theme/app_theme.dart';
import 'package:audiobooks/features/library/presentation/widgets/empty_library_view.dart';
import 'package:audiobooks/features/library/presentation/widgets/library_app_bar.dart';
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
          appBar: LibraryAppBar(onImport: () {}, onSettings: () {}),
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
