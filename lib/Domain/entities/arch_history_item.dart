import 'package:hive/hive.dart';

part 'arch_history_item.g.dart';

@HiveType(typeId: 42)
class ArchHistoryItem extends HiveObject {
  @HiveField(0)
  double length;

  @HiveField(1)
  double height;

  @HiveField(2)
  String unit;

  @HiveField(3)
  double area;

  @HiveField(4)
  double perimeter;

  @HiveField(5)
  DateTime savedAt;

  ArchHistoryItem({
    required this.length,
    required this.height,
    required this.unit,
    required this.area,
    required this.perimeter,
    required this.savedAt,
  });
}
