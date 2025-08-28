
import 'package:construction_calculator/Domain/entities/wood_frame_history_item.dart';
import 'package:construction_calculator/features/History/Data/wood_frame_history_local_data.dart';

class WoodFrameRepository {
  final WoodFrameLocalDataSource localDataSource;

  WoodFrameRepository(this.localDataSource);

  /// Get all history items
  List<WoodFrameHistoryItem> getHistory() => localDataSource.getHistory();

  /// Add a new history item
  Future<void> addHistory(WoodFrameHistoryItem item) =>
      localDataSource.addHistory(item);

  /// Delete a specific history item
  Future<void> deleteHistoryItem(WoodFrameHistoryItem item) =>
      localDataSource.deleteHistoryItem(item);

  /// Clear all history
  Future<void> clearHistory() => localDataSource.clearHistory();
}
