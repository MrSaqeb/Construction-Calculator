import 'package:construction_calculator/Domain/entities/rectangleslot_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';

class RectangleSlotHistoryNotifier
    extends StateNotifier<List<RectangleWithSlotHistoryItem>> {
  RectangleSlotHistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.rectangleWithSlotHistory)) {
      await Hive.openBox<RectangleWithSlotHistoryItem>(
        HiveBoxes.rectangleWithSlotHistory,
      );
    }
    final box = Hive.box<RectangleWithSlotHistoryItem>(
      HiveBoxes.rectangleWithSlotHistory,
    );
    state = box.values.toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> add(RectangleWithSlotHistoryItem item) async {
    final box = Hive.box<RectangleWithSlotHistoryItem>(
      HiveBoxes.rectangleWithSlotHistory,
    );
    await box.add(item);
    state = [...state, item]..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> delete(int index) async {
    final box = Hive.box<RectangleWithSlotHistoryItem>(
      HiveBoxes.rectangleWithSlotHistory,
    );
    await box.deleteAt(index);
    state = [...state]..removeAt(index);
  }

  Future<void> clear() async {
    final box = Hive.box<RectangleWithSlotHistoryItem>(
      HiveBoxes.rectangleWithSlotHistory,
    );
    await box.clear();
    state = [];
  }
}

final rectangleSlotHistoryProvider =
    StateNotifierProvider<
      RectangleSlotHistoryNotifier,
      List<RectangleWithSlotHistoryItem>
    >((ref) => RectangleSlotHistoryNotifier());
