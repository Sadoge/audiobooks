import 'package:audiobooks/app/theme/app_tokens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color _seed = Color(0xFF515B83);

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final base = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );
    final scheme = base.copyWith(
      primary: isLight ? const Color(0xFF6E530F) : const Color(0xFFE9C46A),
      onPrimary: isLight ? Colors.white : const Color(0xFF352A00),
      secondary: isLight ? const Color(0xFF4B557B) : const Color(0xFFBCC6F4),
      surface: isLight ? const Color(0xFFF8F9FC) : const Color(0xFF111823),
      onSurface: isLight ? const Color(0xFF101828) : const Color(0xFFF1F3F8),
      surfaceContainerLow: isLight
          ? const Color(0xFFF1F3F8)
          : const Color(0xFF171F2C),
      surfaceContainerHighest: isLight
          ? const Color(0xFFDDE1EA)
          : const Color(0xFF303A49),
      outlineVariant: isLight
          ? const Color(0xFFD7DAE2)
          : const Color(0xFF3B4554),
    );

    final textTheme = ThemeData(useMaterial3: true, brightness: brightness)
        .textTheme
        .copyWith(
          displaySmall: TextStyle(
            color: scheme.onSurface,
            fontSize: 36,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
          ),
          headlineMedium: TextStyle(
            color: scheme.onSurface,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
          titleLarge: TextStyle(
            color: scheme.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 17,
            height: 1.45,
          ),
          bodyMedium: TextStyle(
            color: scheme.onSurfaceVariant,
            fontSize: 15,
            height: 1.4,
          ),
          labelLarge: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: defaultTargetPlatform == TargetPlatform.iOS,
        titleTextStyle: textTheme.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 54),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.control),
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size.square(48)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
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
