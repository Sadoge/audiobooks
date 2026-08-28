import 'package:audiobooks/features/settings/domain/entities/app_theme_preference.dart';

abstract interface class AppearanceRepository {
  Future<AppThemePreference> loadThemePreference();

  Future<void> saveThemePreference(AppThemePreference preference);
}
