import 'package:hive/hive.dart';

part 'frustum_history_item.g.dart';

@HiveType(typeId: 53)
class FrustumHistoryItem extends HiveObject {
  @HiveField(0)
  double topDiameter;

  @HiveField(1)
  double bottomDiameter;

  @HiveField(2)
  double height;

  @HiveField(3)
  double filledHeight;

  @HiveField(4)
  String unit; // Meter, Feet, etc.

  @HiveField(5)
  double totalVolume; // in m³

  @HiveField(6)
  double filledVolume; // in m³

  @HiveField(7)
  DateTime savedAt; // Timestamp

  FrustumHistoryItem({
    required this.topDiameter,
    required this.bottomDiameter,
    required this.height,
    required this.filledHeight,
    required this.unit,
    required this.totalVolume,
    required this.filledVolume,
    required this.savedAt,
  });
}
