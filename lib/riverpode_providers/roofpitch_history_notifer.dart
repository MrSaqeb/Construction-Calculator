import 'package:construction_calculator/Domain/entities/roof_pitch_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../Core/Hive/hive_box.dart';

/// StateNotifier for Roof Pitch History
class RoofPitchHistoryNotifier
    extends StateNotifier<List<RoofPitchHistoryItem>> {
  RoofPitchHistoryNotifier() : super([]) {
    _loadHistory();
  }

  /// Load existing history from Hive
  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.roofPitchHistory)) {
      await Hive.openBox<RoofPitchHistoryItem>(HiveBoxes.roofPitchHistory);
    }
    final box = Hive.box<RoofPitchHistoryItem>(HiveBoxes.roofPitchHistory);
    state = box.values.toList();
  }

  /// Add new Roof Pitch history item
  Future<void> add(RoofPitchHistoryItem item) async {
    try {
      final box = Hive.box<RoofPitchHistoryItem>(HiveBoxes.roofPitchHistory);

      // Duplicate check (optional)
      final exists = box.values.any(
        (i) =>
            i.heightM == item.heightM &&
            i.heightCM == item.heightCM &&
            i.heightFT == item.heightFT &&
            i.heightIN == item.heightIN &&
            i.widthM == item.widthM &&
            i.widthCM == item.widthCM &&
            i.widthFT == item.widthFT &&
            i.widthIN == item.widthIN &&
            i.unit == item.unit,
      );
      if (exists) return;

      await box.add(item);

      final newList = [...state, item];
      state = newList;
    } catch (e) {
      // optional: log error
    }
  }

  /// Delete history item by index
  Future<void> delete(int index) async {
    try {
      final box = Hive.box<RoofPitchHistoryItem>(HiveBoxes.roofPitchHistory);
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
      final box = Hive.box<RoofPitchHistoryItem>(HiveBoxes.roofPitchHistory);
      await box.clear();
      state = [];
    } catch (e) {
      // optional: log error
    }
  }
}

/// Riverpod provider
final roofPitchHistoryProvider =
    StateNotifierProvider<RoofPitchHistoryNotifier, List<RoofPitchHistoryItem>>(
      (ref) => RoofPitchHistoryNotifier(),
    );
