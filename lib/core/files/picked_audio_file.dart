import 'package:freezed_annotation/freezed_annotation.dart';

part 'picked_audio_file.freezed.dart';

@freezed
abstract class PickedAudioFile with _$PickedAudioFile {
  const factory PickedAudioFile({
    required String name,
    required int sizeBytes,
    required String extension,
    String? path,
    String? persistentUri,
  }) = _PickedAudioFile;
}
