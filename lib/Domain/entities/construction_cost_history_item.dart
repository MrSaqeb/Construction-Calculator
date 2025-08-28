import 'package:hive/hive.dart';

part 'construction_cost_history_item.g.dart';

@HiveType(typeId: 1)
class ConstructionCostHistoryItem extends HiveObject {
  @HiveField(1)
  final double? area;

  @HiveField(2)
  final double? totalCost;

  @HiveField(3)
  final double? materialQuantity;

  @HiveField(4)
  final String? unit;

  @HiveField(5)
  final DateTime? dateTime;

  // Cost fields
  @HiveField(6)
  final double? cementCost;

  @HiveField(7)
  final double? sandCost;

  @HiveField(8)
  final double? aggregateCost;

  @HiveField(9)
  final double? streetCost;

  @HiveField(10)
  final double? finishersCost;

  @HiveField(11)
  final double? fittingsCost;

  // Quantity fields
  @HiveField(12)
  final double? cementQty;

  @HiveField(13)
  final double? sandQty;

  @HiveField(14)
  final double? aggregateQty;

  @HiveField(15)
  final double? streetQty;

  @HiveField(16)
  final double? paintQty;

  @HiveField(17)
  final double? bricksQty;

  // Cost per sq.ft
  @HiveField(18)
  final double? costPerSqFt;

  // Maps
  @HiveField(19)
  final Map<String, String>? materialCosts;

  @HiveField(20)
  final Map<String, String>? materialQuantities;

  @HiveField(21)
  final double? costInput;

  ConstructionCostHistoryItem({
    required this.area,
    required this.costInput,
    required this.totalCost,
    required this.materialQuantity,
    required this.unit,
    required this.dateTime,
    required this.cementCost,
    required this.sandCost,
    required this.aggregateCost,
    required this.streetCost,
    required this.finishersCost,
    required this.fittingsCost,
    required this.cementQty,
    required this.sandQty,
    required this.aggregateQty,
    required this.streetQty,
    required this.paintQty,
    required this.bricksQty,
    required this.costPerSqFt,
    required this.materialCosts,
    required this.materialQuantities,
  });
}
