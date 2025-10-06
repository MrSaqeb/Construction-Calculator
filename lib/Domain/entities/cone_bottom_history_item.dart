import 'package:hive/hive.dart';

part 'cone_bottom_history_item.g.dart';

@HiveType(typeId: 51)
class ConeBottomHistoryItem extends HiveObject {
  @HiveField(0)
  double topDiameter;

  @HiveField(1)
  double bottomDiameter;

  @HiveField(2)
  double cylinderHeight;

  @HiveField(3)
  double coneHeight;

  @HiveField(4)
  double filledHeight;

  @HiveField(5)
  String unit; // Meter, Feet, etc.

  @HiveField(6)
  double totalVolume; // in m³

  @HiveField(7)
  double filledVolume; // in m³

  @HiveField(8)
  DateTime savedAt; // Timestamp

  ConeBottomHistoryItem({
    required this.topDiameter,
    required this.bottomDiameter,
    required this.cylinderHeight,
    required this.coneHeight,
    required this.filledHeight,
    required this.unit,
    required this.totalVolume,
    required this.filledVolume,
    required this.savedAt,
  });
}
