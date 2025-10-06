import 'package:construction_calculator/Domain/entities/bubble_settong_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const _keyShowNumericAngle = "showNumericAngle";
  static const _keyDisplayType = "displayType";
  static const _keyOrientationLock = "orientationLock";
  static const _keyViscosity = "viscosity";
  static const _keySoundEffect = "soundEffect";

  Future<void> save(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowNumericAngle, settings.showNumericAngle);
    await prefs.setString(_keyDisplayType, settings.displayType);
    await prefs.setBool(_keyOrientationLock, settings.allowOrientationLock);
    await prefs.setString(_keyViscosity, settings.viscosity);
    await prefs.setBool(_keySoundEffect, settings.soundEffect);
  }

  Future<SettingsModel> load() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsModel(
      showNumericAngle: prefs.getBool(_keyShowNumericAngle) ?? true,
      displayType: prefs.getString(_keyDisplayType) ?? "Angle",
      allowOrientationLock: prefs.getBool(_keyOrientationLock) ?? false,
      viscosity: prefs.getString(_keyViscosity) ?? "Low",
      soundEffect: prefs.getBool(_keySoundEffect) ?? true,
    );
  }
}
