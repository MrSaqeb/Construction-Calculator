import 'package:hive/hive.dart';

part 'horizontal_cylinder_item.g.dart';

@HiveType(typeId: 45)
class HorizontalCylinderItem extends HiveObject {
  // Inputs
  @HiveField(0)
  double diameter; // base1Controller

  @HiveField(1)
  double length; // base2Controller

  @HiveField(2)
  double filledHeight; // heightController

  @HiveField(3)
  String unit; // Meter, Feet, etc.

  // Outputs
  @HiveField(4)
  double totalVolume; // in m³

  @HiveField(5)
  double filledVolume; // in m³

  HorizontalCylinderItem({
    required this.diameter,
    required this.length,
    required this.filledHeight,
    required this.unit,
    required this.totalVolume,
    required this.filledVolume,
  });
}
