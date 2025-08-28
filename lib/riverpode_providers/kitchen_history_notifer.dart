import 'package:construction_calculator/Domain/entities/kitchen_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';

class KitchenHistoryNotifer
    extends StateNotifier<List<KitchenHistoryItem>> {
  final Box<KitchenHistoryItem> box;

KitchenHistoryNotifer(this.box) : super(box.values.toList());

  // Add a new history item
  void addHistory(KitchenHistoryItem item) {
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
// ignore: non_constant_identifier_names
final KitchenHistoryProvider =
    StateNotifierProvider<KitchenHistoryNotifer, List<KitchenHistoryItem>>((
      ref,
    ) {
      final box = Hive.box<KitchenHistoryItem>(HiveBoxes.kitchenHistory);
      return KitchenHistoryNotifer(box);
    });
