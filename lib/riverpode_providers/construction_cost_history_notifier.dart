import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/construction_cost_history_item.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';

class ConstructionCostHistoryNotifier
    extends StateNotifier<List<ConstructionCostHistoryItem>> {
  final Box<ConstructionCostHistoryItem> box;

  ConstructionCostHistoryNotifier(this.box) : super(box.values.toList());

  void addHistory(ConstructionCostHistoryItem item) {
    box.add(item);
    state = box.values.toList();
  }

  void deleteHistory(int index) {
    box.deleteAt(index);
    state = box.values.toList();
  }

  void clearHistory() {
    box.clear();
    state = [];
  }
}

final constructionCostHistoryProvider =
    StateNotifierProvider<
      ConstructionCostHistoryNotifier,
      List<ConstructionCostHistoryItem>
    >((ref) {
      final box = Hive.box<ConstructionCostHistoryItem>(
        HiveBoxes.constructionCostHistory,
      );
      return ConstructionCostHistoryNotifier(box);
    });
