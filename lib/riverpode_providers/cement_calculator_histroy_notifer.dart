import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/cement_history_item.dart';

class CementCalculatorHistoryNotifier
    extends StateNotifier<List<CementHistoryItem>> {
  final Box<CementHistoryItem> box;

  CementCalculatorHistoryNotifier(this.box) : super(box.values.toList());

  void addHistory(CementHistoryItem item) {
    box.add(item);
    state = box.values.toList();
  }

  void deleteHistory(int index) {
    if (index >= 0 && index < state.length) {
      box.deleteAt(index);
      state = box.values.toList();
    }
  }

  void clearHistory() {
    box.clear();
    state = [];
  }
}

/// Provider
final cementCalculatorHistoryProvider =
    StateNotifierProvider<
      CementCalculatorHistoryNotifier,
      List<CementHistoryItem>
    >((ref) {
      final box = Hive.box<CementHistoryItem>(HiveBoxes.cementHistory);
      return CementCalculatorHistoryNotifier(box);
    });
