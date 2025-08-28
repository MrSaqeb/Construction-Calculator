import 'package:construction_calculator/Domain/entities/water_sump_history_item.dart';
import 'package:hive/hive.dart';

class WaterSumpLocalDataSource {
  static const String boxName = 'water_sump_history';

  Future<Box<WaterSumpHistoryItem>> _openBox() async {
    return await Hive.openBox<WaterSumpHistoryItem>(boxName);
  }

  Future<void> addHistory(WaterSumpHistoryItem item) async {
    final box = await _openBox();
    await box.add(item);
  }

  List<WaterSumpHistoryItem> getHistory() {
    final box = Hive.box<WaterSumpHistoryItem>(boxName);
    return box.values.toList();
  }

  Future<void> deleteHistoryItem(WaterSumpHistoryItem item) async {
    await item.delete();
  }

  Future<void> clearHistory() async {
    final box = await _openBox();
    await box.clear();
  }
}
