import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/cement_history_item.dart';

class CementHistoryLocalDataSource {
  Box<CementHistoryItem> get box =>
      Hive.box<CementHistoryItem>(HiveBoxes.cementHistory);

  // Get all cement history items
  List<CementHistoryItem> getHistory() => box.values.toList();

  // Add new item
  Future<void> addHistory(CementHistoryItem item) async {
    await box.add(item);
  }

  // Clear all items
  Future<void> clearHistory() async {
    await box.clear();
  }

  // Delete a single item
  Future<void> deleteHistoryItem(CementHistoryItem item) async {
     await item.delete();
  }
}
