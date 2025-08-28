import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppStatus { initial, loading, loaded }

class AppState {
  final ThemeMode themeMode;
  final AppStatus status;

  const AppState({required this.themeMode, required this.status});

  AppState copyWith({ThemeMode? themeMode, AppStatus? status}) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      status: status ?? this.status,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  static const _themePrefKey = 'theme_mode';

  AppNotifier()
    : super(
        const AppState(themeMode: ThemeMode.light, status: AppStatus.initial),
      ) {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themePrefKey);

    if (savedTheme != null) {
      if (savedTheme == 'dark') {
        state = state.copyWith(
          themeMode: ThemeMode.dark,
          status: AppStatus.loaded,
        );
      } else {
        state = state.copyWith(
          themeMode: ThemeMode.light,
          status: AppStatus.loaded,
        );
      }
    } else {
      // Default theme if nothing saved
      state = state.copyWith(
        themeMode: ThemeMode.light,
        status: AppStatus.loaded,
      );
    }
  }

  Future<void> _saveThemeToPrefs(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themePrefKey,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  void setTheme(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _saveThemeToPrefs(mode);
  }

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    state = state.copyWith(themeMode: newMode);
    _saveThemeToPrefs(newMode);
  }

  void setStatus(AppStatus status) {
    state = state.copyWith(status: status);
  }
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>(
  (ref) => AppNotifier(),
);
