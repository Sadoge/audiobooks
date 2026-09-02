import 'package:audiobooks/app/di/configure_dependencies.dart';
import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/widgets/retro_widgets.dart';
import 'package:audiobooks/features/shelf/presentation/cubit/shelf_cubit.dart';
import 'package:audiobooks/features/shelf/presentation/cubit/shelf_state.dart';
import 'package:audiobooks/features/shelf/presentation/widgets/shelf_book_list.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The shared library folder, seen as the books this device could still add.
///
/// A book already in the library is not listed here at all. The two screens
/// divide the collection between them: the Library is what is on this device,
/// and this is what is not.
@RoutePage()
class ShelfPage extends StatelessWidget implements AutoRouteWrapper {
  const ShelfPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => getIt<ShelfCubit>()..load(), child: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChromeAppBar(
        title: const Text('Shared Library'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              tooltip: 'Look again',
              onPressed: context.read<ShelfCubit>().load,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ShelfCubit, ShelfState>(
        listenWhen: (previous, current) =>
            current.actionMessage != null &&
            current.actionMessage != previous.actionMessage,
        listener: (context, state) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.actionMessage!))),
        builder: (context, state) {
          final cubit = context.read<ShelfCubit>();
          return RefreshIndicator(
            onRefresh: cubit.load,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                switch (state.status) {
                  ShelfStatus.initial ||
                  ShelfStatus.loading => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  ShelfStatus.noFolder => SliverFillRemaining(
                    hasScrollBody: false,
                    child: _ShelfNotice(
                      title: 'No shared folder yet',
                      message:
                          'Point this device at a folder your own sync '
                          'service keeps in step — iCloud Drive, Dropbox, '
                          'Syncthing — and the books in it appear here, ready '
                          'to bring across.',
                      action: 'Choose folder',
                      onAction: cubit.chooseFolder,
                    ),
                  ),
                  ShelfStatus.unreadableFolder => SliverFillRemaining(
                    hasScrollBody: false,
                    child: _ShelfNotice(
                      title: 'That folder cannot be opened',
                      message:
                          'This device handed back a folder it will only let '
                          'the app reach one file at a time. Choose a folder '
                          'your sync service keeps on the device itself.',
                      action: 'Choose another folder',
                      onAction: cubit.chooseFolder,
                    ),
                  ),
                  ShelfStatus.failure => SliverFillRemaining(
                    hasScrollBody: false,
                    child: _ShelfNotice(
                      title: 'The shared folder could not be read',
                      message:
                          state.errorMessage ??
                          'The shared folder could not be read.',
                      action: 'Try again',
                      onAction: cubit.load,
                    ),
                  ),
                  ShelfStatus.ready when state.books.isEmpty =>
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _ShelfNotice(
                        title: 'Nothing left to add',
                        message:
                            'Every book in the shared folder is already on '
                            'this device. Anything another device publishes '
                            'shows up here.',
                      ),
                    ),
                  ShelfStatus.ready => ShelfBookList(
                    books: state.books,
                    downloading: state.downloading,
                    onDownload: cubit.download,
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

/// What the shelf has to say when it has no books to show: one heading, one
/// explanation, and at most one thing to do about it.
class _ShelfNotice extends StatelessWidget {
  const _ShelfNotice({
    required this.title,
    required this.message,
    this.action,
    this.onAction,
  });

  final String title;
  final String message;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (action case final label?) ...[
                const SizedBox(height: AppSpacing.lg),
                FilledButton(onPressed: onAction, child: Text(label)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
