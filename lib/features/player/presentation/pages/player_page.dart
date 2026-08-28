import 'dart:io';

import 'package:audiobooks/app/di/configure_dependencies.dart';
import 'package:audiobooks/app/theme/app_tokens.dart';
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
          appBar: AppBar(
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
                          showChapters: true,
                          showChapterSkipControls: true,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Center(child: _BookArtwork(book: book, desktop: false)),
                      const SizedBox(height: AppSpacing.xl),
                      _ListeningDetails(
                        book: book,
                        playback: playback,
                        showChapters: true,
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
    final width = desktop ? 320.0 : 240.0;
    final height = desktop ? 430.0 : 320.0;
    final coverExists = coverPath != null && File(coverPath).existsSync();

    return Semantics(
      image: true,
      label: 'Cover for ${book.title}',
      child: ExcludeSemantics(
        child: ClipRRect(
          borderRadius: AppRadii.cover,
          child: SizedBox(
            width: width,
            height: height,
            child: coverExists
                ? Image.file(File(coverPath), fit: BoxFit.cover)
                : ColoredBox(
                    color: scheme.secondaryContainer,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.headphones_rounded,
                          size: desktop ? 76 : 64,
                          color: scheme.onSecondaryContainer.withValues(
                            alpha: 0.34,
                          ),
                        ),
                        Positioned(
                          left: AppSpacing.lg,
                          right: AppSpacing.lg,
                          bottom: AppSpacing.lg,
                          child: Text(
                            book.title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: scheme.onSecondaryContainer),
                          ),
                        ),
                      ],
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
    this.showChapters = false,
    this.showChapterSkipControls = false,
  });

  final Audiobook book;
  final AudioPlaybackSnapshot playback;
  final bool showChapters;
  final bool showChapterSkipControls;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayerCubit>();
    final chapter = _activeChapter(book, playback.chapterId);
    final duration = playback.duration > Duration.zero
        ? playback.duration
        : chapter?.duration ?? book.duration;
    final durationMs = duration.inMilliseconds;
    final positionMs = playback.position.inMilliseconds.clamp(
      0,
      durationMs > 0 ? durationMs : 1,
    );
    final isPlaying = playback.status == PlaybackStatus.playing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          chapter?.title ?? 'Audiobook',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(book.title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xxs),
        Text(book.author, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppSpacing.lg),
        Semantics(
          label: 'Playback position',
          value:
              '${_formatDuration(playback.position)} of '
              '${_formatDuration(duration)}',
          child: Slider(
            value: positionMs.toDouble(),
            max: (durationMs > 0 ? durationMs : 1).toDouble(),
            secondaryTrackValue: playback.bufferedPosition.inMilliseconds
                .clamp(0, durationMs > 0 ? durationMs : 1)
                .toDouble(),
            onChanged: durationMs <= 0
                ? null
                : (value) => cubit.seek(Duration(milliseconds: value.round())),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(playback.position)),
              Text('-${_formatDuration(duration - playback.position)}'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showChapterSkipControls) ...[
              IconButton(
                tooltip: 'Previous chapter',
                onPressed: cubit.previousChapter,
                icon: const Icon(Icons.skip_previous_rounded),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            IconButton(
              tooltip: 'Rewind 15 seconds',
              onPressed: cubit.rewind,
              icon: const _RewindFifteenIcon(),
            ),
            const SizedBox(width: AppSpacing.sm),
            FilledButton(
              onPressed: cubit.togglePlayback,
              style: FilledButton.styleFrom(
                minimumSize: const Size.square(64),
                padding: EdgeInsets.zero,
                shape: const CircleBorder(),
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 34,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              tooltip: 'Forward 30 seconds',
              onPressed: cubit.forward,
              icon: const Icon(Icons.forward_30_rounded),
            ),
            if (showChapterSkipControls) ...[
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                tooltip: 'Next chapter',
                onPressed: cubit.nextChapter,
                icon: const Icon(Icons.skip_next_rounded),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: PopupMenuButton<double>(
            tooltip: 'Playback speed',
            initialValue: playback.speed,
            onSelected: cubit.setSpeed,
            itemBuilder: (context) => _playbackSpeeds
                .map(
                  (speed) =>
                      PopupMenuItem(value: speed, child: Text('${speed}x')),
                )
                .toList(growable: false),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.speed_rounded, size: 20),
                  const SizedBox(width: AppSpacing.xs),
                  Text('${playback.speed}x'),
                ],
              ),
            ),
          ),
        ),
        if (showChapters && book.chapters.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Text('Chapters', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          ...book.chapters.map(
            (item) => ListTile(
              selected: item.id == playback.chapterId,
              contentPadding: EdgeInsets.zero,
              leading: SizedBox(width: 28, child: Text('${item.index + 1}')),
              title: Text(item.title),
              trailing: item.duration > Duration.zero
                  ? Text(_formatDuration(item.duration))
                  : null,
              onTap: () => cubit.selectChapter(item.id),
            ),
          ),
        ],
      ],
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
      dimension: 24,
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

AudiobookChapter? _activeChapter(Audiobook book, String? chapterId) {
  if (book.chapters.isEmpty) return null;
  return book.chapters.firstWhere(
    (chapter) => chapter.id == chapterId,
    orElse: () => book.chapters.first,
  );
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
