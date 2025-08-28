import 'package:hive/hive.dart';

part 'plaster_history_item.g.dart';

@HiveType(typeId: 4)
class PlasterHistoryItem extends HiveObject {
  @HiveField(0)
  final String lenM;
  @HiveField(1)
  final String lenCM;
  @HiveField(2)
  final String lenFT;
  @HiveField(3)
  final String lenIN;

  @HiveField(4)
  final String widthM;
  @HiveField(5)
  final String widthCM;
  @HiveField(6)
  final String widthFT;
  @HiveField(7)
  final String widthIN;

  @HiveField(8)
  final String grade;

  @HiveField(9)
  final double area; // ✅ ek hi field area ke liye

  @HiveField(10)
  final double cementBags;

  @HiveField(11)
  final double sandCft;

  @HiveField(12)
  final String unit; // m² ya ft² dikhane ke liye

  PlasterHistoryItem({
    required this.lenM,
    required this.lenCM,
    required this.lenFT,
    required this.lenIN,
    required this.widthM,
    required this.widthCM,
    required this.widthFT,
    required this.widthIN,
    required this.grade,
    required this.area,
    required this.cementBags,
    required this.sandCft,
    required this.unit,
  });
}
