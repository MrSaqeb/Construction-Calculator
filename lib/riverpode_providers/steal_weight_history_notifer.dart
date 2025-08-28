import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/steal_weight_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// ✅ StateNotifier for Steel Weight History
class SteelWeightHistoryNotifier
    extends StateNotifier<List<StealWeightHistory>> {
  SteelWeightHistoryNotifier() : super([]) {
    _loadHistory();
  }

  late Box<StealWeightHistory> _box;
  Future<void> _loadHistory() async {
    _box = await Hive.openBox<StealWeightHistory>('steal_history');
    state = _box.values.toList();
  }

  /// Add new Steel Weight history item
  Future<void> add(StealWeightHistory item) async {
    try {
      final box = Hive.box<StealWeightHistory>(HiveBoxes.stealWeightHistory);

      // ✅ Duplicate check (optional)
      final exists = box.values.any(
        (i) =>
            i.inputVolume == item.inputVolume &&
            i.steelType == item.steelType &&
            i.calculatedWeight == item.calculatedWeight,
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
      final box = Hive.box<StealWeightHistory>(HiveBoxes.stealWeightHistory);
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
      final box = Hive.box<StealWeightHistory>(HiveBoxes.stealWeightHistory);
      await box.clear();
      state = [];
    } catch (e) {
      // optional: log error
    }
  }
}

/// ✅ Riverpod provider
final steelWeightHistoryProvider =
    StateNotifierProvider<SteelWeightHistoryNotifier, List<StealWeightHistory>>(
      (ref) => SteelWeightHistoryNotifier(),
    );
