import 'package:audiobooks/core/files/picked_audio_file.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_state.freezed.dart';

enum ImportStatus { initial, choosing, selected, importing, completed, failure }

@freezed
abstract class ImportState with _$ImportState {
  const factory ImportState({
    @Default(ImportStatus.initial) ImportStatus status,
    @Default(<PickedAudioFile>[]) List<PickedAudioFile> files,
    String? errorMessage,
  }) = _ImportState;
}
