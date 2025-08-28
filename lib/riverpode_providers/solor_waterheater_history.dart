// file: solar_water_history_notifier.dart

import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/solor_waterheater_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class SolarWaterHistoryNotifier
    extends StateNotifier<List<SolarWaterHistoryItem>> {
  final Box<SolarWaterHistoryItem> box;

  SolarWaterHistoryNotifier(this.box) : super(box.values.toList());

  // Add new history item
  void addHistory(SolarWaterHistoryItem item) {
    box.add(item);
    state = box.values.toList();
  }

  // Delete history item by index
  void deleteHistory(int index) {
    if (index >= 0 && index < state.length) {
      box.deleteAt(index);
      state = box.values.toList();
    }
  }

  // Clear all history
  void clearHistory() {
    box.clear();
    state = [];
  }
}

// Riverpod provider
final solarWaterHistoryProvider =
    StateNotifierProvider<
      SolarWaterHistoryNotifier,
      List<SolarWaterHistoryItem>
    >((ref) {
      final box = Hive.box<SolarWaterHistoryItem>(
        HiveBoxes.solarWaterHeaterHistory,
      );
      return SolarWaterHistoryNotifier(box);
    });
