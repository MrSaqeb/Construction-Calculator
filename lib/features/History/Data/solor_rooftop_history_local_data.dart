import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/solar_roofttop_history_item.dart';

class SolarRooftopLocalDataSource {
  Box<SolarHistoryItem> get box =>
      Hive.box<SolarHistoryItem>(HiveBoxes.solarHistory);

  /// Get all history
  List<SolarHistoryItem> getHistory() => box.values.toList();

  /// Add new history item
  Future<void> addHistory(SolarHistoryItem item) async {
    await box.add(item);
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await box.clear();
  }

  /// Delete single item
  Future<void> deleteHistoryItem(SolarHistoryItem item) async {
    await item.delete();
  }
}
