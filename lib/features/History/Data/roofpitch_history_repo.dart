import 'package:construction_calculator/Domain/entities/roof_pitch_history_item.dart';
import 'package:construction_calculator/features/History/Data/roofpitch_history_local_data.dart';

class RoofPitchRepository {
  final RoofPitchLocalDataSource localDataSource;
  RoofPitchRepository(this.localDataSource);

  /// Get all history items
  List<RoofPitchHistoryItem> getHistory() => localDataSource.getHistory();

  /// Add a new history item
  Future<void> addHistory(RoofPitchHistoryItem item) =>
      localDataSource.addHistory(item);

  /// Delete a specific item
  Future<void> deleteHistoryItem(RoofPitchHistoryItem item) =>
      localDataSource.deleteHistoryItem(item);

  /// Clear all history
  Future<void> clearHistory() => localDataSource.clearHistory();
}
