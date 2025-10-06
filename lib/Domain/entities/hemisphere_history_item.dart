import 'package:hive/hive.dart';

part 'hemisphere_history_item.g.dart';

@HiveType(typeId: 40)
class HemisphereHistoryItem extends HiveObject {
  @HiveField(0)
  double radius;

  @HiveField(1)
  String unit;

  @HiveField(2)
  double surfaceArea;

  @HiveField(3)
  double volume;

  @HiveField(4)
  DateTime savedAt;

  HemisphereHistoryItem({
    required this.radius,
    required this.unit,
    required this.surfaceArea,
    required this.volume,
    required this.savedAt,
  });
}
