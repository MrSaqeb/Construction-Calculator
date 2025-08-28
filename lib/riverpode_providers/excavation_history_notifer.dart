import 'package:construction_calculator/Domain/entities/excavation_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../Core/Hive/hive_box.dart';

/// StateNotifier for Excavation History
class ExcavationHistoryNotifier
    extends StateNotifier<List<ExcavationHistoryItem>> {
  ExcavationHistoryNotifier() : super([]) {
    _loadHistory();
  }

  /// Load existing history from Hive
  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.excavationHistory)) {
      await Hive.openBox<ExcavationHistoryItem>(HiveBoxes.excavationHistory);
    }
    final box = Hive.box<ExcavationHistoryItem>(HiveBoxes.excavationHistory);
    state = box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Add new Excavation history item
  Future<void> add(ExcavationHistoryItem item) async {
    try {
      final box = Hive.box<ExcavationHistoryItem>(HiveBoxes.excavationHistory);

      // Duplicate check (optional)
      final exists = box.values.any(
        (i) =>
            i.length == item.length &&
            i.width == item.width &&
            i.depth == item.depth &&
            i.volume == item.volume &&
            i.unit == item.unit,
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

  /// Delete history item by index
  Future<void> delete(int index) async {
    try {
      final box = Hive.box<ExcavationHistoryItem>(HiveBoxes.excavationHistory);
      await box.deleteAt(index);
      final newList = [...state]..removeAt(index);
      state = newList;
    } catch (e) {
      // optional: log error
    }
  }

  /// Clear all history
  Future<void> clear() async {
    try {
      final box = Hive.box<ExcavationHistoryItem>(HiveBoxes.excavationHistory);
      await box.clear();
      state = [];
    } catch (e) {
      // optional: log error
    }
  }
}

/// Riverpod provider
final excavationHistoryProvider =
    StateNotifierProvider<
      ExcavationHistoryNotifier,
      List<ExcavationHistoryItem>
    >((ref) => ExcavationHistoryNotifier());
