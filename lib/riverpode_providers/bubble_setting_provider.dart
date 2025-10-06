// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:construction_calculator/Domain/UserCases/angle_calculator.dart';
import 'package:construction_calculator/Domain/repositories/bubble_setting_repo.dart';
import 'package:construction_calculator/Domain/entities/bubble_settong_model.dart';
import 'package:construction_calculator/common/Halpers/sound_helper.dart';
import 'package:construction_calculator/features/Bubble_Level/Application/bubbel_level_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BubbleNotifier extends StateNotifier<BubbleState> {
  final SettingsRepository _repo;
  StreamSubscription? _sub;

  // Calibration offsets
  double _offsetX = 0;
  double _offsetY = 0;

  BubbleNotifier(this._repo) : super(BubbleState.initial()) {
    _listenToSensor();
    _loadSettings();
  }

  // Accelerometer se pitch/roll update
  void _listenToSensor() {
    _sub = accelerometerEvents.listen((event) {
      final rawBubble = AngleCalculator.fromAccelerometer(
        event.x,
        event.y,
        event.z,
      );

      // Apply calibration offsets
      final calibratedBubble = rawBubble.copyWith(
        roll: rawBubble.roll - _offsetX,
        pitch: rawBubble.pitch - _offsetY,
      );

      state = state.copyWith(bubble: calibratedBubble);

      // Agar level ho aur soundEffect setting ON ho to beep
      if (state.settings.soundEffect &&
          calibratedBubble.roll.abs() < 1.0 &&
          calibratedBubble.pitch.abs() < 1.0) {
        SoundService.playBeep();
      }
    });
  }

  // Settings load karo
  Future<void> _loadSettings() async {
    final loaded = await _repo.load();
    state = state.copyWith(settings: loaded);
  }

  // Settings update aur persist karo
  Future<void> updateSettings(SettingsModel newSettings) async {
    state = state.copyWith(settings: newSettings);
    await _repo.save(newSettings);
  }

  // Shortcuts for toggles
  void toggleShowNumericAngle(bool value) {
    updateSettings(state.settings.copyWith(showNumericAngle: value));
  }

  void changeDisplayType(String value) {
    updateSettings(state.settings.copyWith(displayType: value));
  }

  void toggleOrientationLock(bool value) {
    updateSettings(state.settings.copyWith(allowOrientationLock: value));
  }

  void changeViscosity(String value) {
    updateSettings(state.settings.copyWith(viscosity: value));
  }

  void toggleSoundEffect(bool value) {
    updateSettings(state.settings.copyWith(soundEffect: value));
  }

  // ✅ Calibration methods
  void calibrate(double rawRoll, double rawPitch) {
    _offsetX = rawRoll;
    _offsetY = rawPitch;

    final newBubble = state.bubble.copyWith(
      roll: state.bubble.roll - _offsetX,
      pitch: state.bubble.pitch - _offsetY,
    );

    state = state.copyWith(bubble: newBubble);
  }

  void resetCalibration() {
    _offsetX = 0;
    _offsetY = 0;

    final newBubble = state.bubble.copyWith(roll: 0, pitch: 0);
    state = state.copyWith(bubble: newBubble);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final bubbleProvider = StateNotifierProvider<BubbleNotifier, BubbleState>(
  (ref) => BubbleNotifier(SettingsRepository()),
);
