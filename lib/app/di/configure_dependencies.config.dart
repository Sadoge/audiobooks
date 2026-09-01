// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/audio/audio_playback_service.dart' as _i815;
import '../../core/audio/audiobook_audio_handler.dart' as _i119;
import '../../core/audio/just_audio_playback_service.dart' as _i954;
import '../../core/audio/listening_session.dart' as _i343;
import '../../core/audio/media_session_status.dart' as _i86;
import '../../core/audio/metadata/audio_metadata_service.dart' as _i491;
import '../../core/audio/metadata/local_audio_metadata_service.dart' as _i798;
import '../../core/audio/playback_notification_permission.dart' as _i749;
import '../../core/database/app_database.dart' as _i50;
import '../../core/files/device_file_gateway.dart' as _i306;
import '../../core/files/local_device_file_gateway.dart' as _i804;
import '../../features/import/presentation/cubit/import_cubit.dart' as _i750;
import '../../features/library/data/repositories/local_audiobook_repository.dart'
    as _i409;
import '../../features/library/domain/repositories/audiobook_repository.dart'
    as _i1069;
import '../../features/library/presentation/cubit/library_cubit.dart' as _i196;
import '../../features/player/data/repositories/local_player_repository.dart'
    as _i411;
import '../../features/player/domain/repositories/player_repository.dart'
    as _i1009;
import '../../features/player/presentation/cubit/now_playing_cubit.dart'
    as _i673;
import '../../features/player/presentation/cubit/player_cubit.dart' as _i387;
import '../../features/settings/data/repositories/shared_preferences_appearance_repository.dart'
    as _i1004;
import '../../features/settings/data/repositories/shared_preferences_playback_settings_repository.dart'
    as _i435;
import '../../features/settings/domain/repositories/appearance_repository.dart'
    as _i475;
import '../../features/settings/domain/repositories/playback_settings_repository.dart'
    as _i579;
import '../../features/settings/presentation/cubit/lock_screen_cubit.dart'
    as _i1058;
import '../../features/settings/presentation/cubit/playback_settings_cubit.dart'
    as _i333;
import '../../features/settings/presentation/cubit/storage_summary_cubit.dart'
    as _i809;
import '../../features/settings/presentation/cubit/theme_cubit.dart' as _i124;
import '../router/app_router.dart' as _i81;
import 'audio_module.dart' as _i83;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final audioModule = _$AudioModule();
    gh.lazySingleton<_i81.AppRouter>(() => _i81.AppRouter());
    gh.lazySingleton<_i86.MediaSessionStatus>(() => _i86.MediaSessionStatus());
    gh.lazySingleton<_i50.AppDatabase>(() => _i50.AppDatabase());
    gh.lazySingleton<_i475.AppearanceRepository>(
      () => _i1004.SharedPreferencesAppearanceRepository(),
    );
    gh.lazySingleton<_i343.ListeningSession>(
      () => _i343.DeviceListeningSession(),
    );
    gh.factory<_i124.ThemeCubit>(
      () => _i124.ThemeCubit(gh<_i475.AppearanceRepository>()),
    );
    gh.lazySingleton<_i749.PlaybackNotificationPermission>(
      () => _i749.DevicePlaybackNotificationPermission(),
    );
    gh.lazySingleton<_i491.AudioMetadataService>(
      () => const _i798.LocalAudioMetadataService(),
    );
    gh.lazySingleton<_i579.PlaybackSettingsRepository>(
      () => _i435.SharedPreferencesPlaybackSettingsRepository(),
    );
    gh.lazySingleton<_i815.AudioPlaybackService>(
      () => _i954.JustAudioPlaybackService(),
      instanceName: 'audioEngine',
    );
    gh.lazySingleton<_i119.AudiobookAudioHandler>(
      () => _i119.AudiobookAudioHandler(
        gh<_i815.AudioPlaybackService>(instanceName: 'audioEngine'),
        gh<_i579.PlaybackSettingsRepository>(),
        gh<_i343.ListeningSession>(),
        gh<_i749.PlaybackNotificationPermission>(),
      ),
    );
    gh.lazySingleton<_i306.DeviceFileGateway>(
      () => _i804.LocalDeviceFileGateway(),
    );
    gh.lazySingleton<_i1069.AudiobookRepository>(
      () => _i409.LocalAudiobookRepository(gh<_i50.AppDatabase>()),
    );
    gh.factory<_i196.LibraryCubit>(
      () => _i196.LibraryCubit(
        gh<_i1069.AudiobookRepository>(),
        gh<_i306.DeviceFileGateway>(),
        gh<_i491.AudioMetadataService>(),
      ),
    );
    gh.factory<_i1058.LockScreenCubit>(
      () => _i1058.LockScreenCubit(
        gh<_i86.MediaSessionStatus>(),
        gh<_i749.PlaybackNotificationPermission>(),
      ),
    );
    gh.factory<_i809.StorageSummaryCubit>(
      () => _i809.StorageSummaryCubit(
        gh<_i1069.AudiobookRepository>(),
        gh<_i306.DeviceFileGateway>(),
      ),
    );
    gh.factory<_i750.ImportCubit>(
      () => _i750.ImportCubit(
        gh<_i306.DeviceFileGateway>(),
        gh<_i1069.AudiobookRepository>(),
        gh<_i491.AudioMetadataService>(),
      ),
    );
    gh.factory<_i333.PlaybackSettingsCubit>(
      () => _i333.PlaybackSettingsCubit(gh<_i579.PlaybackSettingsRepository>()),
    );
    gh.lazySingleton<_i815.AudioPlaybackService>(
      () => audioModule.playback(gh<_i119.AudiobookAudioHandler>()),
    );
    gh.lazySingleton<_i1009.PlayerRepository>(
      () => _i411.LocalPlayerRepository(
        gh<_i815.AudioPlaybackService>(),
        gh<_i1069.AudiobookRepository>(),
        gh<_i579.PlaybackSettingsRepository>(),
      ),
    );
    gh.factory<_i387.PlayerCubit>(
      () => _i387.PlayerCubit(
        gh<_i1009.PlayerRepository>(),
        gh<_i1069.AudiobookRepository>(),
        gh<_i579.PlaybackSettingsRepository>(),
      ),
    );
    gh.lazySingleton<_i673.NowPlayingCubit>(
      () => _i673.NowPlayingCubit(
        gh<_i1009.PlayerRepository>(),
        gh<_i1069.AudiobookRepository>(),
      ),
    );
    return this;
  }
}

class _$AudioModule extends _i83.AudioModule {}
