import 'package:construction_calculator/Domain/entities/construction_cost_history_item.dart';
import 'package:construction_calculator/features/History/Data/construction_cost_history_local_data_source.dart';

class ConstructionCostHistoryRepository {
  final ConstructionCostHistoryLocalDataSource localDataSource;
  ConstructionCostHistoryRepository(this.localDataSource);

  List<ConstructionCostHistoryItem> getHistory() =>
      localDataSource.getHistory();
  Future<void> addHistory(ConstructionCostHistoryItem item) =>
      localDataSource.addHistory(item);
  Future<void> clearHistory() => localDataSource.clearHistory();
  Future<void> deleteHistoryItem(ConstructionCostHistoryItem item) =>
      localDataSource.deleteHistoryItem(item);
}
