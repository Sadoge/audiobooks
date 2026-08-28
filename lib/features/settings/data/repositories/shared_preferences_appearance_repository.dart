import 'package:audiobooks/features/settings/domain/entities/app_theme_preference.dart';
import 'package:audiobooks/features/settings/domain/repositories/appearance_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: AppearanceRepository)
class SharedPreferencesAppearanceRepository implements AppearanceRepository {
  static const _themeKey = 'appearance.theme';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  @override
  Future<AppThemePreference> loadThemePreference() async {
    final value = await _preferences.getString(_themeKey);
    return AppThemePreference.values
            .where((item) => item.name == value)
            .firstOrNull ??
        AppThemePreference.system;
  }

  @override
  Future<void> saveThemePreference(AppThemePreference preference) =>
      _preferences.setString(_themeKey, preference.name);
}
