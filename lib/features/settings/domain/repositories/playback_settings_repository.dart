import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';

/// Where the player's defaults are kept between launches.
abstract interface class PlaybackSettingsRepository {
  Future<PlaybackSettings> loadPlaybackSettings();

  Future<void> savePlaybackSettings(PlaybackSettings settings);
}
