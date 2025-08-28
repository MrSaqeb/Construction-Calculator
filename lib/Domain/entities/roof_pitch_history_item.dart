import 'package:hive/hive.dart';

part 'roof_pitch_history_item.g.dart';

@HiveType(typeId: 22)
class RoofPitchHistoryItem extends HiveObject {
  // Inputs (exactly as controllers)
  @HiveField(0)
  final String heightM;
  @HiveField(1)
  final String heightCM;
  @HiveField(2)
  final String heightFT;
  @HiveField(3)
  final String heightIN;

  @HiveField(4)
  final String widthM;
  @HiveField(5)
  final String widthCM;
  @HiveField(6)
  final String widthFT;
  @HiveField(7)
  final String widthIN;

  @HiveField(8)
  final String unit; // selectedUnit

  // Results (matching UI variables)
  @HiveField(9)
  final double roofPitch; // ratio rise/run
  @HiveField(10)
  final double roofSlope; // %
  @HiveField(11)
  final double roofAngle; // degrees

  RoofPitchHistoryItem({
    required this.heightM,
    required this.heightCM,
    required this.heightFT,
    required this.heightIN,
    required this.widthM,
    required this.widthCM,
    required this.widthFT,
    required this.widthIN,
    required this.unit,
    required this.roofPitch,
    required this.roofSlope,
    required this.roofAngle,
  });
}
