import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/core/audio/audiobook_audio_handler.dart';
import 'package:audiobooks/core/audio/media_session_status.dart';
import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';
import 'package:audiobooks/features/settings/domain/repositories/playback_settings_repository.dart';
import 'package:flutter/foundation.dart';

/// Hands [handler] to the operating system, so that the book keeps playing
/// with the app in the background and appears on the lock screen, in the
/// notification shade, and on whatever else is listening — a headset, a car,
/// a watch.
///
/// A device that has no media session still plays: the app simply keeps its
/// transport to itself.
Future<void> startMediaSession(
  AudiobookAudioHandler handler,
  PlaybackSettingsRepository settings,
  MediaSessionStatus status,
) async {
  if (!_hasMediaSession) {
    status.record(MediaSessionOutcome.unsupported);
    if (kDebugMode) debugPrint('$_log unsupported on this platform');
    return;
  }

  // iOS labels its skip keys with the number of seconds they step by, so the
  // session is told the intervals the listener actually chose. They are fixed
  // for the session; the keys themselves always step by the current setting.
  final intervals = await _intervals(settings);

  try {
    await AudioService.init(
      builder: () => handler,
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.example.audiobooks.playback',
        androidNotificationChannelName: 'Playback',
        androidNotificationChannelDescription:
            'Controls for the audiobook you are listening to.',
        androidNotificationIcon: 'mipmap/ic_launcher',
        // An audiobook is a long sitting, so the notification stays put while
        // it plays and becomes dismissible once it is paused.
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        androidNotificationClickStartsActivity: true,
        // Covers are stored square and large; the notification and lock screen
        // want a thumbnail, not the whole thing.
        artDownscaleWidth: 512,
        artDownscaleHeight: 512,
        fastForwardInterval: intervals.forwardInterval,
        rewindInterval: intervals.rewindInterval,
      ),
    );
    status.record(MediaSessionOutcome.started);
    if (kDebugMode) debugPrint('$_log started');
  } catch (error, stackTrace) {
    // Losing the lock screen is worth reporting, but never worth refusing to
    // open the app over: the player itself still works. It is said out loud
    // because the symptom otherwise — a book that plays but appears nowhere —
    // looks exactly like the platform simply not being wired up.
    status.record(MediaSessionOutcome.failed, error: '$error');
    if (kDebugMode) debugPrint('$_log FAILED: $error');
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'audiobooks',
        context: ErrorDescription('starting the system media session'),
      ),
    );
  }
}

/// One recognisable tag, so that whether the session came up at all can be
/// read off the device log rather than guessed at from behaviour.
const String _log = '[audiobooks] media session:';

/// Where `audio_service` has a platform to talk to. Linux and Windows are
/// built by the Flutter tooling but are not targets of this app.
bool get _hasMediaSession =>
    Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

Future<PlaybackSettings> _intervals(PlaybackSettingsRepository settings) async {
  try {
    return await settings.loadPlaybackSettings();
  } catch (_) {
    return const PlaybackSettings();
  }
}
