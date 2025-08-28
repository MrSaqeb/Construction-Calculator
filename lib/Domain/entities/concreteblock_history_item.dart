import 'package:hive/hive.dart';

part 'concreteblock_history_item.g.dart';

@HiveType(typeId: 5)
class ConcreteBlockHistory extends HiveObject {
  @HiveField(0)
  final DateTime dateTime;

  @HiveField(1)
  final String unitType;

  @HiveField(2)
  final double length;

  @HiveField(3)
  final double height;

  @HiveField(4)
  final double thickness;

  @HiveField(5)
  final int mortarRatio;

  @HiveField(6)
  final double blockLength;

  @HiveField(7)
  final double blockWidth;

  @HiveField(8)
  final double blockHeight;

  @HiveField(9)
  final int totalBlocks;

  @HiveField(10)
  final double masonryVolume;

  @HiveField(11)
  final double cementBags;

  @HiveField(12)
  final double sandTons;

  ConcreteBlockHistory({
    required this.dateTime,
    required this.unitType,
    required this.length,
    required this.height,
    required this.thickness,
    required this.mortarRatio,
    required this.blockLength,
    required this.blockWidth,
    required this.blockHeight,
    required this.totalBlocks,
    required this.masonryVolume,
    required this.cementBags,
    required this.sandTons,
  });

  // Convert to map for easy display
  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime.toString(),
      'unitType': unitType,
      'length': length,
      'height': height,
      'thickness': thickness,
      'mortarRatio': mortarRatio,
      'blockLength': blockLength,
      'blockWidth': blockWidth,
      'blockHeight': blockHeight,
      'totalBlocks': totalBlocks,
      'masonryVolume': masonryVolume,
      'cementBags': cementBags,
      'sandTons': sandTons,
    };
  }
}
