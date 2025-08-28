import 'package:hive/hive.dart';

part 'flooring_history_item.g.dart';

@HiveType(
  typeId: 7,
) // ✅ Alag unique typeId dena hamesha (BoundaryWall = 6, Flooring = 7)
class FlooringHistoryItem extends HiveObject {
  // Selected Unit
  @HiveField(0)
  String selectedUnit; // "Meter/CM" or "Feet/Inch"

  // Floor Dimensions
  @HiveField(1)
  double floorLength; // in meters
  @HiveField(2)
  double floorWidth; // in meters

  // Tile Dimensions (always feet input, but converted to meters for calculation)
  @HiveField(3)
  double tileLength;
  @HiveField(4)
  double tileWidth;

  // Results
  @HiveField(5)
  int totalTiles;
  @HiveField(6)
  double cementBags;
  @HiveField(7)
  double sandTons;
  @HiveField(8)
  double mortarVolume;

  // Timestamp
  @HiveField(9)
  DateTime savedAt;

  FlooringHistoryItem({
    required this.selectedUnit,
    required this.floorLength,
    required this.floorWidth,
    required this.tileLength,
    required this.tileWidth,
    required this.totalTiles,
    required this.cementBags,
    required this.sandTons,
    required this.mortarVolume,
    required this.savedAt,
  });
}
