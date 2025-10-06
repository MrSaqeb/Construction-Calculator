import 'package:hive/hive.dart';

part 'sector_history_item.g.dart';

@HiveType(typeId: 41)
class SectorHistoryItem extends HiveObject {
  @HiveField(0)
  double radius;

  @HiveField(1)
  double angle; // in degrees

  @HiveField(2)
  String unit;

  @HiveField(3)
  double area;

  @HiveField(4)
  DateTime savedAt;

  SectorHistoryItem({
    required this.radius,
    required this.angle,
    required this.unit,
    required this.area,
    required this.savedAt,
  });
}
