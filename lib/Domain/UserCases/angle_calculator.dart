import 'dart:math';

import 'package:construction_calculator/Domain/entities/patch_roll.dart';

class AngleCalculator {
  static PitchRoll fromAccelerometer(double x, double y, double z) {
    final pitch = atan2(x, sqrt(y * y + z * z)) * (180 / pi);
    final roll = atan2(y, sqrt(x * x + z * z)) * (180 / pi);
    return PitchRoll(pitch, roll);
  }
}
