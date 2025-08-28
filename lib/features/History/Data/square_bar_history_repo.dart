import 'package:construction_calculator/Domain/entities/square_bar_history_item.dart';
import 'package:hive/hive.dart';

class SquareBarHistoryRepository {
  final Box<SquareBarHistoryItem> box;

  SquareBarHistoryRepository(this.box);

  // Add history with duplicate check
  void addHistory(SquareBarHistoryItem item) {
    final exists = box.values.any(
      (existing) =>
          existing.side == item.side &&
          existing.length == item.length &&
          existing.pieces == item.pieces &&
          existing.material == item.material &&
          existing.lengthUnit == item.lengthUnit &&
          existing.weightUnit == item.weightUnit &&
          existing.costPerKg == item.costPerKg &&
          existing.weightKg == item.weightKg &&
          existing.weightTons == item.weightTons &&
          existing.totalCost == item.totalCost,
    );

    if (!exists) {
      box.add(item);
    }
  }

  // Delete history by index
  void deleteHistory(int index) {
    if (index >= 0 && index < box.length) {
      box.deleteAt(index);
    }
  }

  // Clear all history
  void clearHistory() {
    box.clear();
  }

  // Get all items
  List<SquareBarHistoryItem> getAllHistory() {
    return box.values.toList();
  }
}
