import 'package:hive/hive.dart';

part 'circle_history_item.g.dart';

@HiveType(typeId: 36) // 👈 unique ID do
class CircleHistoryItem extends HiveObject {
  @HiveField(0)
  double inputValue;

  @HiveField(1)
  String inputUnit;

  @HiveField(2)
  String resultType; // Area / Perimeter etc.

  @HiveField(3)
  double resultValue;

  @HiveField(4)
  DateTime savedAt;

  CircleHistoryItem({
    required this.inputValue,
    required this.inputUnit,
    required this.resultType,
    required this.resultValue,
    required this.savedAt,
  });
}
