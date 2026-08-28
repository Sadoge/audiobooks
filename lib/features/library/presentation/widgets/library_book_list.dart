import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:flutter/material.dart';

class LibraryBookList extends StatelessWidget {
  const LibraryBookList({required this.books, super.key});

  final List<Audiobook> books;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      sliver: SliverList.separated(
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
          );
        },
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
