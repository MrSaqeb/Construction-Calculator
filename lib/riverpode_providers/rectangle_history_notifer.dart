import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import '../Domain/entities/rectangle_history_item.dart';

class RectangleHistoryNotifier
    extends StateNotifier<List<RectangleHistoryItem>> {
  RectangleHistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.rectangleHistory)) {
      await Hive.openBox<RectangleHistoryItem>(HiveBoxes.rectangleHistory);
    }
    final box = Hive.box<RectangleHistoryItem>(HiveBoxes.rectangleHistory);
    state = box.values.toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> add(RectangleHistoryItem item) async {
    final box = Hive.box<RectangleHistoryItem>(HiveBoxes.rectangleHistory);
    await box.add(item);
    state = [...state, item]..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> delete(int index) async {
    final box = Hive.box<RectangleHistoryItem>(HiveBoxes.rectangleHistory);
    await box.deleteAt(index);
    state = [...state]..removeAt(index);
  }

  Future<void> clear() async {
    final box = Hive.box<RectangleHistoryItem>(HiveBoxes.rectangleHistory);
    await box.clear();
    state = [];
  }
}

final rectangleHistoryProvider =
    StateNotifierProvider<RectangleHistoryNotifier, List<RectangleHistoryItem>>(
      (ref) => RectangleHistoryNotifier(),
    );
