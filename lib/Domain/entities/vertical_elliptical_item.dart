import 'package:hive/hive.dart';

part 'vertical_elliptical_item.g.dart';

@HiveType(typeId: 49) // unique typeId
class VerticalEllipticalItem extends HiveObject {
  @HiveField(0)
  double length;

  @HiveField(1)
  double width;

  @HiveField(2)
  double height;

  @HiveField(3)
  double filledHeight;

  @HiveField(4)
  String unit; // Meter, Feet, etc.

  @HiveField(5)
  double totalVolume; // in m³

  @HiveField(6)
  double filledVolume; // in m³

  VerticalEllipticalItem({
    required this.length,
    required this.width,
    required this.height,
    required this.filledHeight,
    required this.unit,
    required this.totalVolume,
    required this.filledVolume,
  });
}
