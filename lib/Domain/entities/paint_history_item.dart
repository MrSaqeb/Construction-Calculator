import 'package:hive/hive.dart';

part 'paint_history_item.g.dart';

@HiveType(typeId: 13)
class PaintHistoryItem extends HiveObject {
  @HiveField(0)
  final double paintArea;

  @HiveField(1)
  final double paintQuantity;

  @HiveField(2)
  final double primerQuantity;

  @HiveField(3)
  final double puttyQuantity;

  @HiveField(4)
  final String unit; // "Meter" or "Feet"

  @HiveField(5)
  final DateTime date;

  PaintHistoryItem({
    required this.paintArea,
    required this.paintQuantity,
    required this.primerQuantity,
    required this.puttyQuantity,
    required this.unit,
    required this.date,
  });
}
