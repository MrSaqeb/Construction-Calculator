import 'package:hive/hive.dart';

part 'vertical_cylinder_item.g.dart';

@HiveType(typeId: 44)
class VerticalCylinderHistoryItem extends HiveObject {
  @HiveField(0)
  double diameter;

  @HiveField(1)
  double height;

  @HiveField(2)
  double filled;

  @HiveField(3)
  String unit; // cm, mm, inch etc.

  @HiveField(4)
  double totalVolume;

  @HiveField(5)
  double filledVolume;

  @HiveField(6)
  DateTime savedAt;

  VerticalCylinderHistoryItem({
    required this.diameter,
    required this.height,
    required this.filled,
    required this.unit,
    required this.totalVolume,
    required this.filledVolume,
    required this.savedAt,
  });
}
