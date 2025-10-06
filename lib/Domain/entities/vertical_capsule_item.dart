import 'package:hive/hive.dart';

part 'vertical_capsule_item.g.dart';

@HiveType(typeId: 47)
class VerticalCapsuleItem extends HiveObject {
  // Inputs
  @HiveField(0)
  double diameter; // base1Controller

  @HiveField(1)
  double cylinderHeight; // base2Controller

  @HiveField(2)
  double filledHeight; // heightController

  @HiveField(3)
  String unit; // Meter, Feet, etc.

  // Outputs
  @HiveField(4)
  double totalVolume; // in m³

  @HiveField(5)
  double filledVolume; // in m³

  VerticalCapsuleItem({
    required this.diameter,
    required this.cylinderHeight,
    required this.filledHeight,
    required this.unit,
    required this.totalVolume,
    required this.filledVolume,
  });
}
