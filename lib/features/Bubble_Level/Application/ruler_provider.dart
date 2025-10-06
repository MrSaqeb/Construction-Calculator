import 'package:flutter_riverpod/flutter_riverpod.dart';

class RulerState {
  final double leftLineY;
  final double rightLineY;
  final bool showCalibration;

  // 👇 yeh dono nayi fields add karo
  final int leftMaxInches;
  final int rightMaxInches;

  const RulerState({
    required this.leftLineY,
    required this.rightLineY,
    required this.showCalibration,
    required this.leftMaxInches,
    required this.rightMaxInches,
  });

  RulerState copyWith({
    double? leftLineY,
    double? rightLineY,
    bool? showCalibration,
    int? leftMaxInches,
    int? rightMaxInches,
  }) {
    return RulerState(
      leftLineY: leftLineY ?? this.leftLineY,
      rightLineY: rightLineY ?? this.rightLineY,
      showCalibration: showCalibration ?? this.showCalibration,
      leftMaxInches: leftMaxInches ?? this.leftMaxInches,
      rightMaxInches: rightMaxInches ?? this.rightMaxInches,
    );
  }

  factory RulerState.initial() {
    return const RulerState(
      leftLineY: 200,
      rightLineY: 200,
      showCalibration: false,
      leftMaxInches: 11, // 👈 default left ruler 0–11
      rightMaxInches: 4, // 👈 default right ruler 0–4
    );
  }
}

class RulerNotifier extends StateNotifier<RulerState> {
  RulerNotifier() : super(RulerState.initial());

  void reset() {
    state = RulerState.initial().copyWith(
      showCalibration: state.showCalibration,
    );
  }

  void toggleCalibration() {
    state = state.copyWith(showCalibration: !state.showCalibration);
  }

  void move(bool isLeft, double newY) {
    if (isLeft) {
      int newMax = (newY / 20).clamp(4, 20).toInt();
      state = state.copyWith(leftLineY: newY, leftMaxInches: newMax);
    } else {
      int newMax = (newY / 15).clamp(4, 20).toInt();
      state = state.copyWith(rightLineY: newY, rightMaxInches: newMax);
    }
  }
}

final rulerProvider = StateNotifierProvider<RulerNotifier, RulerState>((ref) {
  return RulerNotifier();
});
