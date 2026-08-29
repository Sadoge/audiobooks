import 'dart:io';

import 'package:audiobooks/app/di/configure_dependencies.dart';
import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/theme/retro_chrome.dart';
import 'package:audiobooks/app/widgets/retro_widgets.dart';
import 'package:audiobooks/core/audio/audio_playback_snapshot.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/player/presentation/cubit/player_cubit.dart';
import 'package:audiobooks/features/player/presentation/cubit/player_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class PlayerPage extends StatelessWidget {
  const PlayerPage({@PathParam('bookId') required this.bookId, super.key});

  final String bookId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PlayerCubit>()..load(bookId),
      child: const PlayerView(),
    );
  }
}

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerCubit, PlayerViewState>(
      builder: (context, state) {
        final book = state.book;
        return Scaffold(
          appBar: ChromeAppBar(
            title: Text(
              book?.title ?? 'Now Playing',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: switch (state.status) {
            PlayerViewStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            PlayerViewStatus.failure => _PlayerFailure(
              message:
                  state.errorMessage ?? 'This audiobook could not be played.',
            ),
            PlayerViewStatus.ready => _AdaptivePlayer(
              book: book!,
              playback: state.playback,
            ),
          },
        );
      },
    );
  }
}

class _AdaptivePlayer extends StatelessWidget {
  const _AdaptivePlayer({required this.book, required this.playback});

  final Audiobook book;
  final AudioPlaybackSnapshot playback;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();
    return Focus(
      autofocus: true,
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.space): cubit.togglePlayback,
          const SingleActivator(LogicalKeyboardKey.arrowLeft): cubit.rewind,
          const SingleActivator(LogicalKeyboardKey.arrowRight): cubit.forward,
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth >= 900;
            final content = desktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: _BookArtwork(book: book, desktop: true),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxl),
                      Expanded(
                        child: _ListeningDetails(
                          book: book,
                          playback: playback,
                          desktop: true,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Center(child: _BookArtwork(book: book, desktop: false)),
                      const SizedBox(height: AppSpacing.lg),
                      _ListeningDetails(
                        book: book,
                        playback: playback,
                        desktop: false,
                      ),
                    ],
                  );

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: desktop ? AppSpacing.xxl : AppSpacing.lg,
                vertical: desktop ? AppSpacing.xl : AppSpacing.lg,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1160),
                  child: content,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BookArtwork extends StatelessWidget {
  const _BookArtwork({required this.book, required this.desktop});

  final Audiobook book;
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final coverPath = book.coverPath;
    // Audiobook covers are square, so the window onto them is too. The bezel
    // is drawn inside the plane, so the artwork keeps its measured size. The
    // compact plane stays small enough that the wheel below it is still on
    // the screen without scrolling, as it was on the device.
    final side = desktop ? 360.0 : 216.0;
    final coverExists = coverPath != null && File(coverPath).existsSync();

    return Semantics(
      image: true,
      label: 'Cover for ${book.title}',
      child: ExcludeSemantics(
        child: SizedBox(
          width: side,
          height: side,
          child: ChromeFrame(
            child: coverExists
                ? Image.file(File(coverPath), fit: BoxFit.cover)
                : ColoredBox(
                    color: scheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.headphones_rounded,
                            size: desktop ? 76 : 52,
                            color: scheme.onSecondaryContainer.withValues(
                              alpha: 0.34,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Flexible(
                            child: Text(
                              book.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: scheme.onSecondaryContainer,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ListeningDetails extends StatelessWidget {
  const _ListeningDetails({
    required this.book,
    required this.playback,
    required this.desktop,
  });

  final Audiobook book;
  final AudioPlaybackSnapshot playback;
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    final chapter = _activeChapter(book, playback);
    final duration = playback.duration > Duration.zero
        ? playback.duration
        : chapter?.duration ?? book.duration;
    final isPlaying = playback.status == PlaybackStatus.playing;
    // Chapter transport only earns its place on a book that has chapters.
    final skipChapters = playback.chapterCount > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChapterHeading(book: book, chapter: chapter, playback: playback),
        const SizedBox(height: AppSpacing.md),
        Text(book.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xxs),
        Text(book.author, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.lg),
        _Readout(book: book, playback: playback, duration: duration),
        const SizedBox(height: AppSpacing.md),
        _Transport(
          isPlaying: isPlaying,
          skipChapters: skipChapters,
          desktop: desktop,
        ),
        const SizedBox(height: AppSpacing.md),
        _SpeedKey(speed: playback.speed),
      ],
    );
  }
}

/// The recessed display: where you are in the chapter, and how much of the
/// whole book is still ahead.
class _Readout extends StatelessWidget {
  const _Readout({
    required this.book,
    required this.playback,
    required this.duration,
  });

  final Audiobook book;
  final AudioPlaybackSnapshot playback;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();
    final chrome = RetroChrome.of(context);
    final durationMs = duration.inMilliseconds;
    final positionMs = playback.position.inMilliseconds.clamp(
      0,
      durationMs > 0 ? durationMs : 1,
    );
    final digits = AppFonts.readout(
      Theme.of(context).textTheme.bodyMedium,
    ).copyWith(color: chrome.screenInk);

    return ScreenPanel(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            label: 'Playback position',
            value:
                '${_formatDuration(playback.position)} of '
                '${_formatDuration(duration)}',
            child: SliderTheme(
              data: SliderTheme.of(
                context,
              ).copyWith(inactiveTrackColor: chrome.screenEdge),
              child: Slider(
                value: positionMs.toDouble(),
                max: (durationMs > 0 ? durationMs : 1).toDouble(),
                secondaryTrackValue: playback.bufferedPosition.inMilliseconds
                    .clamp(0, durationMs > 0 ? durationMs : 1)
                    .toDouble(),
                onChanged: durationMs <= 0
                    ? null
                    : (value) =>
                          cubit.seek(Duration(milliseconds: value.round())),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Row(
              children: [
                Text(_formatDuration(playback.position), style: digits),
                // The scrubber measures the chapter, so the book as a whole
                // gets one line between its ends rather than a second bar.
                Expanded(
                  child: _BookRemaining(book: book, playback: playback),
                ),
                Text(
                  '-${_formatDuration(duration - playback.position)}',
                  style: digits,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The wheel. Every key on it is an ordinary button laid over the paint, so
/// the transport keeps its tooltips, focus order, and touch targets.
class _Transport extends StatelessWidget {
  const _Transport({
    required this.isPlaying,
    required this.skipChapters,
    required this.desktop,
  });

  final bool isPlaying;
  final bool skipChapters;
  final bool desktop;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final diameter = ClickWheel.diameterFor(
          constraints.maxWidth,
          limit: desktop ? ClickWheel.maxDiameter : 228,
        );
        return Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ClickWheel(
              diameter: diameter,
              north: skipChapters
                  ? _WheelKey(
                      tooltip: 'Previous chapter',
                      onPressed: cubit.previousChapter,
                      icon: const Icon(Icons.skip_previous_rounded),
                    )
                  : null,
              south: skipChapters
                  ? _WheelKey(
                      tooltip: 'Next chapter',
                      onPressed: cubit.nextChapter,
                      icon: const Icon(Icons.skip_next_rounded),
                    )
                  : null,
              west: _WheelKey(
                tooltip: 'Rewind 15 seconds',
                onPressed: cubit.rewind,
                icon: const _RewindFifteenIcon(),
              ),
              east: _WheelKey(
                tooltip: 'Forward 30 seconds',
                onPressed: cubit.forward,
                icon: const Icon(Icons.forward_30_rounded),
              ),
              centre: FilledButton(
                onPressed: cubit.togglePlayback,
                style: FilledButton.styleFrom(
                  minimumSize: Size.square(diameter * 0.36),
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                ),
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: diameter * 0.155,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// One printed key on the wheel face.
class _WheelKey extends StatelessWidget {
  const _WheelKey({
    required this.tooltip,
    required this.onPressed,
    required this.icon,
  });

  final String tooltip;
  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        minimumSize: const Size.square(48),
        shape: const CircleBorder(),
        foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      icon: icon,
    );
  }
}

/// The speed selector, as a small key beside the wheel rather than on it.
class _SpeedKey extends StatelessWidget {
  const _SpeedKey({required this.speed});

  final double speed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: PopupMenuButton<double>(
        tooltip: 'Playback speed',
        initialValue: speed,
        onSelected: context.read<PlayerCubit>().setSpeed,
        itemBuilder: (context) => _playbackSpeeds
            .map(
              (value) => PopupMenuItem(value: value, child: Text('${value}x')),
            )
            .toList(growable: false),
        child: ChromeKey(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.speed_rounded,
                  size: AppIconSize.small,
                  color: scheme.onSurface,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${speed}x',
                  style: AppFonts.readout(
                    Theme.of(context).textTheme.labelLarge,
                  ).copyWith(color: scheme.onSurface),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The chapter being listened to, and the way into every other chapter.
class _ChapterHeading extends StatelessWidget {
  const _ChapterHeading({
    required this.book,
    required this.chapter,
    required this.playback,
  });

  final Audiobook book;
  final AudiobookChapter? chapter;
  final AudioPlaybackSnapshot playback;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final title = chapter?.title ?? 'Audiobook';
    final numbered =
        playback.chapterCount > 1 &&
        playback.chapterIndex >= 0 &&
        playback.chapterIndex < playback.chapterCount;

    final heading = Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (numbered)
                Text(
                  'Chapter ${playback.chapterIndex + 1} of '
                  '${playback.chapterCount}',
                  style: AppFonts.readout(
                    Theme.of(context).textTheme.labelMedium,
                  ).copyWith(color: scheme.primary),
                ),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        if (book.chapters.length > 1) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: scheme.outline,
          ),
        ],
      ],
    );

    if (book.chapters.length < 2) return heading;

    // A menu row: ruled above and below, and arrowed into.
    return Semantics(
      button: true,
      label: 'Chapters. Now playing $title',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                color: scheme.outlineVariant,
                width: AppStroke.hairline,
              ),
            ),
          ),
          child: InkWell(
            onTap: () => _openChapters(context, book),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.sm,
              ),
              child: heading,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _openChapters(BuildContext context, Audiobook book) {
  // The sheet is a separate route, so the cubit is handed over rather than
  // looked up again below it.
  final cubit = context.read<PlayerCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => BlocProvider<PlayerCubit>.value(
      value: cubit,
      child: _ChapterSheet(
        book: book,
        openAt: cubit.state.playback.chapterIndex,
      ),
    ),
  );
}

/// Every chapter with its length, opening on the one playing now.
///
/// Stateful so that playback ticking on underneath cannot rebuild the list back
/// to where it was opened while the reader is scrolling it.
class _ChapterSheet extends StatefulWidget {
  const _ChapterSheet({required this.book, required this.openAt});

  final Audiobook book;
  final int openAt;

  @override
  State<_ChapterSheet> createState() => _ChapterSheetState();
}

class _ChapterSheetState extends State<_ChapterSheet> {
  static const _rowHeight = 64.0;

  late final ScrollController _controller = ScrollController(
    initialScrollOffset: widget.openAt > 0 ? widget.openAt * _rowHeight : 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.72,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(
                'Chapters',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Flexible(
              child: BlocBuilder<PlayerCubit, PlayerViewState>(
                buildWhen: (previous, current) =>
                    previous.playback.chapterIndex !=
                    current.playback.chapterIndex,
                builder: (context, state) => ListView.builder(
                  controller: _controller,
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  itemExtent: _rowHeight,
                  itemCount: widget.book.chapters.length,
                  itemBuilder: (context, index) => _ChapterRow(
                    chapter: widget.book.chapters[index],
                    isPlaying: index == state.playback.chapterIndex,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterRow extends StatelessWidget {
  const _ChapterRow({required this.chapter, required this.isPlaying});

  final AudiobookChapter chapter;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final chrome = RetroChrome.of(context);
    // The row you are on is the amber bar, the way it was on the menus these
    // controls came from. Its ink comes from the palette rather than being
    // white: on the lit amber of dark appearance, white does not carry.
    final ink = isPlaying ? chrome.selectionInk : scheme.onSurfaceVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isPlaying ? chrome.selection : null,
        border: Border(
          bottom: BorderSide(
            color: scheme.outlineVariant,
            width: AppStroke.hairline,
          ),
        ),
      ),
      child: ListTile(
        selected: isPlaying,
        selectedColor: chrome.selectionInk,
        leading: SizedBox(
          width: 28,
          child: isPlaying
              ? const Icon(Icons.graphic_eq_rounded, size: AppIconSize.small)
              : Text(
                  '${chapter.index + 1}',
                  style: AppFonts.readout(
                    Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
        ),
        title: Text(
          chapter.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: chapter.duration > Duration.zero
            ? Text(
                _formatDuration(chapter.duration),
                style: AppFonts.readout(
                  Theme.of(context).textTheme.bodySmall,
                ).copyWith(color: ink),
              )
            : null,
        onTap: () {
          context.read<PlayerCubit>().selectChapter(chapter.id);
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

/// How much of the whole book is left, sitting between the chapter's own ends.
class _BookRemaining extends StatelessWidget {
  const _BookRemaining({required this.book, required this.playback});

  final Audiobook book;
  final AudioPlaybackSnapshot playback;

  @override
  Widget build(BuildContext context) {
    final total = playback.bookDuration;
    // Without chapters the times on either side already measure the book.
    if (book.chapters.isEmpty || total <= Duration.zero) {
      return const SizedBox.shrink();
    }

    return Text(
      '${_formatDuration(total - playback.bookPosition)} left in book',
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppFonts.readout(
        Theme.of(context).textTheme.bodySmall,
      ).copyWith(color: RetroChrome.of(context).screenInkDim),
    );
  }
}

class _PlayerFailure extends StatelessWidget {
  const _PlayerFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

class _RewindFifteenIcon extends StatelessWidget {
  const _RewindFifteenIcon();

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color;
    return SizedBox.square(
      dimension: AppIconSize.regular,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.replay_rounded),
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              '15',
              style: TextStyle(
                color: color,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

AudiobookChapter? _activeChapter(
  Audiobook book,
  AudioPlaybackSnapshot playback,
) {
  if (book.chapters.isEmpty) return null;
  final index = playback.chapterIndex;
  return index >= 0 && index < book.chapters.length
      ? book.chapters[index]
      : book.chapters.first;
}

String _formatDuration(Duration duration) {
  final safe = duration.isNegative ? Duration.zero : duration;
  final hours = safe.inHours;
  final minutes = safe.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = safe.inSeconds.remainder(60).toString().padLeft(2, '0');
  return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
}

const _playbackSpeeds = <double>[
  0.5,
  0.75,
  0.9,
  1,
  1.1,
  1.2,
  1.25,
  1.5,
  1.75,
  2,
  2.5,
  3,
];
