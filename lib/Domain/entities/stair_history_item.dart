import 'package:hive/hive.dart';

part 'stair_history_item.g.dart';

@HiveType(typeId: 19) // Unique typeId
class StairHistoryItem extends HiveObject {
  // Inputs
  @HiveField(0)
  String riserFT;

  @HiveField(1)
  String riserIN;

  @HiveField(2)
  String treadFT;

  @HiveField(3)
  String treadIN;

  @HiveField(4)
  String stairWidthFT;

  @HiveField(5)
  String stairHeightFT;

  @HiveField(6)
  String waistSlabIN;

  @HiveField(7)
  String grade;

  // Results
  @HiveField(8)
  double volume; // ft³

  @HiveField(9)
  double cementBags;

  @HiveField(10)
  double sand; // ft³

  @HiveField(11)
  double aggregate; // ft³

  @HiveField(12)
  DateTime savedAt;

  StairHistoryItem({
    required this.riserFT,
    required this.riserIN,
    required this.treadFT,
    required this.treadIN,
    required this.stairWidthFT,
    required this.stairHeightFT,
    required this.waistSlabIN,
    required this.grade,
    required this.volume,
    required this.cementBags,
    required this.sand,
    required this.aggregate,
    required this.savedAt,
  });
}
