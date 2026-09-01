import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';
import 'package:audiobooks/features/settings/domain/repositories/playback_settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PlaybackSettingsCubit extends Cubit<PlaybackSettings> {
  PlaybackSettingsCubit(this._repository) : super(const PlaybackSettings());

  final PlaybackSettingsRepository _repository;

  Future<void> load() async {
    emit(await _repository.loadPlaybackSettings());
  }

  Future<void> setSpeed(double speed) => _update(state.copyWith(speed: speed));

  Future<void> setRewindInterval(Duration interval) =>
      _update(state.copyWith(rewindInterval: interval));

  Future<void> setForwardInterval(Duration interval) =>
      _update(state.copyWith(forwardInterval: interval));

  Future<void> setResumeRewind(Duration interval) =>
      _update(state.copyWith(resumeRewind: interval));

  /// A choice is shown as taken straight away and written behind it, so a
  /// settings row never waits on the disk to answer.
  Future<void> _update(PlaybackSettings settings) async {
    if (settings == state) return;
    emit(settings);
    await _repository.savePlaybackSettings(settings);
  }
}
