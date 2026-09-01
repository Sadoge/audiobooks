import 'dart:io';

import 'package:audiobooks/app/format/playback_duration.dart';
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
/// anything was running or work it. This is the housing's bottom edge: a cover
/// behind a window, what is playing, the transport, and the counter.
///
/// The transport is the same one the player's wheel offers, minus the parts
/// that need the whole screen: play and pause, and a chapter either way on a
/// book that has chapters. The counter measures the chapter, as the player's
/// scrubber does, so the two never disagree.
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

        final chrome = RetroChrome.of(context);

        return DecoratedBox(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _NowPlayingLabel(
                        state: state,
                        onTap: () => onOpen(book.id),
                      ),
                    ),
                    _Transport(state: state),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                ),
                _Counter(state: state),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The cover and what is playing, which is also the way back to the player.
class _NowPlayingLabel extends StatelessWidget {
  const _NowPlayingLabel({required this.state, required this.onTap});

  final NowPlayingState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final book = state.book!;
    final subtitle = state.chapterTitle ?? book.author;

    return Semantics(
      button: true,
      label: 'Now playing ${book.title}. Return to player',
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            // Tight above and below: the strip is an edge of the housing,
            // and the keys beside it already set the row's height.
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.xxs,
              AppSpacing.xs,
              AppSpacing.xxs,
            ),
            child: Row(
              children: [
                _Thumbnail(coverPath: book.coverPath),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
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
    );
  }
}

/// Play or pause, and a chapter either way on a book that has chapters.
class _Transport extends StatelessWidget {
  const _Transport({required this.state});

  final NowPlayingState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NowPlayingCubit>();
    final isPlaying = state.isPlaying;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Chapter keys only earn their place on a book divided into any, the
        // same rule the player's wheel goes by.
        if (state.hasChapters)
          _ChapterKey(
            tooltip: 'Previous chapter',
            icon: Icons.skip_previous_rounded,
            onPressed: cubit.previousChapter,
          ),
        IconButton.filled(
          tooltip: isPlaying ? 'Pause' : 'Play',
          onPressed: cubit.togglePlayback,
          style: IconButton.styleFrom(
            minimumSize: const Size.square(44),
            shape: const CircleBorder(),
          ),
          icon: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: AppIconSize.small,
          ),
        ),
        if (state.hasChapters)
          _ChapterKey(
            tooltip: 'Next chapter',
            icon: Icons.skip_next_rounded,
            onPressed: cubit.nextChapter,
          ),
      ],
    );
  }
}

/// A quiet key beside the lit one, so play and pause stays the primary thing
/// on the strip.
class _ChapterKey extends StatelessWidget {
  const _ChapterKey({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(44),
        padding: EdgeInsets.zero,
        shape: const CircleBorder(),
        foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      icon: Icon(icon, size: AppIconSize.small),
    );
  }
}

/// The counter: how far into the chapter, how much of it is left, and a
/// hairline between them holding the position.
class _Counter extends StatelessWidget {
  const _Counter({required this.state});

  final NowPlayingState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chrome = RetroChrome.of(context);
    final progress = state.chapterProgress;
    final remaining = state.chapterRemaining;
    final digits = AppFonts.readout(theme.textTheme.labelSmall).copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        0,
        AppSpacing.sm,
        AppSpacing.xs,
      ),
      child: Semantics(
        label: 'Chapter position',
        value: remaining == null
            ? formatPlaybackDuration(state.position)
            : '${formatPlaybackDuration(state.position)} of '
                  '${formatPlaybackDuration(state.chapterDuration)}',
        child: ExcludeSemantics(
          child: Row(
            children: [
              Text(formatPlaybackDuration(state.position), style: digits),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppStroke.hairline),
                    child: LinearProgressIndicator(
                      // Null while the chapter's length is unknown would spin;
                      // an empty track says the same thing and stays still.
                      value: progress ?? 0,
                      minHeight: 2,
                      backgroundColor: chrome.chromeEdge,
                    ),
                  ),
                ),
              ),
              if (remaining != null)
                Text('-${formatPlaybackDuration(remaining)}', style: digits),
            ],
          ),
        ),
      ),
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
