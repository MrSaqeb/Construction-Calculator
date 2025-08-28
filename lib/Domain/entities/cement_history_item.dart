import 'package:hive/hive.dart';

part 'cement_history_item.g.dart';

@HiveType(typeId: 3) // Use a different typeId than your BrickHistoryItem
class CementHistoryItem extends HiveObject {
  @HiveField(0)
  final String lenM;
  @HiveField(1)
  final String lenCM;
  @HiveField(2)
  final String lenFT;
  @HiveField(3)
  final String lenIN;
  @HiveField(4)
  final String htM;
  @HiveField(5)
  final String htCM;
  @HiveField(6)
  final String htFT;
  @HiveField(7)
  final String htIN;
  @HiveField(8)
  final String depthCM;
  @HiveField(9)
  final String depthIN;
  @HiveField(10)
  final String grade;
  @HiveField(11)
  final double volume;
  @HiveField(12)
  final double cementBags;
  @HiveField(13)
  final double sandCft;
  @HiveField(14)
  final double aggregateCft;
  @HiveField(15)
  final String unit;
  @HiveField(16)
  final DateTime timestamp;

  CementHistoryItem({
    required this.lenM,
    required this.lenCM,
    required this.lenFT,
    required this.lenIN,
    required this.htM,
    required this.htCM,
    required this.htFT,
    required this.htIN,
    required this.depthCM,
    required this.depthIN,
    required this.grade,
    required this.volume,
    required this.cementBags,
    required this.sandCft,
    required this.aggregateCft,
    required this.unit,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Helper method to create a display string
  String get displayString {
    return '$volume m³ - $cementBags bags (${grade.replaceAll('(', '').replaceAll(')', '')})';
  }
}
