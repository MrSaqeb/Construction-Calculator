import 'package:hive/hive.dart';

part 'topsoil_history_item.g.dart';

@HiveType(typeId: 20)
class TopSoilHistoryItem extends HiveObject {
  @HiveField(0)
  final double length; // meters
  @HiveField(1)
  final double width; // meters
  @HiveField(2)
  final double depth; // meters
  @HiveField(3)
  final double volume; // cubic meters
  @HiveField(4)
  final DateTime savedAt;

  TopSoilHistoryItem({
    required this.length,
    required this.width,
    required this.depth,
    required this.volume,
    required this.savedAt,
  });
}
