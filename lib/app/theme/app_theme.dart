import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:audiobooks/app/theme/retro_chrome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color _seed = Color(0xFFB4680F);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final chrome = RetroChrome.forBrightness(brightness);
    final base = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    final scheme = base.copyWith(
      primary: isLight ? const Color(0xFFA8580A) : const Color(0xFFF0A93B),
      onPrimary: isLight ? Colors.white : const Color(0xFF2A1A00),
      secondary: isLight ? const Color(0xFF7A6A52) : const Color(0xFFC0B39C),
      secondaryContainer: isLight
          ? const Color(0xFFE4DCC7)
          : const Color(0xFF2C261C),
      onSecondaryContainer: isLight
          ? const Color(0xFF3A3226)
          : const Color(0xFFE6DECD),
      surface: isLight ? const Color(0xFFFCFAF4) : const Color(0xFF17140F),
      onSurface: isLight ? const Color(0xFF211E17) : const Color(0xFFF3EEE1),
      onSurfaceVariant: isLight
          ? const Color(0xFF63594A)
          : const Color(0xFFB0A695),
      surfaceContainerLow: isLight
          ? const Color(0xFFF4F0E5)
          : const Color(0xFF1E1A14),
      surfaceContainerHighest: isLight
          ? const Color(0xFFDDD4BF)
          : const Color(0xFF332D23),
      outlineVariant: isLight
          ? const Color(0xFFD0C6AF)
          : const Color(0xFF423B2E),
    );

    // The groove a bar of progress is sunk into, in either appearance.
    final groove = isLight ? const Color(0xFFCDC3AC) : const Color(0xFF322C22);

    final textTheme = ThemeData(useMaterial3: true, brightness: brightness)
        .textTheme
        .copyWith(
          displaySmall: TextStyle(
            color: scheme.onSurface,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
          headlineMedium: TextStyle(
            color: scheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
          titleLarge: TextStyle(
            color: scheme.onSurface,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
          titleMedium: TextStyle(
            color: scheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
          bodyLarge: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 16,
            height: 1.4,
          ),
          bodyMedium: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 14,
            height: 1.35,
          ),
          labelLarge: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          labelMedium: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        )
        .apply(fontFamily: AppFonts.display);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppFonts.display,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[chrome],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        // A device menu titles itself in the middle of its own housing.
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 50),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.control),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 50),
          side: BorderSide(color: scheme.outlineVariant),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.control),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.control),
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size.square(48)),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: scheme.surfaceContainerLow,
          foregroundColor: scheme.onSurface,
          selectedBackgroundColor: scheme.primary,
          selectedForegroundColor: scheme.onPrimary,
          side: BorderSide(color: chrome.chromeEdge),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.control),
          textStyle: textTheme.labelLarge,
        ),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 8,
        activeTrackColor: scheme.primary,
        inactiveTrackColor: groove,
        secondaryActiveTrackColor: scheme.primary.withValues(alpha: 0.3),
        thumbColor: isLight ? const Color(0xFF7E410A) : const Color(0xFFFFD08F),
        overlayColor: scheme.primary.withValues(alpha: 0.12),
        // The classic round knob on a rounded groove, rather than the
        // current gapped Material track.
        trackShape: const RoundedRectSliderTrackShape(),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: groove,
        linearMinHeight: 4,
        circularTrackColor: groove,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        // Menu rows were set heavier than running text, and squared off.
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodyMedium,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: isLight ? const Color(0xFFF6F1E6) : const Color(0xFF221E17),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.control,
          side: BorderSide(color: chrome.chromeEdge),
        ),
        textStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurface),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.screenUnit),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.control),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: AppStroke.hairline,
        space: AppStroke.hairline,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
