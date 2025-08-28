import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../Core/Hive/hive_box.dart';
import '../Domain/entities/stair_history_item.dart';

final stairHistoryProvider =
    StateNotifierProvider<StairHistoryNotifier, List<StairHistoryItem>>((ref) {
      return StairHistoryNotifier();
    });

class StairHistoryNotifier extends StateNotifier<List<StairHistoryItem>> {
  StairHistoryNotifier() : super([]) {
    _loadHistory();
  }

  // Load existing history from Hive
  Future<void> _loadHistory() async {
    if (Hive.isBoxOpen(HiveBoxes.stairCaseHistory)) {
      final box = Hive.box<StairHistoryItem>(HiveBoxes.stairCaseHistory);
      state = box.values.toList();
    }
  }

  // Add new history item
  Future<void> addStair(StairHistoryItem item) async {
    if (Hive.isBoxOpen(HiveBoxes.stairCaseHistory)) {
      final box = Hive.box<StairHistoryItem>(HiveBoxes.stairCaseHistory);
      await box.add(item);

      // Update state
      state = [...state, item];
    }
  }

  // Delete single item
  Future<void> deleteStair(int index) async {
    if (Hive.isBoxOpen(HiveBoxes.stairCaseHistory)) {
      final box = Hive.box<StairHistoryItem>(HiveBoxes.stairCaseHistory);
      await box.deleteAt(index);
      state = List.from(state)..removeAt(index);
    }
  }

  // Clear all history
  Future<void> clearHistory() async {
    if (Hive.isBoxOpen(HiveBoxes.stairCaseHistory)) {
      final box = Hive.box<StairHistoryItem>(HiveBoxes.stairCaseHistory);
      await box.clear();
      state = [];
    }
  }
}
