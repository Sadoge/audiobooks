import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Corners are tight, the way moulded plastic and stamped metal are tight.
abstract final class AppRadii {
  static const double controlUnit = 6;
  static const double coverUnit = 3;
  static const double screenUnit = 5;

  static const BorderRadius control = BorderRadius.all(
    Radius.circular(controlUnit),
  );
  static const BorderRadius cover = BorderRadius.all(
    Radius.circular(coverUnit),
  );
  static const BorderRadius screen = BorderRadius.all(
    Radius.circular(screenUnit),
  );
}

/// Bevels are drawn, not blurred: a hairline edge and a hairline highlight.
abstract final class AppStroke {
  static const double hairline = 1;
  static const double bezel = 3;
}

abstract final class AppMotion {
  static const Duration quick = Duration(milliseconds: 160);
  static const Duration standard = Duration(milliseconds: 280);
  static const Curve emphasized = Curves.easeOutCubic;
}

abstract final class AppIconSize {
  static const double small = 20;
  static const double regular = 24;
  static const double large = 32;
}

/// The two faces the product is set in.
///
/// Both are bundled rather than borrowed from the platform, because the
/// period is carried as much by the lettering as by the housing.
abstract final class AppFonts {
  /// Moulded product lettering: a squarish grotesque for everything read.
  static const String display = 'SpaceGrotesk';

  /// The readout face. Counters, run times, and file sizes are digits on a
  /// display, so they are set in a monospace and never reflow as they tick.
  static const String mono = 'SpaceMono';

  static const List<String> monoFallback = <String>[
    'Menlo',
    'SF Mono',
    'Consolas',
    'Roboto Mono',
    'DejaVu Sans Mono',
    'Courier New',
  ];

  static TextStyle readout(TextStyle? base) =>
      (base ?? const TextStyle()).copyWith(
        fontFamily: mono,
        fontFamilyFallback: monoFallback,
        letterSpacing: 0,
      );
}
