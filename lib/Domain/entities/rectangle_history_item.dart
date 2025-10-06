import 'package:hive/hive.dart';

part 'rectangle_history_item.g.dart';

@HiveType(typeId: 37)
class RectangleHistoryItem extends HiveObject {
  @HiveField(0)
  double length;

  @HiveField(1)
  double width;

  @HiveField(2)
  String unit;

  @HiveField(3)
  double area;

  @HiveField(4)
  double perimeter;

  @HiveField(5)
  DateTime savedAt;

  RectangleHistoryItem({
    required this.length,
    required this.width,
    required this.unit,
    required this.area,
    required this.perimeter,
    required this.savedAt,
  });
}
