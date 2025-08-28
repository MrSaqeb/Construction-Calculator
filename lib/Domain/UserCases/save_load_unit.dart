import 'package:shared_preferences/shared_preferences.dart';

class UnitStorageService {
  static const _unitKey = "selected_unit";

  /// Save selected unit
  Future<void> saveUnit(String unit) async {
    if (unit.trim().isEmpty) {
      throw ArgumentError("Unit cannot be empty");
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_unitKey, unit);
  }

  /// Load selected unit
  Future<String?> loadUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_unitKey);
  }
}
