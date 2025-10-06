import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import '../Domain/entities/lshape_history_item.dart';

class LShapeHistoryNotifier extends StateNotifier<List<LShapeHistoryItem>> {
  LShapeHistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.lShapeHistory)) {
      await Hive.openBox<LShapeHistoryItem>(HiveBoxes.lShapeHistory);
    }
    final box = Hive.box<LShapeHistoryItem>(HiveBoxes.lShapeHistory);
    state = box.values.toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> add(LShapeHistoryItem item) async {
    final box = Hive.box<LShapeHistoryItem>(HiveBoxes.lShapeHistory);
    await box.add(item);
    state = [...state, item]..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> delete(int index) async {
    final box = Hive.box<LShapeHistoryItem>(HiveBoxes.lShapeHistory);
    await box.deleteAt(index);
    state = [...state]..removeAt(index);
  }

  Future<void> clear() async {
    final box = Hive.box<LShapeHistoryItem>(HiveBoxes.lShapeHistory);
    await box.clear();
    state = [];
  }
}

final lShapeHistoryProvider =
    StateNotifierProvider<LShapeHistoryNotifier, List<LShapeHistoryItem>>(
      (ref) => LShapeHistoryNotifier(),
    );
