import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/round_column_history_item.dart';

class RoundColumnLocalDataSource {
  /// Hive Box getter
  Box<RoundColumnHistoryItem> get box =>
      Hive.box<RoundColumnHistoryItem>(HiveBoxes.roundColumnHistory);

  /// 📌 Get all history
  List<RoundColumnHistoryItem> getHistory() => box.values.toList();

  /// 📌 Add new history item
  Future<void> addHistory(RoundColumnHistoryItem item) async {
    await box.add(item);
  }

  /// 📌 Clear all history
  Future<void> clearHistory() async {
    await box.clear();
  }

  /// 📌 Delete single item
  Future<void> deleteHistoryItem(RoundColumnHistoryItem item) async {
    await item.delete();
  }
}
