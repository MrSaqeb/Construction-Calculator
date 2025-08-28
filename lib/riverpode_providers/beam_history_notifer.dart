import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/beam_steal_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// ✅ StateNotifier for Beam Steel History
class BeamSteelHistoryNotifier
    extends StateNotifier<List<BeamStealHistoryItem>> {
  BeamSteelHistoryNotifier() : super([]) {
    _loadHistory();
  }

  /// Load existing history from Hive
  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.beamHistory)) {
      await Hive.openBox<BeamStealHistoryItem>(HiveBoxes.beamHistory);
    }
    final box = Hive.box<BeamStealHistoryItem>(HiveBoxes.beamHistory);
    state = box.values.toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  /// Add new Beam Steel history item
  Future<void> add(BeamStealHistoryItem item) async {
    try {
      final box = Hive.box<BeamStealHistoryItem>(HiveBoxes.beamHistory);

      // ✅ Duplicate check
      final exists = box.values.any(
        (i) =>
            i.sizeA == item.sizeA &&
            i.sizeB == item.sizeB &&
            i.sizeT == item.sizeT &&
            i.sizeS == item.sizeS &&
            i.length == item.length &&
            i.pieces == item.pieces &&
            i.material == item.material &&
            i.lengthUnit == item.lengthUnit &&
            i.weightUnit == item.weightUnit &&
            i.costPerKg == item.costPerKg &&
            i.weightKg == item.weightKg &&
            i.weightTons == item.weightTons &&
            i.totalCost == item.totalCost,
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
      final box = Hive.box<BeamStealHistoryItem>(HiveBoxes.beamHistory);
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
      final box = Hive.box<BeamStealHistoryItem>(HiveBoxes.beamHistory);
      await box.clear();
      state = [];
    } catch (e) {
      // optional: log error
    }
  }
}

/// ✅ Riverpod provider
final beamSteelHistoryProvider =
    StateNotifierProvider<BeamSteelHistoryNotifier, List<BeamStealHistoryItem>>(
      (ref) => BeamSteelHistoryNotifier(),
    );
