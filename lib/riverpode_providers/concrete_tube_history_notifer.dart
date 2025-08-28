import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/concrete_tube_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// Unified provider for concrete tube history
final concreteTubeHistoryProvider =
    StateNotifierProvider<
      ConcreteTubeHistoryNotifier,
      List<ConcreteTubeHistoryItem>
    >((ref) => ConcreteTubeHistoryNotifier());

class ConcreteTubeHistoryNotifier
    extends StateNotifier<List<ConcreteTubeHistoryItem>> {
  ConcreteTubeHistoryNotifier() : super([]);

  // Load all history from Hive
  Future<void> loadHistory() async {
    final box = await Hive.openBox<ConcreteTubeHistoryItem>(
      HiveBoxes.concreteTubeHistory,
    );
    state = box.values.toList();
  }

  // Add a new history item
  Future<void> addConcreteTube(ConcreteTubeHistoryItem item) async {
    final box = await Hive.openBox<ConcreteTubeHistoryItem>(
      HiveBoxes.concreteTubeHistory,
    );

    // Check for duplicates
    final exists = box.values.any(
      (e) =>
          e.innerM == item.innerM &&
          e.innerCM == item.innerCM &&
          e.outerM == item.outerM &&
          e.outerCM == item.outerCM &&
          e.heightM == item.heightM &&
          e.heightCM == item.heightCM &&
          e.noOfTubes == item.noOfTubes &&
          e.grade == item.grade &&
          e.unit == item.unit,
    );

    if (!exists) {
      final key = await box.add(item);
      final savedItem = box.get(key);
      if (savedItem != null) {
        state = [...state, savedItem];
      }
    }
  }

  // Optionally: remove an item
  Future<void> removeConcreteTube(ConcreteTubeHistoryItem item) async {
    await item.delete(); // HiveObject delete
    state = state.where((e) => e.key != item.key).toList();
  }

  // Clear all history
  Future<void> clearHistory() async {
    final box = await Hive.openBox<ConcreteTubeHistoryItem>(
      HiveBoxes.concreteTubeHistory,
    );
    await box.clear();
    state = [];
  }
}
