import 'dart:io';

import 'package:audiobooks/app/di/configure_dependencies.dart';
import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/theme/retro_chrome.dart';
import 'package:audiobooks/app/widgets/retro_widgets.dart';
import 'package:audiobooks/features/import/presentation/cubit/import_cubit.dart';
import 'package:audiobooks/features/import/presentation/cubit/import_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ImportPage extends StatelessWidget implements AutoRouteWrapper {
  const ImportPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) =>
      BlocProvider(create: (_) => getIt<ImportCubit>(), child: this);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImportCubit, ImportState>(
      listener: (context, state) {
        if (state.status == ImportStatus.completed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Audiobooks imported for offline use.'),
            ),
          );
          context.router.maybePop();
        }
      },
      builder: (context, state) {
        final busy =
            state.status == ImportStatus.choosing ||
            state.status == ImportStatus.importing;
        // Several files are usually one book split into chapter tracks, so
        // that is the offer that leads.
        final multiple = state.files.length > 1;
        return Scaffold(
          appBar: const ChromeAppBar(title: Text('Import Audiobooks')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    state.files.isEmpty
                        ? 'Choose audio files'
                        : multiple
                        ? '${state.files.length} files selected'
                        : '1 file selected',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (multiple) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'They become chapters of one book, in the order shown.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    state.files.isEmpty
                        ? 'Select MP3, M4A, M4B, or AAC files from this device. '
                              'Chapter markers inside a file are picked up '
                              'automatically.'
                        : 'Files are copied into app-owned storage so they remain '
                              'available for offline playback.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (state.files.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _CoverAttachment(coverPath: state.coverPath, busy: busy),
                  ],
                  if (state.errorMessage case final message?) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: state.files.isEmpty
                        ? Center(
                            child: ScreenPanel(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              child: Icon(
                                Icons.audio_file_outlined,
                                size: 64,
                                color: RetroChrome.of(context).screenInkDim,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: state.files.length,
                            separatorBuilder: (_, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final file = state.files[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.graphic_eq_rounded),
                                title: Text(file.name),
                                subtitle: Text(
                                  '${(file.sizeBytes / 1048576).toStringAsFixed(1)} MB',
                                  style: AppFonts.readout(
                                    Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  if (state.status == ImportStatus.importing &&
                      state.files.length > 1) ...[
                    const SizedBox(height: AppSpacing.sm),
                    ScreenPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Reading ${state.importedFiles + 1} of '
                            '${state.files.length}',
                            style:
                                AppFonts.readout(
                                  Theme.of(context).textTheme.bodyMedium,
                                ).copyWith(
                                  color: RetroChrome.of(context).screenInk,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: state.importedFiles / state.files.length,
                              backgroundColor: RetroChrome.of(
                                context,
                              ).screenEdge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: busy
                        ? null
                        : state.files.isEmpty
                        ? context.read<ImportCubit>().chooseFiles
                        : multiple
                        ? context.read<ImportCubit>().importAsSingleBook
                        : context.read<ImportCubit>().importSeparateBooks,
                    icon: busy
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            state.files.isEmpty
                                ? Icons.folder_open_rounded
                                : Icons.download_done_rounded,
                          ),
                    label: Text(
                      state.files.isEmpty
                          ? 'Choose Files'
                          : multiple
                          ? 'Import as One Book'
                          : 'Import Audiobook',
                    ),
                  ),
                  if (multiple) ...[
                    const SizedBox(height: AppSpacing.xs),
                    OutlinedButton.icon(
                      onPressed: busy
                          ? null
                          : context.read<ImportCubit>().importSeparateBooks,
                      icon: const Icon(Icons.library_books_outlined),
                      label: Text(
                        'Import as ${state.files.length} Separate Books',
                      ),
                    ),
                  ],
                  if (state.files.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    TextButton(
                      onPressed: busy
                          ? null
                          : context.read<ImportCubit>().chooseFiles,
                      child: const Text('Choose Different Files'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Offers a cover for the books about to be imported.
///
/// Artwork usually comes out of the files themselves, so this stays a quiet
/// row: it explains what will happen and only asks for an image when the
/// listener wants a different one.
class _CoverAttachment extends StatelessWidget {
  const _CoverAttachment({required this.coverPath, required this.busy});

  final String? coverPath;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ImportCubit>();
    final scheme = Theme.of(context).colorScheme;
    final attached = coverPath != null && File(coverPath!).existsSync();

    return Row(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: ChromeFrame(
            thickness: 2,
            child: attached
                ? Image.file(File(coverPath!), fit: BoxFit.cover)
                : ColoredBox(
                    color: scheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_outlined,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Cover', style: Theme.of(context).textTheme.titleMedium),
              Text(
                attached
                    ? 'Your image is used instead of any artwork in the files.'
                    : 'Artwork in the files, or beside them, is used '
                          'automatically.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: busy ? null : cubit.attachCover,
          child: Text(attached ? 'Change' : 'Add Cover'),
        ),
        if (attached)
          IconButton(
            tooltip: 'Use the artwork in the files',
            onPressed: busy ? null : cubit.removeAttachedCover,
            icon: const Icon(Icons.close_rounded),
          ),
      ],
    );
  }
}
