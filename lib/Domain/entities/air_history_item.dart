import 'package:hive/hive.dart';

part 'air_history_item.g.dart';

@HiveType(typeId: 10)
class AirHistoryItem extends HiveObject {
  // Room Dimensions
  @HiveField(0)
  final double lengthFt;

  @HiveField(1)
  final double lengthIn;

  @HiveField(2)
  final double breadthFt;

  @HiveField(3)
  final double breadthIn;

  @HiveField(4)
  final double heightFt;

  @HiveField(5)
  final double heightIn;

  // Extra Inputs
  @HiveField(6)
  final int persons;

  @HiveField(7)
  final double maxTempC;

  // Result (AC Size in Tons)
  @HiveField(8)
  final double tons;

  // Meta
  @HiveField(9)
  final DateTime savedAt;

  AirHistoryItem({
    required this.lengthFt,
    required this.lengthIn,
    required this.breadthFt,
    required this.breadthIn,
    required this.heightFt,
    required this.heightIn,
    required this.persons,
    required this.maxTempC,
    required this.tons,
    required this.savedAt,
  });
}

