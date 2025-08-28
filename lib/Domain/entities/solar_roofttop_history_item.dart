import 'package:hive/hive.dart';

part 'solar_roofttop_history_item.g.dart'; // generate karo build_runner se

@HiveType(typeId: 11)
class SolarHistoryItem extends HiveObject {
  @HiveField(0)
  String consumptionType; // Monthly / Yearly

  @HiveField(1)
  double inputConsumption;

  @HiveField(2)
  double dailyUnit;

  @HiveField(3)
  double kwSystem;

  @HiveField(4)
  double totalPanels;

  @HiveField(5)
  double rooftopAreaSqFt;

  @HiveField(6)
  double rooftopAreaSqM;

  @HiveField(7)
  DateTime timestamp;

  SolarHistoryItem({
    required this.consumptionType,
    required this.inputConsumption,
    required this.dailyUnit,
    required this.kwSystem,
    required this.totalPanels,
    required this.rooftopAreaSqFt,
    required this.rooftopAreaSqM,
    required this.timestamp,
  });
}
