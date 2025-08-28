import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/square_bar_history_item.dart';
import 'package:hive/hive.dart';

class SquareBarLocalData {
  // Open Hive box
  static Future<Box<SquareBarHistoryItem>> openBox() async {
    return await Hive.openBox<SquareBarHistoryItem>(HiveBoxes.squareBarHistory);
  }

  // Save a history item
  static Future<void> saveHistory(SquareBarHistoryItem item) async {
    final box = await openBox();

    // Optional: Duplicate check
    final exists = box.values.any(
      (e) =>
          e.side == item.side &&
          e.length == item.length &&
          e.pieces == item.pieces &&
          e.material == item.material &&
          e.lengthUnit == item.lengthUnit &&
          e.weightUnit == item.weightUnit &&
          e.costPerKg == item.costPerKg &&
          e.weightKg == item.weightKg &&
          e.weightTons == item.weightTons &&
          e.totalCost == item.totalCost,
    );

    if (!exists) {
      await box.add(item);
    }
  }

  // Get all history items
  static Future<List<SquareBarHistoryItem>> getHistory() async {
    final box = await openBox();
    return box.values.toList();
  }

  // Delete by index
  static Future<void> deleteHistory(int index) async {
    final box = await openBox();
    if (index >= 0 && index < box.length) {
      await box.deleteAt(index);
    }
  }

  // Clear all history
  static Future<void> clearHistory() async {
    final box = await openBox();
    await box.clear();
  }
}
