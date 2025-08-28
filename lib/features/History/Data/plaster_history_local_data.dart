import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/plaster_history_item.dart';

class PlasterHistoryLocalDataSource {
  Box<PlasterHistoryItem> get box =>
      Hive.box<PlasterHistoryItem>(HiveBoxes.plasterHistory);

  List<PlasterHistoryItem> getHistory() => box.values.toList();

  Future<void> addHistory(PlasterHistoryItem item) async {
    await box.add(item);
  }

  Future<void> clearHistory() async {
    await box.clear();
  }

  Future<void> deleteHistoryItem(PlasterHistoryItem item) async {
    await item.delete();
  }
}
