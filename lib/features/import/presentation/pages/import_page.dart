import 'package:audiobooks/app/di/configure_dependencies.dart';
import 'package:audiobooks/app/theme/app_tokens.dart';
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
          appBar: AppBar(title: const Text('Import Audiobooks')),
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
                        ? const Center(
                            child: Icon(Icons.audio_file_outlined, size: 64),
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
                                ),
                              );
                            },
                          ),
                  ),
                  if (state.status == ImportStatus.importing &&
                      state.files.length > 1) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Reading ${state.importedFiles + 1} of '
                      '${state.files.length}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    LinearProgressIndicator(
                      value: state.importedFiles / state.files.length,
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
