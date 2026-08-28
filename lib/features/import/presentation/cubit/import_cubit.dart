import 'package:audiobooks/core/errors/app_failure.dart';
import 'package:audiobooks/core/files/device_file_gateway.dart';
import 'package:audiobooks/core/files/picked_audio_file.dart';
import 'package:audiobooks/features/import/presentation/cubit/import_state.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ImportCubit extends Cubit<ImportState> {
  ImportCubit(this._files, this._repository) : super(const ImportState());

  final DeviceFileGateway _files;
  final AudiobookRepository _repository;

  Future<void> chooseFiles() async {
    emit(state.copyWith(status: ImportStatus.choosing, errorMessage: null));
    try {
      final selected = await _files.pickAudioFiles();
      emit(
        state.copyWith(
          status: selected.isEmpty
              ? ImportStatus.initial
              : ImportStatus.selected,
          files: selected,
        ),
      );
    } on AppFailure catch (failure) {
      emit(
        state.copyWith(
          status: ImportStatus.failure,
          errorMessage: failure.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ImportStatus.failure,
          errorMessage: 'Audio files could not be selected. Try again.',
        ),
      );
    }
  }

  Future<void> importSeparateBooks() async {
    if (state.files.isEmpty) return;
    emit(state.copyWith(status: ImportStatus.importing, errorMessage: null));
    try {
      final now = DateTime.now();
      for (var index = 0; index < state.files.length; index++) {
        final file = state.files[index];
        final id = '${now.microsecondsSinceEpoch}-$index';
        final durablePath = await _files.persist(file, bookId: id);
        await _repository.save(
          Audiobook(
            id: id,
            title: _titleFrom(file),
            author: 'Unknown Author',
            dateAdded: now.add(Duration(microseconds: index)),
            fileType: AudioFileType.values.byName(file.extension),
            sourcePath: durablePath,
          ),
        );
      }
      emit(state.copyWith(status: ImportStatus.completed));
    } on AppFailure catch (failure) {
      emit(
        state.copyWith(
          status: ImportStatus.failure,
          errorMessage: failure.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ImportStatus.failure,
          errorMessage: 'The selected audiobooks could not be imported.',
        ),
      );
    }
  }

  String _titleFrom(PickedAudioFile file) {
    final suffix = '.${file.extension}';
    return file.name.toLowerCase().endsWith(suffix)
        ? file.name.substring(0, file.name.length - suffix.length)
        : file.name;
  }
}
