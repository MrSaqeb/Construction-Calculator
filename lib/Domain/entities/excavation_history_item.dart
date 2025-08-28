import 'package:hive/hive.dart';

part 'excavation_history_item.g.dart';

@HiveType(typeId: 14)
class ExcavationHistoryItem extends HiveObject {
  @HiveField(0)
  final double length; // meters

  @HiveField(1)
  final double width; // meters

  @HiveField(2)
  final double depth; // meters

  @HiveField(3)
  final double volume; // cubic meters

  @HiveField(4)
  final String unit; // "Meter/CM" or "Feet/Inch"

  @HiveField(5)
  final DateTime date;

  ExcavationHistoryItem({
    required this.length,
    required this.width,
    required this.depth,
    required this.volume,
    required this.unit,
    required this.date,
  });
}
