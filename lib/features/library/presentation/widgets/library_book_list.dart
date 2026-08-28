import 'dart:io';

import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/widgets/retro_widgets.dart';
import 'package:audiobooks/core/audio/chapter_timeline.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:flutter/material.dart';

class LibraryBookList extends StatelessWidget {
  const LibraryBookList({
    required this.books,
    required this.onOpen,
    required this.onChangeCover,
    required this.onRemove,
    super.key,
  });

  final List<Audiobook> books;
  final ValueChanged<Audiobook> onOpen;
  final ValueChanged<Audiobook> onChangeCover;
  final ValueChanged<Audiobook> onRemove;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.crossAxisExtent >= 720;
        return SliverPadding(
          // A menu of rows runs to both edges of its screen, so the compact
          // list carries its inset inside each row and lets the rules span.
          padding: EdgeInsets.fromLTRB(
            desktop ? AppSpacing.xl : 0,
            desktop ? AppSpacing.sm : 0,
            desktop ? AppSpacing.xl : 0,
            AppSpacing.xxl,
          ),
          sliver: desktop
              ? SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisExtent: 336,
                    crossAxisSpacing: AppSpacing.lg,
                    mainAxisSpacing: AppSpacing.lg,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) => _GridBookTile(
                    book: books[index],
                    onTap: () => onOpen(books[index]),
                    onChangeCover: () => onChangeCover(books[index]),
                    onRemove: () => onRemove(books[index]),
                  ),
                )
              : SliverList.separated(
                  itemCount: books.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return ListTile(
                      minTileHeight: 80,
                      contentPadding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.xs,
                        AppSpacing.sm,
                        AppSpacing.xs,
                      ),
                      leading: SizedBox(
                        width: 56,
                        height: 56,
                        child: ChromeFrame(
                          thickness: 2,
                          child: _Cover(book: book),
                        ),
                      ),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _BookMenu(
                            book: book,
                            onChangeCover: () => onChangeCover(book),
                            onRemove: () => onRemove(book),
                          ),
                          // Tapping the row opens the book, so it is marked
                          // the way a menu row was: with the arrow into it.
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ],
                      ),
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
  const _GridBookTile({
    required this.book,
    required this.onTap,
    required this.onChangeCover,
    required this.onRemove,
  });

  final Audiobook book;
  final VoidCallback onTap;
  final VoidCallback onChangeCover;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Semantics(
          button: true,
          label: 'Open ${book.title}, by ${book.author}',
          child: ExcludeSemantics(
            child: InkWell(
              onTap: onTap,
              borderRadius: AppRadii.control,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The largest square the tile can give the artwork, so
                    // covers stay square as text scaling grows the rows below.
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ChromeFrame(
                            child: _Cover(book: book, letterSize: 48),
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
        ),
        // The menu sits over the corner of the artwork, where it stays
        // reachable by pointer and screen reader without crowding the title.
        Positioned(
          top: AppSpacing.xs,
          right: AppSpacing.xs,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surface.withValues(alpha: 0.72),
              shape: BoxShape.circle,
            ),
            child: _BookMenu(
              book: book,
              onChangeCover: onChangeCover,
              onRemove: onRemove,
            ),
          ),
        ),
      ],
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
            // A bar sunk into its groove rather than floating on the row.
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: value.clamp(0.0, 1.0),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
          ],
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.readout(
              Theme.of(context).textTheme.labelMedium,
            ).copyWith(color: scheme.primary),
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

/// A book's square artwork, falling back to its initial when there is none,
/// or when the stored image has gone missing.
///
/// Covers are squared when they are stored, so the fit here only has to hold
/// the line for artwork that arrived before that, or that could not be
/// decoded: it fills the square and centre-crops rather than distorting.
class _Cover extends StatelessWidget {
  const _Cover({required this.book, this.letterSize = 22});

  final Audiobook book;
  final double letterSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final coverPath = book.coverPath;
    final letter = Center(
      child: Text(
        book.title.isEmpty ? 'A' : book.title.characters.first.toUpperCase(),
        style: TextStyle(
          fontSize: letterSize,
          fontWeight: FontWeight.w700,
          color: scheme.onSecondaryContainer,
        ),
      ),
    );

    return ColoredBox(
      color: scheme.secondaryContainer,
      child: coverPath == null || !File(coverPath).existsSync()
          ? letter
          : Image.file(
              File(coverPath),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => letter,
            ),
    );
  }
}

/// The per-book actions that do not belong on the row itself: giving a book a
/// cover, and taking it back out of the library.
class _BookMenu extends StatelessWidget {
  const _BookMenu({
    required this.book,
    required this.onChangeCover,
    required this.onRemove,
  });

  final Audiobook book;
  final VoidCallback onChangeCover;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_BookAction>(
      tooltip: 'More options for ${book.title}',
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (action) => switch (action) {
        _BookAction.changeCover => onChangeCover(),
        _BookAction.remove => onRemove(),
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _BookAction.changeCover,
          child: Text(book.coverPath == null ? 'Add Cover' : 'Change Cover'),
        ),
        const PopupMenuItem(
          value: _BookAction.remove,
          child: Text('Remove from Library'),
        ),
      ],
    );
  }
}

enum _BookAction { changeCover, remove }
