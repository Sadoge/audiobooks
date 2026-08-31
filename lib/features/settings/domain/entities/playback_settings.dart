import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_settings.freezed.dart';

/// How the player behaves before a listener touches anything.
///
/// These are the defaults a book opens with, not the state of a book being
/// listened to: changing the speed on the player itself still overrides
/// [speed] for that sitting.
@freezed
abstract class PlaybackSettings with _$PlaybackSettings {
  const factory PlaybackSettings({
    /// The speed every book opens at.
    @Default(1.0) double speed,

    /// What the rewind key on the wheel steps back by.
    @Default(Duration(seconds: 15)) Duration rewindInterval,

    /// What the forward key on the wheel steps on by.
    @Default(Duration(seconds: 30)) Duration forwardInterval,

    /// How far back a resumed book picks up from where it was left, which is
    /// how a listener catches the run-up to the sentence they stopped on.
    /// Zero resumes exactly where they were.
    @Default(Duration.zero) Duration resumeRewind,
  }) = _PlaybackSettings;
}

/// The values these settings can take.
///
/// The speeds are the same ones the player's own speed key offers, so a
/// default chosen here reads identically to one chosen while listening.
abstract final class PlaybackOptions {
  static const List<double> speeds = <double>[
    0.5,
    0.75,
    0.9,
    1,
    1.1,
    1.2,
    1.25,
    1.5,
    1.75,
    2,
    2.5,
    3,
  ];

  static const List<Duration> rewindIntervals = <Duration>[
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 15),
    Duration(seconds: 30),
    Duration(seconds: 60),
  ];

  static const List<Duration> forwardIntervals = <Duration>[
    Duration(seconds: 10),
    Duration(seconds: 15),
    Duration(seconds: 30),
    Duration(seconds: 45),
    Duration(seconds: 60),
  ];

  static const List<Duration> resumeRewinds = <Duration>[
    Duration.zero,
    Duration(seconds: 2),
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 30),
  ];

  /// How a speed is printed, on the player's key and in settings alike, so
  /// the two never disagree. Whole speeds drop their trailing zero.
  static String speedLabel(double speed) =>
      '${speed == speed.roundToDouble() ? speed.toStringAsFixed(0) : speed}x';
}
