import 'package:hive/hive.dart';

part 'round_column_history_item.g.dart';

@HiveType(
  typeId: 18,
) // 👈 unique ID (make sure ye kisi aur model se clash na ho)
class RoundColumnHistoryItem extends HiveObject {
  // Inputs
  @HiveField(0)
  String diM;

  @HiveField(1)
  String diCM;

  @HiveField(2)
  String diFT;

  @HiveField(3)
  String diIN;

  @HiveField(4)
  String htM;

  @HiveField(5)
  String htCM;

  @HiveField(6)
  String htFT;

  @HiveField(7)
  String htIN;

  @HiveField(8)
  String noOfColumns;

  @HiveField(9)
  String grade;

  @HiveField(10)
  String unit;

  // Results
  @HiveField(11)
  double volume;

  @HiveField(12)
  double cementBags;

  @HiveField(13)
  double sandCft;

  @HiveField(14)
  double aggregateCft;

  RoundColumnHistoryItem({
    required this.diM,
    required this.diCM,
    required this.diFT,
    required this.diIN,
    required this.htM,
    required this.htCM,
    required this.htFT,
    required this.htIN,
    required this.noOfColumns,
    required this.grade,
    required this.unit,
    required this.volume,
    required this.cementBags,
    required this.sandCft,
    required this.aggregateCft,
  });
}
