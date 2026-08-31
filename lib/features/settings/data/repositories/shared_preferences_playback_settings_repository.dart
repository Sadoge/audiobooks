import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';
import 'package:audiobooks/features/settings/domain/repositories/playback_settings_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: PlaybackSettingsRepository)
class SharedPreferencesPlaybackSettingsRepository
    implements PlaybackSettingsRepository {
  static const _speedKey = 'playback.speed';
  static const _rewindKey = 'playback.rewindSeconds';
  static const _forwardKey = 'playback.forwardSeconds';
  static const _resumeRewindKey = 'playback.resumeRewindSeconds';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  @override
  Future<PlaybackSettings> loadPlaybackSettings() async {
    const fallback = PlaybackSettings();
    try {
      return PlaybackSettings(
        speed: _speed(await _preferences.getDouble(_speedKey)),
        rewindInterval: _interval(
          await _preferences.getInt(_rewindKey),
          PlaybackOptions.rewindIntervals,
          fallback.rewindInterval,
        ),
        forwardInterval: _interval(
          await _preferences.getInt(_forwardKey),
          PlaybackOptions.forwardIntervals,
          fallback.forwardInterval,
        ),
        resumeRewind: _interval(
          await _preferences.getInt(_resumeRewindKey),
          PlaybackOptions.resumeRewinds,
          fallback.resumeRewind,
        ),
      );
    } catch (_) {
      // Settings are a convenience; a store that cannot be read must never
      // stop the app from opening on its ordinary defaults.
      return fallback;
    }
  }

  @override
  Future<void> savePlaybackSettings(PlaybackSettings settings) async {
    await _preferences.setDouble(_speedKey, settings.speed);
    await _preferences.setInt(_rewindKey, settings.rewindInterval.inSeconds);
    await _preferences.setInt(_forwardKey, settings.forwardInterval.inSeconds);
    await _preferences.setInt(
      _resumeRewindKey,
      settings.resumeRewind.inSeconds,
    );
  }

  /// Only speeds the player itself offers are honoured, so a stored value
  /// from an older build can never leave a book playing at a rate that has no
  /// entry on the menu.
  double _speed(double? stored) =>
      stored != null && PlaybackOptions.speeds.contains(stored)
      ? stored
      : const PlaybackSettings().speed;

  Duration _interval(int? seconds, List<Duration> allowed, Duration fallback) {
    if (seconds == null) return fallback;
    final stored = Duration(seconds: seconds);
    return allowed.contains(stored) ? stored : fallback;
  }
}
