import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/construction_cost_history_item.dart';

class ConstructionCostHistoryLocalDataSource {
  Box<ConstructionCostHistoryItem> get box =>
      Hive.box<ConstructionCostHistoryItem>(HiveBoxes.constructionCostHistory);

  List<ConstructionCostHistoryItem> getHistory() => box.values.toList();

  Future<void> addHistory(ConstructionCostHistoryItem item) async {
    await box.add(item);
  }

  Future<void> clearHistory() async {
    await box.clear();
  }

  Future<void> deleteHistoryItem(ConstructionCostHistoryItem item) async {
    await item.delete();
  }
}
