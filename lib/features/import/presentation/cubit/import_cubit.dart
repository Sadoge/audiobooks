import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';
import 'package:audiobooks/core/audio/metadata/audio_metadata_service.dart';
import 'package:audiobooks/core/errors/app_failure.dart';
import 'package:audiobooks/core/files/device_file_gateway.dart';
import 'package:audiobooks/core/files/picked_audio_file.dart';
import 'package:audiobooks/features/import/presentation/cubit/import_state.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ImportCubit extends Cubit<ImportState> {
  ImportCubit(this._files, this._repository, this._metadata)
    : super(const ImportState());

  final DeviceFileGateway _files;
  final AudiobookRepository _repository;
  final AudioMetadataService _metadata;

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

  /// Imports every selected file as its own book, keeping any chapter markers
  /// the file carries.
  Future<void> importSeparateBooks() => _import((files) async {
    final now = DateTime.now();
    for (var index = 0; index < files.length; index++) {
      final file = files[index];
      final id = '${now.microsecondsSinceEpoch}-$index';
      final path = await _files.persist(file, bookId: id);
      final metadata = await _metadata.read(path);

      await _repository.save(
        Audiobook(
          id: id,
          title: metadata.title ?? _titleFrom(file),
          author: metadata.author ?? 'Unknown Author',
          narrator: metadata.narrator,
          dateAdded: now.add(Duration(microseconds: index)),
          fileType: _fileTypeFor(file.extension),
          sourcePath: path,
          duration: metadata.duration,
          chapters: _embeddedChapters(id, path, metadata),
        ),
      );
      emit(state.copyWith(importedFiles: index + 1));
    }
  });

  /// Imports the selection as one book, in the order chosen, with a chapter
  /// per file. This is the usual shape of an audiobook split across MP3s.
  Future<void> importAsSingleBook() => _import((files) async {
    final now = DateTime.now();
    final id = '${now.microsecondsSinceEpoch}';
    final chapters = <AudiobookChapter>[];
    var total = Duration.zero;
    String? author;
    String? narrator;

    for (var index = 0; index < files.length; index++) {
      final file = files[index];
      final path = await _files.persist(file, bookId: id);
      final metadata = await _metadata.read(path);
      author ??= metadata.author;
      narrator ??= metadata.narrator;
      total += metadata.duration;

      chapters.add(
        AudiobookChapter(
          id: _chapterId(id, index),
          bookId: id,
          title: metadata.title ?? _titleFrom(file),
          index: index,
          filePath: path,
          duration: metadata.duration,
        ),
      );
      emit(state.copyWith(importedFiles: index + 1));
    }

    await _repository.save(
      Audiobook(
        id: id,
        title: _sharedTitleFor(files),
        author: author ?? 'Unknown Author',
        narrator: narrator,
        dateAdded: now,
        fileType: _fileTypeFor(files.first.extension),
        sourcePath: chapters.first.filePath,
        duration: total,
        chapters: chapters,
      ),
    );
  });

  Future<void> _import(
    Future<void> Function(List<PickedAudioFile> files) run,
  ) async {
    final files = state.files;
    if (files.isEmpty) return;
    emit(
      state.copyWith(
        status: ImportStatus.importing,
        errorMessage: null,
        importedFiles: 0,
      ),
    );
    try {
      await run(files);
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

  /// Turns markers inside one file into chapters spanning it end to end.
  List<AudiobookChapter> _embeddedChapters(
    String bookId,
    String path,
    AudioFileMetadata metadata,
  ) {
    final markers = metadata.chapters;
    if (markers.length < 2) return const [];

    return [
      for (var index = 0; index < markers.length; index++)
        AudiobookChapter(
          id: _chapterId(bookId, index),
          bookId: bookId,
          title: markers[index].title,
          index: index,
          filePath: path,
          startPosition: markers[index].start,
          duration: _markerDuration(markers, index, metadata.duration),
        ),
    ];
  }

  Duration _markerDuration(
    List<EmbeddedChapter> markers,
    int index,
    Duration fileDuration,
  ) {
    final end = index + 1 < markers.length
        ? markers[index + 1].start
        : fileDuration;
    final span = end - markers[index].start;
    return span.isNegative ? Duration.zero : span;
  }

  /// Chapter ids stay stable across re-imports so stored progress survives.
  String _chapterId(String bookId, int index) => '$bookId::chapter::$index';

  /// Names a grouped book after whatever its files agree on, which for a
  /// numbered set of tracks is the book title itself.
  String _sharedTitleFor(List<PickedAudioFile> files) {
    final first = _titleFrom(files.first);
    if (files.length == 1) return first;

    var shared = first;
    for (final file in files.skip(1)) {
      final other = _titleFrom(file);
      var length = 0;
      while (length < shared.length &&
          length < other.length &&
          shared[length] == other[length]) {
        length++;
      }
      shared = shared.substring(0, length);
    }

    final trimmed = shared.replaceAll(RegExp(r'[\s\-_,.0-9]+$'), '').trim();
    return trimmed.length < 3 ? first : trimmed;
  }

  String _titleFrom(PickedAudioFile file) {
    final suffix = '.${file.extension}';
    return file.name.toLowerCase().endsWith(suffix)
        ? file.name.substring(0, file.name.length - suffix.length)
        : file.name;
  }

  AudioFileType _fileTypeFor(String extension) => AudioFileType.values
      .firstWhere(
        (type) => type.name == extension.toLowerCase(),
        orElse: () => AudioFileType.mp3,
      );
}
