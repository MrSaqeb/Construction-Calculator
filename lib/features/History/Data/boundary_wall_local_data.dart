import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/boundary_wall_history_item.dart';
import 'package:hive/hive.dart';
class BoundaryWallLocalDataSource {
 
  Future<Box<BoundaryWallItem>> _openBox() async {
    return await Hive.openBox<BoundaryWallItem>(HiveBoxes.boundaryWallHistory);
  }

  // Get all history
  List<BoundaryWallItem> getHistory() {
    final box = Hive.box<BoundaryWallItem>(HiveBoxes.boundaryWallHistory);
    return box.values.toList().reversed.toList(); // latest first
  }

  // Add a new history item
  Future<void> addHistory(BoundaryWallItem item) async {
    final box = await _openBox();
    await box.add(item);
  }

  // Delete a specific history item
  Future<void> deleteHistoryItem(BoundaryWallItem item) async {
    await item.delete();
  }

  // Clear all history
  Future<void> clearHistory() async {
    final box = await _openBox();
    await box.clear();
  }
}
