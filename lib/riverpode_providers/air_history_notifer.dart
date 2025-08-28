import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/air_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// ✅ StateNotifier for AC History
class AcHistoryNotifier extends StateNotifier<List<AirHistoryItem>> {
  AcHistoryNotifier() : super([]) {
    _loadHistory();
  }

  /// Load existing history from Hive
  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.acHistory)) {
      await Hive.openBox<AirHistoryItem>(HiveBoxes.acHistory);
    }
    final box = Hive.box<AirHistoryItem>(HiveBoxes.acHistory);
    state = box.values.toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  /// Add new AC history item
  Future<void> add(AirHistoryItem item) async {
    try {
      final box = Hive.box<AirHistoryItem>(HiveBoxes.acHistory);

      // ✅ Duplicate check (optional)
      final exists = box.values.any(
        (i) =>
            i.lengthFt == item.lengthFt &&
            i.lengthIn == item.lengthIn &&
            i.breadthFt == item.breadthFt &&
            i.breadthIn == item.breadthIn &&
            i.heightFt == item.heightFt &&
            i.heightIn == item.heightIn &&
            i.persons == item.persons &&
            i.maxTempC == item.maxTempC &&
            i.tons == item.tons,
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
      final box = Hive.box<AirHistoryItem>(HiveBoxes.acHistory);
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
      final box = Hive.box<AirHistoryItem>(HiveBoxes.acHistory);
      await box.clear();
      state = [];
    } catch (e) {
      // optional: log error
    }
  }
}

/// ✅ Riverpod provider
final acHistoryProvider =
    StateNotifierProvider<AcHistoryNotifier, List<AirHistoryItem>>(
      (ref) => AcHistoryNotifier(),
    );
