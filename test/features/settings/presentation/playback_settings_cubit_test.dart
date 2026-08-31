import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';
import 'package:audiobooks/features/settings/domain/repositories/playback_settings_repository.dart';
import 'package:audiobooks/features/settings/presentation/cubit/playback_settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakePlaybackSettingsRepository repository;
  late PlaybackSettingsCubit cubit;

  setUp(() {
    repository = _FakePlaybackSettingsRepository();
    cubit = PlaybackSettingsCubit(repository);
    addTearDown(cubit.close);
  });

  test('starts on the ordinary defaults', () {
    expect(cubit.state.speed, 1.0);
    expect(cubit.state.rewindInterval, const Duration(seconds: 15));
    expect(cubit.state.forwardInterval, const Duration(seconds: 30));
    expect(cubit.state.resumeRewind, Duration.zero);
  });

  test('loads what was stored', () async {
    repository.stored = const PlaybackSettings(
      speed: 1.25,
      rewindInterval: Duration(seconds: 30),
    );

    await cubit.load();

    expect(cubit.state.speed, 1.25);
    expect(cubit.state.rewindInterval, const Duration(seconds: 30));
  });

  test('shows a choice as taken and writes it behind', () async {
    await cubit.setSpeed(1.5);
    await cubit.setForwardInterval(const Duration(seconds: 45));
    await cubit.setResumeRewind(const Duration(seconds: 5));

    expect(cubit.state.speed, 1.5);
    expect(repository.stored.speed, 1.5);
    expect(repository.stored.forwardInterval, const Duration(seconds: 45));
    expect(repository.stored.resumeRewind, const Duration(seconds: 5));
  });

  test('choosing what is already chosen writes nothing', () async {
    await cubit.setSpeed(cubit.state.speed);

    expect(repository.writes, 0);
  });
}

class _FakePlaybackSettingsRepository implements PlaybackSettingsRepository {
  PlaybackSettings stored = const PlaybackSettings();
  int writes = 0;

  @override
  Future<PlaybackSettings> loadPlaybackSettings() async => stored;

  @override
  Future<void> savePlaybackSettings(PlaybackSettings settings) async {
    writes++;
    stored = settings;
  }
}
