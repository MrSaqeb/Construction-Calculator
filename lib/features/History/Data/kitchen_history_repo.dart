
import 'package:construction_calculator/Domain/entities/kitchen_history_item.dart';
import 'package:construction_calculator/features/History/Data/kitchen_history_local_data.dart';

class KitchenHistoryRepository {
  final KitchenHistoryLocalDataSource localDataSource;

  KitchenHistoryRepository(this.localDataSource);

  List<KitchenHistoryItem> getHistory() => localDataSource.getHistory();

  Future<void> addHistory(KitchenHistoryItem item) =>
      localDataSource.addHistory(item);

  Future<void> clearHistory() => localDataSource.clearHistory();

  Future<void> deleteHistoryItem(KitchenHistoryItem item) =>
      localDataSource.deleteHistoryItem(item);
}
