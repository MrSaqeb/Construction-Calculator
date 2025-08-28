import 'package:hive/hive.dart';

part 'square_bar_history_item.g.dart';

@HiveType(typeId: 28) // Unique ID
class SquareBarHistoryItem extends HiveObject {
  @HiveField(0)
  double side;

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

  SquareBarHistoryItem({
    required this.side,
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
