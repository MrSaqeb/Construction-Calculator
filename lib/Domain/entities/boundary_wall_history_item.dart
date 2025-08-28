import 'package:hive/hive.dart';

part 'boundary_wall_history_item.g.dart';

@HiveType(typeId: 6) // unique typeId, har entity ka alag hona chahiye
class BoundaryWallItem extends HiveObject {
  // Selected Unit
  @HiveField(0)
  String selectedUnit; // "Meter/CM" or "Feet/Inch"

  // Area Dimensions
  @HiveField(1)
  double areaLength;
  @HiveField(2)
  double areaHeight;

  // Horizontal Bar Dimensions
  @HiveField(3)
  double barLength;
  @HiveField(4)
  double barHeight;

  // Results
  @HiveField(5)
  int totalHorizontalBars;
  @HiveField(6)
  int totalVerticalBars;
  @HiveField(7)
  int totalPanels;

  // Timestamp
  @HiveField(8)
  DateTime savedAt;

  BoundaryWallItem({
    required this.selectedUnit,
    required this.areaLength,
    required this.areaHeight,
    required this.barLength,
    required this.barHeight,
    required this.totalHorizontalBars,
    required this.totalVerticalBars,
    required this.totalPanels,
    required this.savedAt,
  });
}
