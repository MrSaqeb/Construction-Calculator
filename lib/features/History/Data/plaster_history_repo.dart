import 'package:construction_calculator/Domain/entities/plaster_history_item.dart';
import 'package:construction_calculator/features/History/Data/plaster_history_local_data.dart';

class PlasterHistoryRepository {
  final PlasterHistoryLocalDataSource localDataSource;
  PlasterHistoryRepository(this.localDataSource);

  List<PlasterHistoryItem> getHistory() => localDataSource.getHistory();

  Future<void> addHistory(PlasterHistoryItem item) =>
      localDataSource.addHistory(item);

  Future<void> clearHistory() => localDataSource.clearHistory();

  Future<void> deleteHistoryItem(PlasterHistoryItem item) =>
      localDataSource.deleteHistoryItem(item);
}
