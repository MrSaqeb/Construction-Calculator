import 'package:hive/hive.dart';

part 'horizontal_capsule_item.g.dart';

@HiveType(typeId: 48)
class HorizontalCapsuleItem extends HiveObject {
  // Inputs
  @HiveField(0)
  double diameter; // base1Controller

  @HiveField(1)
  double cylinderLength; // base2Controller

  @HiveField(2)
  double filledLength; // heightController

  @HiveField(3)
  String unit; // Meter, Feet, etc.

  // Outputs
  @HiveField(4)
  double totalVolume; // in m³

  @HiveField(5)
  double filledVolume; // in m³

  HorizontalCapsuleItem({
    required this.diameter,
    required this.cylinderLength,
    required this.filledLength,
    required this.unit,
    required this.totalVolume,
    required this.filledVolume,
  });
}
