import 'package:audiobooks/core/audio/audio_playback_service.dart';
import 'package:audiobooks/core/audio/audiobook_audio_handler.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AudioModule {
  /// The app plays books through the same object that drives the lock screen,
  /// so that a command from the notification and a command from the wheel take
  /// exactly the same path down to the engine.
  ///
  /// It is registered under both names because startup needs the handler
  /// itself to hand to the operating system, while everything after startup
  /// only wants a way to play a book.
  @lazySingleton
  AudioPlaybackService playback(AudiobookAudioHandler handler) => handler;
}
