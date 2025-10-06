import 'package:hive/hive.dart';

part 'horizontal_elliptical_item.g.dart';

@HiveType(typeId: 50)
class HorizontalEllipticalHistoryItem extends HiveObject {
  @HiveField(0)
  double length; // Horizontal axis length

  @HiveField(1)
  double width; // Width

  @HiveField(2)
  double height; // Vertical height

  @HiveField(3)
  double filled; // Filled height

  @HiveField(4)
  String unit; // Meter, Feet, etc.

  @HiveField(5)
  double totalVolume; // in m³

  @HiveField(6)
  double filledVolume; // in m³

  @HiveField(7)
  DateTime savedAt; // Timestamp of saving

  HorizontalEllipticalHistoryItem({
    required this.length,
    required this.width,
    required this.height,
    required this.filled,
    required this.unit,
    required this.totalVolume,
    required this.filledVolume,
    required this.savedAt,
  });
}
