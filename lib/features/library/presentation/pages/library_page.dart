// THESIS: The empty library is a pocket player with nothing loaded on it, not
// a dashboard of placeholder cards. OWN-WORLD: brushed chrome housing, a
// recessed screen, and the blue marker of an early-2000s device. STORY:
// understand the empty local library, then import device-owned audio. FIRST
// VIEWPORT: centred housing title, the player mark, a concise message, and one
// primary action. FORM: click-wheel era, seed 0bcabd73. FINISH: unreviewed and
// undocumented is unfinished; this build ends with the finish review, the
// verdict, and DESIGN.md.

import 'package:audiobooks/app/router/app_router.dart';
import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/widgets/retro_widgets.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
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
      appBar: ChromeAppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.router.push(const SettingsRoute()),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: BlocConsumer<LibraryCubit, LibraryState>(
        // Cover changes and removals report back once, over the library they
        // just changed, rather than taking the screen over.
        listenWhen: (previous, current) =>
            current.actionMessage != null &&
            current.actionMessage != previous.actionMessage,
        listener: (context, state) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.actionMessage!))),
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
                    onChangeCover: context.read<LibraryCubit>().changeCover,
                    onRemove: (book) => _confirmRemoval(context, book),
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

/// Removal deletes the only copy of a book's audio, so it is always asked
/// about first and never undone silently.
Future<void> _confirmRemoval(BuildContext context, Audiobook book) async {
  final cubit = context.read<LibraryCubit>();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Remove ${book.title}?'),
      content: const Text(
        'The audio copied into this app is deleted from this device, along '
        'with where you had got to in the book.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Remove'),
        ),
      ],
    ),
  );
  if (confirmed ?? false) await cubit.remove(book);
}

class _LibraryFailure extends StatelessWidget {
  const _LibraryFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: AppIconSize.large),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
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
