import 'package:construction_calculator/Domain/entities/patch_roll.dart';
import 'package:construction_calculator/Domain/entities/bubble_settong_model.dart';

class BubbleState {
  final PitchRoll bubble; // sensor data
  final SettingsModel settings; // user settings

  const BubbleState({required this.bubble, required this.settings});

  BubbleState copyWith({PitchRoll? bubble, SettingsModel? settings}) {
    return BubbleState(
      bubble: bubble ?? this.bubble,
      settings: settings ?? this.settings,
    );
  }

  factory BubbleState.initial() {
    return BubbleState(
      bubble: const PitchRoll(0, 0),
      settings: SettingsModel.initial(),
    );
  }
}
