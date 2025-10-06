import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/circle_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// ✅ StateNotifier for Circle History
class CircleHistoryNotifier extends StateNotifier<List<CircleHistoryItem>> {
  CircleHistoryNotifier() : super([]) {
    _loadHistory();
  }

  /// Load existing history from Hive
  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.circleHistory)) {
      await Hive.openBox<CircleHistoryItem>(HiveBoxes.circleHistory);
    }
    final box = Hive.box<CircleHistoryItem>(HiveBoxes.circleHistory);
    state = box.values.toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  /// Add new Circle history item
  Future<void> add(CircleHistoryItem item) async {
    try {
      final box = Hive.box<CircleHistoryItem>(HiveBoxes.circleHistory);

      // ✅ Duplicate check
      final exists = box.values.any(
        (i) =>
            i.inputValue == item.inputValue &&
            i.inputUnit == item.inputUnit &&
            i.resultType == item.resultType &&
            i.resultValue == item.resultValue,
      );
      if (exists) return;

      await box.add(item);

      final newList = [...state, item]
        ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
      state = newList;
    } catch (e) {
      // optional: log error
    }
  }

  /// Delete history item
  Future<void> delete(int index) async {
    try {
      final box = Hive.box<CircleHistoryItem>(HiveBoxes.circleHistory);
      await box.deleteAt(index);

      final newList = [...state]..removeAt(index);
      newList.sort((a, b) => b.savedAt.compareTo(a.savedAt));
      state = newList;
    } catch (e) {
      // optional: log error
    }
  }

  /// Clear all history
  Future<void> clear() async {
    try {
      final box = Hive.box<CircleHistoryItem>(HiveBoxes.circleHistory);
      await box.clear();
      state = [];
    } catch (e) {
      // optional: log error
    }
  }
}

/// ✅ Riverpod provider
final circleHistoryProvider =
    StateNotifierProvider<CircleHistoryNotifier, List<CircleHistoryItem>>(
      (ref) => CircleHistoryNotifier(),
    );
