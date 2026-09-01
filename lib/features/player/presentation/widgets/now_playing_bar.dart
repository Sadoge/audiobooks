import 'dart:io';

import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/theme/retro_chrome.dart';
import 'package:audiobooks/app/widgets/retro_widgets.dart';
import 'package:audiobooks/features/player/presentation/cubit/now_playing_cubit.dart';
import 'package:audiobooks/features/player/presentation/cubit/now_playing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The strip along the bottom of the Library saying what is still playing.
///
/// A book now carries on past the player page and past the app itself, so the
/// Library would otherwise be the one place a listener could not tell that
/// anything was running or stop it. This is the housing's bottom edge: a
/// cover behind a window, the readout, and one key.
class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({required this.onOpen, super.key});

  /// Called with the book to return to.
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingCubit, NowPlayingState>(
      builder: (context, state) {
        final book = state.book;
        // Nothing loaded is nothing to say. The bar takes no room at all
        // rather than sitting there empty.
        if (!state.hasBook || book == null) return const SizedBox.shrink();

        final scheme = Theme.of(context).colorScheme;
        final chrome = RetroChrome.of(context);
        final subtitle = state.chapterTitle ?? book.author;

        return Semantics(
          container: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: chrome.chrome,
              border: Border(
                top: BorderSide(
                  color: chrome.chromeEdge,
                  width: AppStroke.hairline,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => onOpen(book.id),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.sm,
                          AppSpacing.xs,
                          AppSpacing.xs,
                          AppSpacing.xs,
                        ),
                        child: Semantics(
                          button: true,
                          label: 'Now playing ${book.title}. Return to player',
                          child: ExcludeSemantics(
                            child: Row(
                              children: [
                                _Thumbnail(coverPath: book.coverPath),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleSmall,
                                      ),
                                      Text(
                                        subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: scheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: _PlayKey(isPlaying: state.isPlaying),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The cover, behind the same moulded bezel the player uses, at the size a
/// bottom strip can carry.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.coverPath});

  static const double _side = 40;

  final String? coverPath;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final path = coverPath;
    final exists = path != null && File(path).existsSync();

    return SizedBox.square(
      dimension: _side,
      child: ChromeFrame(
        thickness: AppStroke.hairline,
        child: exists
            ? Image.file(File(path), fit: BoxFit.cover)
            : ColoredBox(
                color: scheme.secondaryContainer,
                child: Icon(
                  Icons.headphones_rounded,
                  size: AppIconSize.small,
                  color: scheme.onSecondaryContainer.withValues(alpha: 0.5),
                ),
              ),
      ),
    );
  }
}

/// One key, doing the only thing worth doing from another screen.
class _PlayKey extends StatelessWidget {
  const _PlayKey({required this.isPlaying});

  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: isPlaying ? 'Pause' : 'Play',
      onPressed: context.read<NowPlayingCubit>().togglePlayback,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(44),
        shape: const CircleBorder(),
      ),
      icon: Icon(
        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        size: AppIconSize.small,
      ),
    );
  }
}
