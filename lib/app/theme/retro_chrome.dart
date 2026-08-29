import 'package:flutter/material.dart';

/// The physical qualities of an early-2000s pocket player, kept in one place.
///
/// Everything the interface borrows from a real device — warm moulded plastic,
/// a recessed amber-backlit display, the wheel, and the bar that marks the row
/// you are on — is a token here rather than a light/dark check inside a widget.
@immutable
class RetroChrome extends ThemeExtension<RetroChrome> {
  const RetroChrome({
    required this.chrome,
    required this.chromeEdge,
    required this.chromeHighlight,
    required this.wheel,
    required this.wheelEdge,
    required this.wheelWell,
    required this.keyFace,
    required this.screenFill,
    required this.screenEdge,
    required this.screenInk,
    required this.screenInkDim,
    required this.selection,
    required this.selectionInk,
  });

  /// Moulded housing: app bars, bezels, and pressable keys.
  final LinearGradient chrome;

  /// The dark hairline where a moulded edge turns away from the light.
  final Color chromeEdge;

  /// The lit hairline along the top of the same edge.
  final Color chromeHighlight;

  /// The wheel face, lit from its upper left.
  final LinearGradient wheel;
  final Color wheelEdge;

  /// The recess the centre key sits down inside.
  final Color wheelWell;

  /// A small pressable key, lighter at the top than the bottom.
  final LinearGradient keyFace;

  /// The recessed readout: its glass, its rim, and the two levels of digit.
  final Color screenFill;
  final Color screenEdge;
  final Color screenInk;
  final Color screenInkDim;

  /// The bar that marks the row you are on, and the ink that reads on it.
  ///
  /// The ink is a token because the bar is light enough in dark appearance
  /// that white would not carry: it takes the dark warm ink instead.
  final LinearGradient selection;
  final Color selectionInk;

  static RetroChrome of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<RetroChrome>() ?? forBrightness(theme.brightness);
  }

  static RetroChrome forBrightness(Brightness brightness) =>
      brightness == Brightness.light ? light : dark;

  /// Warm cream plastic, bone-white screen.
  static const RetroChrome light = RetroChrome(
    chrome: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF8F3E6), Color(0xFFEAE1CB), Color(0xFFD6CBAF)],
      stops: [0, 0.55, 1],
    ),
    chromeEdge: Color(0xFFAD9F82),
    chromeHighlight: Color(0xFFFFFFFF),
    wheel: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF4EDDD), Color(0xFFE3DAC2), Color(0xFFCFC4A8)],
      stops: [0, 0.55, 1],
    ),
    wheelEdge: Color(0xFFB4A88C),
    wheelWell: Color(0xFFC9BEA2),
    keyFace: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFDF8), Color(0xFFF0EADB)],
    ),
    screenFill: Color(0xFFDCD4BD),
    screenEdge: Color(0xFFB5A98D),
    screenInk: Color(0xFF2B2415),
    screenInkDim: Color(0xFF6E6249),
    selection: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFD08A2A), Color(0xFFA8580A), Color(0xFF8C4707)],
      stops: [0, 0.55, 1],
    ),
    selectionInk: Color(0xFFFFFFFF),
  );

  /// Warm graphite housing, amber backlight.
  static const RetroChrome dark = RetroChrome(
    chrome: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF4A4232), Color(0xFF2C2720), Color(0xFF1A1712)],
      stops: [0, 0.55, 1],
    ),
    chromeEdge: Color(0xFF0E0C08),
    chromeHighlight: Color(0xFF837860),
    wheel: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF443D2D), Color(0xFF302A20), Color(0xFF241F18)],
      stops: [0, 0.55, 1],
    ),
    wheelEdge: Color(0xFF14110C),
    wheelWell: Color(0xFF211D16),
    keyFace: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF463F2F), Color(0xFF2E2920)],
    ),
    screenFill: Color(0xFF120F08),
    screenEdge: Color(0xFF3D3527),
    screenInk: Color(0xFFFFBE55),
    screenInkDim: Color(0xFF9C8552),
    selection: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF0BC61), Color(0xFFC6801C), Color(0xFFA2650F)],
      stops: [0, 0.55, 1],
    ),
    selectionInk: Color(0xFF2A1A00),
  );

  @override
  RetroChrome copyWith({
    LinearGradient? chrome,
    Color? chromeEdge,
    Color? chromeHighlight,
    LinearGradient? wheel,
    Color? wheelEdge,
    Color? wheelWell,
    LinearGradient? keyFace,
    Color? screenFill,
    Color? screenEdge,
    Color? screenInk,
    Color? screenInkDim,
    LinearGradient? selection,
    Color? selectionInk,
  }) {
    return RetroChrome(
      chrome: chrome ?? this.chrome,
      chromeEdge: chromeEdge ?? this.chromeEdge,
      chromeHighlight: chromeHighlight ?? this.chromeHighlight,
      wheel: wheel ?? this.wheel,
      wheelEdge: wheelEdge ?? this.wheelEdge,
      wheelWell: wheelWell ?? this.wheelWell,
      keyFace: keyFace ?? this.keyFace,
      screenFill: screenFill ?? this.screenFill,
      screenEdge: screenEdge ?? this.screenEdge,
      screenInk: screenInk ?? this.screenInk,
      screenInkDim: screenInkDim ?? this.screenInkDim,
      selection: selection ?? this.selection,
      selectionInk: selectionInk ?? this.selectionInk,
    );
  }

  @override
  RetroChrome lerp(covariant RetroChrome? other, double t) {
    if (other == null) return this;
    return RetroChrome(
      chrome: LinearGradient.lerp(chrome, other.chrome, t)!,
      chromeEdge: Color.lerp(chromeEdge, other.chromeEdge, t)!,
      chromeHighlight: Color.lerp(chromeHighlight, other.chromeHighlight, t)!,
      wheel: LinearGradient.lerp(wheel, other.wheel, t)!,
      wheelEdge: Color.lerp(wheelEdge, other.wheelEdge, t)!,
      wheelWell: Color.lerp(wheelWell, other.wheelWell, t)!,
      keyFace: LinearGradient.lerp(keyFace, other.keyFace, t)!,
      screenFill: Color.lerp(screenFill, other.screenFill, t)!,
      screenEdge: Color.lerp(screenEdge, other.screenEdge, t)!,
      screenInk: Color.lerp(screenInk, other.screenInk, t)!,
      screenInkDim: Color.lerp(screenInkDim, other.screenInkDim, t)!,
      selection: LinearGradient.lerp(selection, other.selection, t)!,
      selectionInk: Color.lerp(selectionInk, other.selectionInk, t)!,
    );
  }
}
