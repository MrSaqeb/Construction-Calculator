import 'package:hive/hive.dart';

part 'wood_frame_history_item.g.dart';

@HiveType(typeId: 15)
class WoodFrameHistoryItem extends HiveObject {
  @HiveField(0)
  final double length; // meters or feet (converted based on selectedUnit)

  @HiveField(1)
  final double width; // meters or feet

  @HiveField(2)
  final double depth; // meters or feet

  @HiveField(3)
  final double volume; // cubic meters

  @HiveField(4)
  final String unit; // "Meter/CM" or "Feet/Inch"

  @HiveField(5)
  final DateTime date;

  WoodFrameHistoryItem({
    required this.length,
    required this.width,
    required this.depth,
    required this.volume,
    required this.unit,
    required this.date,
  });
}
