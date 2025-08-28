import 'package:hive/hive.dart';

part 'fuel_history_item.g.dart';

@HiveType(typeId: 31)
class FuelHistoryItem extends HiveObject {
  @HiveField(0)
  final double inputValue;

  @HiveField(1)
  final String inputUnit;

  @HiveField(2)
  final Map<String, double> convertedValues;

  @HiveField(3)
  final DateTime savedAt;

  FuelHistoryItem({
    required this.inputValue,
    required this.inputUnit,
    required this.convertedValues,
    required this.savedAt,
  });
}
