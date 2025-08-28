
import 'package:construction_calculator/Domain/entities/boundary_wall_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';

class BoundaryWallHistoryNotifier
    extends StateNotifier<List<BoundaryWallItem>> {
  final Box<BoundaryWallItem> box;

  BoundaryWallHistoryNotifier(this.box) : super(box.values.toList());

  // Add a new history item
  void addHistory(BoundaryWallItem item) {
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
final boundaryWallHistoryProvider =
    StateNotifierProvider<BoundaryWallHistoryNotifier, List<BoundaryWallItem>>((
      ref,
    ) {
      final box = Hive.box<BoundaryWallItem>(HiveBoxes.boundaryWallHistory);
      return BoundaryWallHistoryNotifier(box);
    });
