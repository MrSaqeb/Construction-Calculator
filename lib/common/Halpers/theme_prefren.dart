import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const _keyIsDark = 'isDarkTheme';

  // Save theme mode (true for dark, false for light)
  Future<void> setDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDark, value);
  }

  // Load saved theme mode, default to false (light mode)
  Future<bool> getDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsDark) ?? false;
  }
}
