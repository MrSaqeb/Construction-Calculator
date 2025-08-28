import 'package:construction_calculator/Domain/entities/round_steal_history_item.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';

class RoundLocalDataSource {
  /// Hive Box getter
  Box<RoundStealHistoryItem> get box =>
      Hive.box<RoundStealHistoryItem>(HiveBoxes.roundHistory);

  /// 📌 Get all history
  List<RoundStealHistoryItem> getHistory() => box.values.toList();

  /// 📌 Add new history item
  Future<void> addHistory(RoundStealHistoryItem item) async {
    await box.add(item);
  }

  /// 📌 Clear all history
  Future<void> clearHistory() async {
    await box.clear();
  }

  /// 📌 Delete single item
  Future<void> deleteHistoryItem(RoundStealHistoryItem item) async {
    await item.delete();
  }
}
