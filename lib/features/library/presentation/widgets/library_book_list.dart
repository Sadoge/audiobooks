import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/core/audio/chapter_timeline.dart';
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            book.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          _ResumeSummary(book: book),
                        ],
                      ),
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
                _ResumeSummary(book: book),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Says where a part-listened book will pick up again.
///
/// Nothing is shown for a book that has never been opened, so a fresh library
/// stays quiet.
class _ResumeSummary extends StatelessWidget {
  const _ResumeSummary({required this.book});

  final Audiobook book;

  @override
  Widget build(BuildContext context) {
    if (book.isFinished) return const _Label(text: 'Finished');
    if (book.currentPosition <= Duration.zero) return const SizedBox.shrink();

    final timeline = ChapterTimeline.of(book);
    final index = timeline.indexAt(book.currentPosition);
    final chapter = timeline.chapterAt(index);
    final elapsed = chapter == null
        ? book.currentPosition
        : timeline.toChapterPosition(index, book.currentPosition);

    return _Label(
      text: chapter == null
          ? 'Resume at ${_formatDuration(elapsed)}'
          : 'Chapter ${index + 1} · ${_formatDuration(elapsed)}',
      progress: timeline.bookDuration > Duration.zero
          ? book.currentPosition.inMilliseconds /
                timeline.bookDuration.inMilliseconds
          : null,
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text, this.progress});

  final String text;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xxs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (progress case final value?) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: value.clamp(0.0, 1.0),
                minHeight: 3,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
          ],
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: scheme.primary),
          ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final safe = duration.isNegative ? Duration.zero : duration;
  final hours = safe.inHours;
  final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
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
