import 'package:hive/hive.dart';

part 'rectangular_prism_item.g.dart';

@HiveType(typeId: 46)
class RectangularPrismItem extends HiveObject {
  // Inputs
  @HiveField(0)
  double length; // base1Controller

  @HiveField(1)
  double width; // base2Controller

  @HiveField(2)
  double height; // heightController

  @HiveField(3)
  double filledHeight; // filledController

  @HiveField(4)
  String unit; // Meter, Feet, etc.

  // Outputs
  @HiveField(5)
  double totalVolume; // in m³

  @HiveField(6)
  double filledVolume; // in m³

  RectangularPrismItem({
    required this.length,
    required this.width,
    required this.height,
    required this.filledHeight,
    required this.unit,
    required this.totalVolume,
    required this.filledVolume,
  });
}
