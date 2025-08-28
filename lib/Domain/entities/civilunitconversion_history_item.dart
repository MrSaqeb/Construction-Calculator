import 'package:hive/hive.dart';

part 'civilunitconversion_history_item.g.dart';

@HiveType(typeId: 23)
class ConversionHistory extends HiveObject {
  @HiveField(0)
  String inputValue;

  @HiveField(1)
  String fromUnit;

  @HiveField(2)
  String toUnit;

  @HiveField(3)
  String resultValue;

  @HiveField(4)
  DateTime timestamp;

  ConversionHistory({
    required this.inputValue,
    required this.fromUnit,
    required this.toUnit,
    required this.resultValue,
    required this.timestamp,
  });
}
