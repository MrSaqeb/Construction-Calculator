import 'package:construction_calculator/Domain/entities/wood_frame_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';

/// ✅ StateNotifier for Wood Framing History
class WoodFrameHistoryNotifier
    extends StateNotifier<List<WoodFrameHistoryItem>> {
  WoodFrameHistoryNotifier() : super([]) {
    _loadHistory();
  }

  /// Load existing history from Hive
  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.woodFrameHistory)) {
      await Hive.openBox<WoodFrameHistoryItem>(HiveBoxes.woodFrameHistory);
    }
    final box = Hive.box<WoodFrameHistoryItem>(HiveBoxes.woodFrameHistory);
    state = box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Add new Wood Framing history item
  Future<void> add(WoodFrameHistoryItem item) async {
    try {
      final box = Hive.box<WoodFrameHistoryItem>(HiveBoxes.woodFrameHistory);

      // ✅ Duplicate check based on all fields
      final exists = box.values.any(
        (i) =>
            i.length == item.length &&
            i.width == item.width &&
            i.depth == item.depth &&
            i.volume == item.volume &&
            i.unit == item.unit &&
            i.date == item.date,
      );
      if (exists) return;

      await box.add(item);

      final newList = [...state, item]
        ..sort((a, b) => b.date.compareTo(a.date));
      state = newList;
    } catch (e) {
      // Optional: log error
    }
  }

  /// Delete history item
  Future<void> delete(int index) async {
    try {
      final box = Hive.box<WoodFrameHistoryItem>(HiveBoxes.woodFrameHistory);
      await box.deleteAt(index);

      final newList = [...state]..removeAt(index);
      newList.sort((a, b) => b.date.compareTo(a.date));
      state = newList;
    } catch (e) {
      // Optional: log error
    }
  }

  /// Clear all history
  Future<void> clear() async {
    try {
      final box = Hive.box<WoodFrameHistoryItem>(HiveBoxes.woodFrameHistory);
      await box.clear();
      state = [];
    } catch (e) {
      // Optional: log error
    }
  }
}

/// ✅ Riverpod provider
final woodFrameHistoryProvider =
    StateNotifierProvider<WoodFrameHistoryNotifier, List<WoodFrameHistoryItem>>(
      (ref) => WoodFrameHistoryNotifier(),
    );
