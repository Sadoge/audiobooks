// THESIS: The empty library is an open listening space, not a dashboard of
// placeholder cards. OWN-WORLD: cool semantic surfaces, slate planes, and one
// warm brass action/marker. STORY: understand the empty local library, then
// import device-owned audio. FIRST VIEWPORT: top-aligned native title, quiet doorway
// geometry, concise message, and one primary action. FORM: quiet listening
// room, seed 0bcabd73. FINISH: unreviewed and undocumented is unfinished; this
// build ends with the finish review, the verdict, and DESIGN.md.

import 'package:audiobooks/app/router/app_router.dart';
import 'package:audiobooks/features/library/presentation/cubit/library_cubit.dart';
import 'package:audiobooks/features/library/presentation/cubit/library_state.dart';
import 'package:audiobooks/features/library/presentation/widgets/empty_library_view.dart';
import 'package:audiobooks/features/library/presentation/widgets/library_book_list.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.router.push(const SettingsRoute()),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: context.read<LibraryCubit>().retry,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                switch (state.status) {
                  LibraryStatus.initial ||
                  LibraryStatus.loading => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  LibraryStatus.failure => SliverFillRemaining(
                    hasScrollBody: false,
                    child: _LibraryFailure(
                      message:
                          state.errorMessage ??
                          'Your local library could not be opened.',
                    ),
                  ),
                  LibraryStatus.ready when state.books.isEmpty =>
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyLibraryView(
                        onImport: () =>
                            context.router.push(const ImportRoute()),
                      ),
                    ),
                  LibraryStatus.ready => LibraryBookList(
                    books: state.books,
                    onOpen: (book) =>
                        context.router.push(PlayerRoute(bookId: book.id)),
                  ),
                },
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LibraryFailure extends StatelessWidget {
  const _LibraryFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 32),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: context.read<LibraryCubit>().retry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
