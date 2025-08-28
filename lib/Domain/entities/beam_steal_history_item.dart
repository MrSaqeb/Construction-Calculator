import 'package:hive/hive.dart';

part 'beam_steal_history_item.g.dart';

@HiveType(typeId: 26) // unique id, har model ke liye alag
class BeamStealHistoryItem extends HiveObject {
  @HiveField(0)
  double sizeA;

  @HiveField(1)
  double sizeB;

  @HiveField(2)
  double sizeT;

  @HiveField(3)
  double sizeS;

  @HiveField(4)
  double length;

  @HiveField(5)
  int pieces;

  @HiveField(6)
  String material;

  @HiveField(7)
  String lengthUnit;

  @HiveField(8)
  String weightUnit;

  @HiveField(9)
  double costPerKg;

  @HiveField(10)
  double weightKg;

  @HiveField(11)
  double weightTons;

  @HiveField(12)
  double totalCost;

  @HiveField(13)
  DateTime savedAt;

  BeamStealHistoryItem({
    required this.sizeA,
    required this.sizeB,
    required this.sizeT,
    required this.sizeS,
    required this.length,
    required this.pieces,
    required this.material,
    required this.lengthUnit,
    required this.weightUnit,
    required this.costPerKg,
    required this.weightKg,
    required this.weightTons,
    required this.totalCost,
    required this.savedAt,
  });
}
