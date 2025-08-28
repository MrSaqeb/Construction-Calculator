import 'package:hive/hive.dart';

part 'kitchen_history_item.g.dart';

@HiveType(typeId: 8) // 8 number ka typeId
class KitchenHistoryItem extends HiveObject {
  @HiveField(0)
  String selectedUnit;

  @HiveField(1)
  String shape;

  @HiveField(2)
  double height;

  @HiveField(3)
  double? width; // I shape ke liye null ho sakta hai

  @HiveField(4)
  double depth;

  @HiveField(5)
  double area; // calculated area in m²

  @HiveField(6)
  DateTime savedAt;

  @HiveField(7)
  // Extra field nahi chahiye, isko temporarily placeholder rakha ja sakta hai
  String placeholder;

  KitchenHistoryItem({
    required this.selectedUnit,
    required this.shape,
    required this.height,
    this.width,
    required this.depth,
    required this.area,
    required this.savedAt,
    this.placeholder = "",
  });
}
