import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/vertical_cylinder_item.dart';

/// ✅ StateNotifier for Vertical Cylinder History
class VerticalCylinderNotifier
    extends StateNotifier<List<VerticalCylinderHistoryItem>> {
  VerticalCylinderNotifier() : super([]) {
    _loadHistory();
  }

  /// Load existing history from Hive
  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.verticalHistory)) {
      await Hive.openBox<VerticalCylinderHistoryItem>(
        HiveBoxes.verticalHistory,
      );
    }
    final box = Hive.box<VerticalCylinderHistoryItem>(
      HiveBoxes.verticalHistory,
    );
    state = box.values.toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  /// Add new vertical cylinder history item
  Future<void> add(VerticalCylinderHistoryItem item) async {
    try {
      final box = Hive.box<VerticalCylinderHistoryItem>(
        HiveBoxes.verticalHistory,
      );

      // ✅ Optional duplicate check
      final exists = box.values.any(
        (i) =>
            i.diameter == item.diameter &&
            i.height == item.height &&
            i.filled == item.filled &&
            i.unit == item.unit &&
            i.totalVolume == item.totalVolume &&
            i.filledVolume == item.filledVolume,
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
      final box = Hive.box<VerticalCylinderHistoryItem>(
        HiveBoxes.verticalHistory,
      );
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
      final box = Hive.box<VerticalCylinderHistoryItem>(
        HiveBoxes.verticalHistory,
      );
      await box.clear();
      state = [];
    } catch (e) {
      // optional: log error
    }
  }
}

/// ✅ Riverpod provider
final verticalCylinderProvider =
    StateNotifierProvider<
      VerticalCylinderNotifier,
      List<VerticalCylinderHistoryItem>
    >((ref) => VerticalCylinderNotifier());
