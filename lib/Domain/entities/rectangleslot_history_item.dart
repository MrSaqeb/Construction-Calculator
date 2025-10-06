import 'package:hive/hive.dart';

part 'rectangleslot_history_item.g.dart';

@HiveType(typeId: 43)
class RectangleWithSlotHistoryItem extends HiveObject {
  @HiveField(0)
  double a;

  @HiveField(1)
  double b;

  @HiveField(2)
  double c;

  @HiveField(3)
  double d;

  @HiveField(4)
  String unit;

  @HiveField(5)
  double area;

  @HiveField(6)
  double perimeter;

  @HiveField(7)
  DateTime savedAt;

  RectangleWithSlotHistoryItem({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.unit,
    required this.area,
    required this.perimeter,
    required this.savedAt,
  });
}
