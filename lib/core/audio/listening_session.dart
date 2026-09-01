import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:injectable/injectable.dart';

/// Something that took the audio away, or gave it back.
///
/// The platform reports these in its own vocabulary — an audio focus change on
/// Android, an `AVAudioSession` interruption on iOS, a headphone jack or a
/// Bluetooth link going away. What the player needs to know is only ever one of
/// three things, so that is all that crosses this boundary.
enum ListeningInterruption {
  /// Something else needs the audio: a call, a navigation prompt, another
  /// player. Playback should give way.
  ///
  /// Ducking arrives here too. A narrator turned down under another sound is
  /// not worth listening to, so spoken audio steps aside instead.
  paused,

  /// The interruption is over and the audio is ours again. Playback should
  /// pick up, but only if it was this that stopped it.
  resumed,

  /// The output went away — a jack pulled, a Bluetooth device out of range.
  ///
  /// This never resumes: audio would otherwise burst out of the phone's own
  /// speaker to a room that did not ask for it.
  ended,
}

/// The device's audio session, and the things that happen to it.
///
/// Kept apart from the audio engine because the engine's job is to make sound
/// and this one's is to know when the rest of the device will allow it.
abstract interface class ListeningSession {
  /// Declares the app as a spoken-word player. Safe to call more than once.
  Future<void> configure();

  /// Interruptions, in the order the device reports them.
  Stream<ListeningInterruption> get interruptions;
}

@LazySingleton(as: ListeningSession)
class DeviceListeningSession implements ListeningSession {
  Future<AudioSession?>? _session;
  Stream<ListeningInterruption>? _interruptions;

  @override
  Future<void> configure() async {
    // A session that cannot be configured is never a reason to refuse to open
    // a book: the audio still comes out, it just plays by the platform's own
    // defaults and without the interruption handling below.
    final session = await _configured();
    if (session == null) return;
    try {
      await session.setActive(true);
    } catch (_) {
      // Already ours, or a platform with nothing to activate.
    }
  }

  Future<AudioSession?> _configured() => _session ??= _configure();

  Future<AudioSession?> _configure() async {
    try {
      final session = await AudioSession.instance;
      // Spoken audio: the platform routes it as speech, keeps it out of the
      // ringer's volume, and pauses rather than ducks it under other sound.
      await session.configure(const AudioSessionConfiguration.speech());
      return session;
    } catch (_) {
      // Dropped rather than remembered, so a platform that was merely slow to
      // come up is asked again the next time a book opens.
      _session = null;
      return null;
    }
  }

  @override
  Stream<ListeningInterruption> get interruptions =>
      _interruptions ??= _openInterruptions();

  /// The platform reports losing the audio and losing the output on two
  /// separate streams. They are the same event to a listener, so they arrive
  /// here as one.
  Stream<ListeningInterruption> _openInterruptions() {
    late final StreamController<ListeningInterruption> events;
    final sources = <StreamSubscription<Object?>>[];

    events = StreamController<ListeningInterruption>.broadcast(
      onListen: () async {
        final session = await _configured();
        if (session == null || !events.hasListener) return;
        sources.addAll([
          session.interruptionEventStream.listen((event) {
            final interruption = _readInterruption(event);
            if (interruption != null) events.add(interruption);
          }),
          session.becomingNoisyEventStream.listen(
            (_) => events.add(ListeningInterruption.ended),
          ),
        ]);
      },
      onCancel: () async {
        for (final source in sources) {
          await source.cancel();
        }
        sources.clear();
      },
    );

    return events.stream;
  }

  /// Null where the device has reported something the player has no answer to.
  ListeningInterruption? _readInterruption(AudioInterruptionEvent event) {
    if (event.begin) return ListeningInterruption.paused;
    // An interruption the platform could not name is not evidence that the
    // audio is ours again, so the book stays where the listener will find it
    // rather than starting up unasked in their pocket.
    return event.type == AudioInterruptionType.unknown
        ? null
        : ListeningInterruption.resumed;
  }
}
