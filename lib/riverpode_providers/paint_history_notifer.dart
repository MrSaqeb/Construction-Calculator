import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/paint_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// ✅ StateNotifier for Paint History
class PaintHistoryNotifier extends StateNotifier<List<PaintHistoryItem>> {
  PaintHistoryNotifier() : super([]) {
    _loadHistory();
  }

  /// Load existing history from Hive
  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.paintHistory)) {
      await Hive.openBox<PaintHistoryItem>(HiveBoxes.paintHistory);
    }
    final box = Hive.box<PaintHistoryItem>(HiveBoxes.paintHistory);
    state = box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // newest first
  }

  /// Add new Paint history item
  Future<void> add(PaintHistoryItem item) async {
    try {
      final box = Hive.box<PaintHistoryItem>(HiveBoxes.paintHistory);

      // ✅ Duplicate check (optional)
      final exists = box.values.any(
        (i) =>
            i.paintArea == item.paintArea &&
            i.paintQuantity == item.paintQuantity &&
            i.primerQuantity == item.primerQuantity &&
            i.puttyQuantity == item.puttyQuantity &&
            i.unit == item.unit &&
            i.date == item.date, // optional
      );
      if (exists) return;

      await box.add(item);

      final newList = [...state, item]
        ..sort((a, b) => b.date.compareTo(a.date));
      state = newList;
    } catch (e) {
      // optional: log error
    }
  }

  /// Delete history item
  Future<void> delete(int index) async {
    try {
      final box = Hive.box<PaintHistoryItem>(HiveBoxes.paintHistory);
      await box.deleteAt(index);

      final newList = [...state]..removeAt(index);
      newList.sort((a, b) => b.date.compareTo(a.date));
      state = newList;
    } catch (e) {
      // optional: log error
    }
  }

  /// Clear all history
  Future<void> clear() async {
    try {
      final box = Hive.box<PaintHistoryItem>(HiveBoxes.paintHistory);
      await box.clear();
      state = [];
    } catch (e) {
      // optional: log error
    }
  }
}

/// ✅ Riverpod provider
final paintHistoryProvider =
    StateNotifierProvider<PaintHistoryNotifier, List<PaintHistoryItem>>(
      (ref) => PaintHistoryNotifier(),
    );
