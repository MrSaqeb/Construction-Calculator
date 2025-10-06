import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/circle_history_item.dart';
import 'package:hive/hive.dart';

/// ✅ Local data source for Circle History (Hive)
class CircleHistoryLocalDataSource {
  Future<Box<CircleHistoryItem>> _openBox() async {
    if (!Hive.isBoxOpen(HiveBoxes.circleHistory)) {
      await Hive.openBox<CircleHistoryItem>(HiveBoxes.circleHistory);
    }
    return Hive.box<CircleHistoryItem>(HiveBoxes.circleHistory);
  }

  Future<List<CircleHistoryItem>> getAll() async {
    final box = await _openBox();
    return box.values.toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> add(CircleHistoryItem item) async {
    final box = await _openBox();

    final exists = box.values.any(
      (i) =>
          i.inputValue == item.inputValue &&
          i.inputUnit == item.inputUnit &&
          i.resultType == item.resultType &&
          i.resultValue == item.resultValue,
    );

    if (!exists) {
      await box.add(item);
    }
  }

  Future<void> delete(int index) async {
    final box = await _openBox();
    await box.deleteAt(index);
  }

  Future<void> clear() async {
    final box = await _openBox();
    await box.clear();
  }
}
