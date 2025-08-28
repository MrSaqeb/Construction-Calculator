import 'package:hive/hive.dart';

part 'distance_history_item.g.dart';

@HiveType(typeId:28) // apni unique typeId rakho
class DistanceHistoryItem extends HiveObject {
  @HiveField(0)
  final double inputValue;

  @HiveField(1)
  final String inputUnit;

  @HiveField(2)
  final Map<String, double> convertedValues;

  @HiveField(4)
  final DateTime savedAt;

  DistanceHistoryItem({
    required this.inputValue,
    required this.inputUnit,
    required this.convertedValues,
    required this.savedAt,
  });
}
