import 'package:hive/hive.dart';

part 'Lshape_history_item.g.dart';

@HiveType(typeId: 38)
class LShapeHistoryItem extends HiveObject {
  @HiveField(0)
  double l1;

  @HiveField(1)
  double w1;

  @HiveField(2)
  double l2;

  @HiveField(3)
  double w2;

  @HiveField(4)
  String unit;

  @HiveField(5)
  double area;

  @HiveField(6)
  double perimeter;

  @HiveField(7)
  DateTime savedAt;

  LShapeHistoryItem({
    required this.l1,
    required this.w1,
    required this.l2,
    required this.w2,
    required this.unit,
    required this.area,
    required this.perimeter,
    required this.savedAt,
  });
}
