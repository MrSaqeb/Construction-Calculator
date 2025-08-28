import 'package:hive/hive.dart';

part 'water_sump_history_item.g.dart';

@HiveType(typeId: 9)
class WaterSumpHistoryItem extends HiveObject {
  @HiveField(0)
  final double length;

  @HiveField(1)
  final double width;

  @HiveField(2)
  final double depth;

  @HiveField(3)
  final double volume;

  @HiveField(4)
  final double capacityInLiters;

  @HiveField(5)
  final double capacityInCubicFeet;

  @HiveField(6)
  final DateTime savedAt;

  WaterSumpHistoryItem({
    required this.length,
    required this.width,
    required this.depth,
    required this.volume,
    required this.capacityInLiters,
    required this.capacityInCubicFeet,
    required this.savedAt,
  });
}
