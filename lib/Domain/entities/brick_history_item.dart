import 'package:hive/hive.dart';

part 'brick_history_item.g.dart';

@HiveType(typeId: 2) // <-- Alag typeId, taaki Hive confuse na ho
class BrickHistoryItem extends HiveObject {
  @HiveField(0)
  final String? lenM;

  @HiveField(1)
  final String? lenCM;

  @HiveField(2)
  final String? lenFT;

  @HiveField(3)
  final String? lenIN;

  @HiveField(4)
  final String? htM;

  @HiveField(5)
  final String? htCM;

  @HiveField(6)
  final String? htFT;

  @HiveField(7)
  final String? htIN;

  @HiveField(8)
  final String? thickness;

  @HiveField(9)
  final String? brickLcm;

  @HiveField(10)
  final String? brickWcm;

  @HiveField(11)
  final String? brickHcm;

  @HiveField(12)
  final int? mortarX;

  @HiveField(13)
  final double? bricksQty;

  @HiveField(14)
  final String? unit;

  BrickHistoryItem({
    required this.lenM,
    required this.lenCM,
    required this.lenFT,
    required this.lenIN,
    required this.htM,
    required this.htCM,
    required this.htFT,
    required this.htIN,
    required this.thickness,
    required this.brickLcm,
    required this.brickWcm,
    required this.brickHcm,
    required this.mortarX,
    required this.bricksQty,
    required this.unit,
  });
}
