import 'package:hive/hive.dart';

part 'solor_waterheater_history_item.g.dart';

@HiveType(typeId: 12)
class SolarWaterHistoryItem extends HiveObject {
  @HiveField(0)
  final double inputConsumption;

  @HiveField(1)
  final double totalCapacity;

  @HiveField(2)
  final DateTime timestamp;

  SolarWaterHistoryItem({
    required this.inputConsumption,
    required this.totalCapacity,
    required this.timestamp,
  });
}
