class PitchRoll {
  final double pitch;
  final double roll;

  const PitchRoll(this.pitch, this.roll);

  double get pitchPercent => (pitch / 90) * 100;
  double get rollPercent => (roll / 90) * 100;

  double get rawX => roll; // ya actual accelerometer X value
  double get rawY => pitch; // ya actual accelerometer Y value

  // ✅ copyWith method
  PitchRoll copyWith({double? pitch, double? roll}) {
    return PitchRoll(pitch ?? this.pitch, roll ?? this.roll);
  }
}
