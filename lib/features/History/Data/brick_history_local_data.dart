import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/brick_history_item.dart';

class BrickHistoryLocalDataSource {
  Box<BrickHistoryItem> get box =>
      Hive.box<BrickHistoryItem>(HiveBoxes.brickHistory);

  List<BrickHistoryItem> getHistory() => box.values.toList();

  Future<void> addHistory(BrickHistoryItem item) async {
    await box.add(item);
  }

  Future<void> clearHistory() async {
    await box.clear();
  }

  Future<void> deleteHistoryItem(BrickHistoryItem item) async {
    await item.delete();
  }
}
