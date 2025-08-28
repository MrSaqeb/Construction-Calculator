import 'package:hive/hive.dart';

part 'anti_termite_history_item.g.dart';

@HiveType(typeId: 17) // ⚡ unique rakho (dono models ke alag alag hone chahiye)
class AntiTermiteHistoryItem extends HiveObject {
  @HiveField(0)
  String lenM;

  @HiveField(1)
  String lenCM;

  @HiveField(2)
  String lenFT;

  @HiveField(3)
  String lenIN;

  @HiveField(4)
  String widthM;

  @HiveField(5)
  String widthCM;

  @HiveField(6)
  String widthFT;

  @HiveField(7)
  String widthIN;

  @HiveField(8)
  double area; // ✅ calculated area

  @HiveField(9)
  double chemicalQuantity; // ✅ calculated chemical qty (ml)

  @HiveField(10)
  String unit; // Meter/CM ya Feet/Inch

  @HiveField(11)
  DateTime savedAt; // ✅ time of save

  AntiTermiteHistoryItem({
    required this.lenM,
    required this.lenCM,
    required this.lenFT,
    required this.lenIN,
    required this.widthM,
    required this.widthCM,
    required this.widthFT,
    required this.widthIN,
    required this.area,
    required this.chemicalQuantity,
    required this.unit,
    required this.savedAt,
  });
}
