import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:flutter/material.dart';

class LibraryBookList extends StatelessWidget {
  const LibraryBookList({required this.books, required this.onOpen, super.key});

  final List<Audiobook> books;
  final ValueChanged<Audiobook> onOpen;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.crossAxisExtent >= 720;
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(
            desktop ? AppSpacing.xl : AppSpacing.md,
            AppSpacing.sm,
            desktop ? AppSpacing.xl : AppSpacing.md,
            AppSpacing.xxl,
          ),
          sliver: desktop
              ? SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisExtent: 300,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) => _GridBookTile(
                    book: books[index],
                    onTap: () => onOpen(books[index]),
                  ),
                )
              : SliverList.separated(
                  itemCount: books.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return ListTile(
                      minTileHeight: 80,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      leading: _CoverPlaceholder(title: book.title),
                      title: Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(book.author),
                      trailing: const Icon(Icons.play_arrow_rounded),
                      onTap: () => onOpen(book),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _GridBookTile extends StatelessWidget {
  const _GridBookTile({required this.book, required this.onTap});

  final Audiobook book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: 'Open ${book.title}, by ${book.author}',
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cover,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer,
                      borderRadius: AppRadii.cover,
                    ),
                    child: Center(
                      child: Text(
                        book.title.isEmpty
                            ? 'A'
                            : book.title.characters.first.toUpperCase(),
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(color: scheme.onSecondaryContainer),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  book.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 48,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: AppRadii.cover,
      ),
      child: Text(
        title.isEmpty ? 'A' : title.characters.first.toUpperCase(),
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: scheme.onSecondaryContainer),
      ),
    );
  }
}
