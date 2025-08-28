import 'package:hive/hive.dart';

part 'frequency_history_item.g.dart';

@HiveType(typeId: 30)
class FrequencyHistoryItem extends HiveObject {
  @HiveField(0)
  final double inputValue;

  @HiveField(1)
  final String inputUnit;

  @HiveField(2)
  final Map<String, double> convertedValues;

  @HiveField(3)
  final DateTime savedAt;

  FrequencyHistoryItem({
    required this.inputValue,
    required this.inputUnit,
    required this.convertedValues,
    required this.savedAt,
  });
}
