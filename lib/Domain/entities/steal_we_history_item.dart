import 'package:hive/hive.dart';

part 'steal_we_history_item.g.dart';

@HiveType(typeId: 25)
class StealHistoryItem extends HiveObject {
  @HiveField(0)
  double diameter;

  @HiveField(1)
  double length;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  double volume;

  @HiveField(4)
  DateTime savedAt;

  StealHistoryItem({
    required this.diameter,
    required this.length,
    required this.quantity,
    required this.volume,
    required this.savedAt,
  });
}
