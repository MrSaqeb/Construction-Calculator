import 'package:construction_calculator/Domain/entities/brick_history_item.dart';
import 'package:construction_calculator/features/History/Data/brick_history_local_data.dart';

class BrickHistoryRepository {
  final BrickHistoryLocalDataSource localDataSource;
  BrickHistoryRepository(this.localDataSource);

  List<BrickHistoryItem> getHistory() => localDataSource.getHistory();
  Future<void> addHistory(BrickHistoryItem item) =>
      localDataSource.addHistory(item);
  Future<void> clearHistory() => localDataSource.clearHistory();
  Future<void> deleteHistoryItem(BrickHistoryItem item) =>
      localDataSource.deleteHistoryItem(item);
}
