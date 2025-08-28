import 'package:hive/hive.dart';

part 'round_steal_history_item.g.dart';

@HiveType(typeId: 27) // ⚠️ har model ke liye unique id
class RoundStealHistoryItem extends HiveObject {
  @HiveField(0)
  double diameter;

  @HiveField(1)
  double length;

  @HiveField(2)
  int pieces;

  @HiveField(3)
  String material;

  @HiveField(4)
  String lengthUnit;

  @HiveField(5)
  String weightUnit;

  @HiveField(6)
  double costPerKg;

  @HiveField(7)
  double weightKg;

  @HiveField(8)
  double weightTons;

  @HiveField(9)
  double totalCost;

  @HiveField(10)
  DateTime savedAt;

  RoundStealHistoryItem({
    required this.diameter,
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
