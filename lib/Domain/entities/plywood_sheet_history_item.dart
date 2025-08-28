import 'package:hive/hive.dart';

part 'plywood_sheet_history_item.g.dart'; // generated file

@HiveType(typeId: 16) // ⚡ Unique typeId rakho (har model ka alag hoga)
class PlywoodSheetItem extends HiveObject {
  @HiveField(0)
  String selectedUnit;

  @HiveField(1)
  double roomLength;

  @HiveField(2)
  double roomWidth;

  @HiveField(3)
  double plyLength;

  @HiveField(4)
  double plyWidth;

  @HiveField(5)
  int totalSheets;

  @HiveField(6)
  double roomArea;

  @HiveField(7)
  double plywoodCover;

  @HiveField(8)
  DateTime savedAt;

  PlywoodSheetItem({
    required this.selectedUnit,
    required this.roomLength,
    required this.roomWidth,
    required this.plyLength,
    required this.plyWidth,
    required this.totalSheets,
    required this.roomArea,
    required this.plywoodCover,
    required this.savedAt,
  });
}
