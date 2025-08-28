import 'package:construction_calculator/Domain/entities/roof_pitch_history_item.dart';
import 'package:hive/hive.dart';

class RoofPitchLocalDataSource {
  final Box<RoofPitchHistoryItem> roofPitchBox;

  RoofPitchLocalDataSource(this.roofPitchBox);

  /// Get all history items
  List<RoofPitchHistoryItem> getHistory() {
    return roofPitchBox.values.toList();
  }

  /// Add new history item
  Future<void> addHistory(RoofPitchHistoryItem item) async {
    await roofPitchBox.add(item);
  }

  /// Delete a specific item
  Future<void> deleteHistoryItem(RoofPitchHistoryItem item) async {
    final key = roofPitchBox.keys.firstWhere(
      (k) => roofPitchBox.get(k) == item,
      orElse: () => null,
    );
    if (key != null) {
      await roofPitchBox.delete(key);
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await roofPitchBox.clear();
  }
}
