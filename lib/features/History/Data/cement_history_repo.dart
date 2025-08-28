import 'package:construction_calculator/Domain/entities/cement_history_item.dart';
import 'package:construction_calculator/features/History/Data/cement_history_local_data.dart';

class CementHistoryRepository {
  final CementHistoryLocalDataSource localDataSource;
  CementHistoryRepository(this.localDataSource);

  List<CementHistoryItem> getHistory() => localDataSource.getHistory();

  Future<void> addHistory(CementHistoryItem item) =>
      localDataSource.addHistory(item);

  Future<void> clearHistory() => localDataSource.clearHistory();

  Future<void> deleteHistoryItem(CementHistoryItem item) =>
      localDataSource.deleteHistoryItem(item);
}
