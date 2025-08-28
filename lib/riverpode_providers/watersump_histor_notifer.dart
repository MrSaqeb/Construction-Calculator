import 'package:construction_calculator/Domain/entities/water_sump_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class WaterSumpHistoryNotifier
    extends StateNotifier<List<WaterSumpHistoryItem>> {
  final Box<WaterSumpHistoryItem> box;

  WaterSumpHistoryNotifier(this.box) : super(box.values.toList());

  // Add new history
  Future<void> addHistory(WaterSumpHistoryItem item) async {
    await box.add(item);
    state = box.values.toList();
  }

  // Delete by index
  Future<void> deleteHistory(int index) async { 
    if (index >= 0 && index < state.length) {
      await box.deleteAt(index);
      state = box.values.toList();
    }
  }

  // Clear all history
  Future<void> clearHistory() async {
    await box.clear();
    state = [];
  }
}

final waterSumpHistoryProvider =
    StateNotifierProvider<WaterSumpHistoryNotifier, List<WaterSumpHistoryItem>>(
      (ref) {
        final box = Hive.box<WaterSumpHistoryItem>('water_sump_history');
        return WaterSumpHistoryNotifier(box);
      },
    );
