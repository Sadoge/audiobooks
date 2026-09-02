import 'dart:io';

import 'package:audiobooks/app/format/byte_size.dart';
import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/theme/retro_chrome.dart';
import 'package:audiobooks/app/widgets/retro_widgets.dart';
import 'package:audiobooks/features/shelf/domain/entities/shelf_book.dart';
import 'package:flutter/material.dart';

/// The books in the shared folder that this device has not got.
///
/// Every row offers the same one thing — bringing the book across — so the
/// list is a menu of books rather than a grid of covers: nothing here can be
/// opened or played until it has been downloaded.
class ShelfBookList extends StatelessWidget {
  const ShelfBookList({
    required this.books,
    required this.downloading,
    required this.onDownload,
    super.key,
  });

  final List<ShelfBook> books;

  /// How far along each download in flight is, keyed by book.
  final Map<String, double> downloading;
  final ValueChanged<ShelfBook> onDownload;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.crossAxisExtent >= 720;
        return SliverPadding(
          padding: EdgeInsets.fromLTRB(
            desktop ? AppSpacing.xl : 0,
            desktop ? AppSpacing.sm : 0,
            desktop ? AppSpacing.xl : 0,
            AppSpacing.xxl,
          ),
          sliver: SliverList.separated(
            itemCount: books.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final book = books[index];
              final progress = downloading[book.key];
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
                  child: ChromeFrame(thickness: 2, child: _Cover(book: book)),
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
                    Text(
                      _summaryOf(book),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                trailing: progress == null
                    ? IconButton(
                        tooltip: 'Download ${book.title}',
                        onPressed: () => onDownload(book),
                        icon: const Icon(Icons.download_rounded),
                      )
                    : _DownloadProgress(fraction: progress),
                // The whole row is the key, as it is in the library, but a
                // book already on its way is left alone.
                onTap: progress == null ? () => onDownload(book) : null,
              );
            },
          ),
        );
      },
    );
  }
}

/// What a book costs to bring across, and what it is made of.
String _summaryOf(ShelfBook book) {
  final parts = <String>[formatByteSize(book.totalBytes)];
  if (book.duration > Duration.zero) {
    final hours = book.duration.inHours;
    final minutes = book.duration.inMinutes.remainder(60);
    parts.add(hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m');
  }
  if (book.chapterCount > 1) parts.add('${book.chapterCount} chapters');
  return parts.join(' · ');
}

/// How far a download has got, on the readout face: a device reported a
/// transfer as a figure, not as a bar that could only be watched.
class _DownloadProgress extends StatelessWidget {
  const _DownloadProgress({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    final percent = (fraction * 100).clamp(0, 100).round();
    return Semantics(
      liveRegion: true,
      label: 'Downloading, $percent percent',
      excludeSemantics: true,
      child: ScreenPanel(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          '$percent%',
          style: AppFonts.readout(
            Theme.of(context).textTheme.bodyMedium,
          ).copyWith(color: RetroChrome.of(context).screenInk),
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.book});

  final ShelfBook book;

  @override
  Widget build(BuildContext context) {
    final path = book.coverPath;
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: path == null || !File(path).existsSync()
          ? Icon(
              Icons.book_outlined,
              size: 20,
              color: theme.colorScheme.outline,
            )
          : Image.file(File(path), fit: BoxFit.cover),
    );
  }
}
