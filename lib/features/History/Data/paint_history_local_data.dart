import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/paint_history_item.dart';
import 'package:hive/hive.dart';

class PaintLocalDataSource {
  /// Open Hive box (if not already open)
  Future<Box<PaintHistoryItem>> _openBox() async {
    if (!Hive.isBoxOpen(HiveBoxes.paintHistory)) {
      await Hive.openBox<PaintHistoryItem>(HiveBoxes.paintHistory);
    }
    return Hive.box<PaintHistoryItem>(HiveBoxes.paintHistory);
  }

  /// Add new paint history
  Future<void> addPaintHistory(PaintHistoryItem item) async {
    final box = await _openBox();

    // Duplicate check (optional)
    final exists = box.values.any(
      (i) =>
          i.paintArea == item.paintArea &&
          i.paintQuantity == item.paintQuantity &&
          i.primerQuantity == item.primerQuantity &&
          i.puttyQuantity == item.puttyQuantity &&
          i.unit == item.unit &&
          i.date == item.date,
    );
    if (!exists) {
      await box.add(item);
    }
  }

  /// Get all paint history
  Future<List<PaintHistoryItem>> getAllHistory() async {
    final box = await _openBox();
    final list = box.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// Delete one item
  Future<void> delete(int index) async {
    final box = await _openBox();
    await box.deleteAt(index);
  }

  /// Clear all history
  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
