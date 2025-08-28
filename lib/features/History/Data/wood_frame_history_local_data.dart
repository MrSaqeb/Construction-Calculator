import 'package:construction_calculator/Domain/entities/wood_frame_history_item.dart';
import 'package:hive/hive.dart';

class WoodFrameLocalDataSource {
  final Box<WoodFrameHistoryItem> woodframeBox;

  WoodFrameLocalDataSource(this.woodframeBox);

  /// Get all history items
  List<WoodFrameHistoryItem> getHistory() {
    return woodframeBox.values.toList();
  }

  /// Add new history item
  Future<void> addHistory(WoodFrameHistoryItem item) async {
    await woodframeBox.add(item);
  }

  /// Delete a specific item
  Future<void> deleteHistoryItem(WoodFrameHistoryItem item) async {
    final key = woodframeBox.keys.firstWhere(
      (k) => woodframeBox.get(k) == item,
      orElse: () => null,
    );
    if (key != null) {
      await woodframeBox.delete(key);
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await woodframeBox.clear();
  }
}
