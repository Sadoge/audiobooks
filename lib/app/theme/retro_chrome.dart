import 'package:flutter/material.dart';

/// The physical qualities of an early-2000s pocket player, kept in one place.
///
/// Everything the interface borrows from a real device — brushed chrome, a
/// recessed readout, the moulded wheel, and the blue bar that ran down its
/// menus — is a token here rather than a light/dark check inside a widget.
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
  });

  /// Brushed housing: app bars, bezels, and pressable keys.
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

  /// The blue bar that marks the row you are on.
  final LinearGradient selection;

  static RetroChrome of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<RetroChrome>() ?? forBrightness(theme.brightness);
  }

  static RetroChrome forBrightness(Brightness brightness) =>
      brightness == Brightness.light ? light : dark;

  /// Silver housing, white screen.
  static const RetroChrome light = RetroChrome(
    chrome: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFCFCFD), Color(0xFFE4E7ED), Color(0xFFD1D5DE)],
      stops: [0, 0.55, 1],
    ),
    chromeEdge: Color(0xFFA6ABB5),
    chromeHighlight: Color(0xFFFFFFFF),
    wheel: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF3F5F8), Color(0xFFDDE1E8), Color(0xFFC9CFD9)],
      stops: [0, 0.55, 1],
    ),
    wheelEdge: Color(0xFFAFB5C0),
    wheelWell: Color(0xFFC4CAD5),
    keyFace: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFFFF), Color(0xFFE6EAEF)],
    ),
    screenFill: Color(0xFFDFE4EC),
    screenEdge: Color(0xFFAEB5C1),
    screenInk: Color(0xFF1E2530),
    screenInkDim: Color(0xFF5C6673),
    selection: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF6E93E4), Color(0xFF3A66CE), Color(0xFF2B51B4)],
      stops: [0, 0.55, 1],
    ),
  );

  /// Graphite housing, backlit screen.
  static const RetroChrome dark = RetroChrome(
    chrome: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF434952), Color(0xFF2A2E36), Color(0xFF1B1E24)],
      stops: [0, 0.55, 1],
    ),
    chromeEdge: Color(0xFF0D0F12),
    chromeHighlight: Color(0xFF6C727E),
    wheel: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3D424C), Color(0xFF2B2F37), Color(0xFF21252B)],
      stops: [0, 0.55, 1],
    ),
    wheelEdge: Color(0xFF14171C),
    wheelWell: Color(0xFF1E2229),
    keyFace: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF3F444E), Color(0xFF2A2E36)],
    ),
    screenFill: Color(0xFF0D131C),
    screenEdge: Color(0xFF333A45),
    screenInk: Color(0xFFA9C6FF),
    screenInkDim: Color(0xFF6B7F9E),
    selection: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF5C86E8), Color(0xFF2E56BE), Color(0xFF23459C)],
      stops: [0, 0.55, 1],
    ),
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
    );
  }
}
