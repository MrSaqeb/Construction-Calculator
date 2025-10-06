class SettingsModel {
  final bool showNumericAngle;
  final String displayType;
  final bool allowOrientationLock;
  final String viscosity;
  final bool soundEffect;

  const SettingsModel({
    required this.showNumericAngle,
    required this.displayType,
    required this.allowOrientationLock,
    required this.viscosity,
    required this.soundEffect,
  });

  SettingsModel copyWith({
    bool? showNumericAngle,
    String? displayType,
    bool? allowOrientationLock,
    String? viscosity,
    bool? soundEffect,
  }) {
    return SettingsModel(
      showNumericAngle: showNumericAngle ?? this.showNumericAngle,
      displayType: displayType ?? this.displayType,
      allowOrientationLock: allowOrientationLock ?? this.allowOrientationLock,
      viscosity: viscosity ?? this.viscosity,
      soundEffect: soundEffect ?? this.soundEffect,
    );
  }

  factory SettingsModel.initial() {
    return const SettingsModel(
      showNumericAngle: true,
      displayType: "Angle",
      allowOrientationLock: false,
      viscosity: "Low",
      soundEffect: true,
    );
  }
}
