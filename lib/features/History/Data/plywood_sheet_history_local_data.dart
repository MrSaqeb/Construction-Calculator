import 'package:construction_calculator/Domain/entities/plywood_sheet_history_item.dart';
import 'package:hive/hive.dart';

class PlywoodSheetLocalDataSource {
  static const String boxName = 'plywood_sheets';

  Future<void> addSheet(PlywoodSheetItem item) async {
    final box = Hive.box<PlywoodSheetItem>(boxName);
    await box.add(item);
  }

  List<PlywoodSheetItem> getAllSheets() {
    final box = Hive.box<PlywoodSheetItem>(boxName);
    return box.values.toList();
  }

  Future<void> deleteSheet(int index) async {
    final box = Hive.box<PlywoodSheetItem>(boxName);
    await box.deleteAt(index);
  }

  Future<void> clearAll() async {
    final box = Hive.box<PlywoodSheetItem>(boxName);
    await box.clear();
  }
}
