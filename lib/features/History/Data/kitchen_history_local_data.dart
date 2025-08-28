import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/kitchen_history_item.dart';

class KitchenHistoryLocalDataSource {
  final Box<KitchenHistoryItem> box;

  KitchenHistoryLocalDataSource(this.box);

  /// Get all saved history
  List<KitchenHistoryItem> getHistory() {
    return box.values.toList();
  }

  /// Add new history item
  Future<void> addHistory(KitchenHistoryItem item) async {
    await box.add(item);
  }

  /// Delete a specific history item
  Future<void> deleteHistoryItem(KitchenHistoryItem item) async {
    final key = item.key; // HiveObject key
    if (key != null) {
      await box.delete(key);
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await box.clear();
  }
}
