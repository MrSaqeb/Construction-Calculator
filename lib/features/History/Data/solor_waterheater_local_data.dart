import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/solor_waterheater_history_item.dart';
import 'package:hive/hive.dart';

class SolarWaterLocalData {
  static Future<Box<SolarWaterHistoryItem>> openBox() async {
    return await Hive.openBox<SolarWaterHistoryItem>(
      HiveBoxes.solarWaterHeaterHistory,
    );
  }

  // Save a history item
  static Future<void> saveHistory(SolarWaterHistoryItem item) async {
    final box = await openBox();

    // Optional: Duplicate check
    final exists = box.values.any(
      (e) =>
          e.inputConsumption == item.inputConsumption &&
          e.totalCapacity == item.totalCapacity &&
          e.timestamp == item.timestamp,
    );

    if (!exists) {
      await box.add(item);
    }
  }

  // Get all history items
  static Future<List<SolarWaterHistoryItem>> getHistory() async {
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
