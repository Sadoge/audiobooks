import 'package:audiobooks/features/settings/domain/entities/app_theme_preference.dart';
import 'package:audiobooks/features/settings/domain/repositories/appearance_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ThemeCubit extends Cubit<AppThemePreference> {
  ThemeCubit(this._repository) : super(AppThemePreference.system);

  final AppearanceRepository _repository;

  Future<void> load() async {
    emit(await _repository.loadThemePreference());
  }

  Future<void> setPreference(AppThemePreference preference) async {
    if (state == preference) return;
    emit(preference);
    await _repository.saveThemePreference(preference);
  }
}

extension AppThemePreferenceX on AppThemePreference {
  ThemeMode get themeMode => switch (this) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };
}
