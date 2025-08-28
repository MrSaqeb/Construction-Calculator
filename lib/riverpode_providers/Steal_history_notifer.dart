import 'package:construction_calculator/Domain/entities/steal_we_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';

class StealWeightHistoryNotifier extends StateNotifier<List<StealHistoryItem>> {
  final Box<StealHistoryItem> box;

  StealWeightHistoryNotifier(this.box) : super(box.values.toList());

  // Add a new steel weight history item
  void addHistory(StealHistoryItem item) {
    box.add(item);
    state = box.values.toList();
  }

  // Delete history item by index
  void deleteHistory(int index) {
    if (index >= 0 && index < state.length) {
      box.deleteAt(index);
      state = box.values.toList();
    }
  }

  // Clear all history
  void clearHistory() {
    box.clear();
    state = [];
  }
}

// Riverpod provider
final stealWeightHistoryProvider =
    StateNotifierProvider<StealWeightHistoryNotifier, List<StealHistoryItem>>((
      ref,
    ) {
      final box = Hive.box<StealHistoryItem>(HiveBoxes.stealWeightHistory);
      return StealWeightHistoryNotifier(box);
    });
