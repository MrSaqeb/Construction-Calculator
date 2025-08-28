import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/plaster_history_item.dart';

class PlasterCalculatorHistoryNotifier
    extends StateNotifier<List<PlasterHistoryItem>> {
  final Box<PlasterHistoryItem> box;

  PlasterCalculatorHistoryNotifier(this.box) : super(box.values.toList());

  void addHistory(PlasterHistoryItem item) {
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
final plasterCalculatorHistoryProvider =
    StateNotifierProvider<
      PlasterCalculatorHistoryNotifier,
      List<PlasterHistoryItem>
    >((ref) {
      final box = Hive.box<PlasterHistoryItem>(HiveBoxes.plasterHistory);
      return PlasterCalculatorHistoryNotifier(box);
    });
