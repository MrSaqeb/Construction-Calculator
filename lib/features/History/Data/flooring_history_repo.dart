import 'package:construction_calculator/Domain/entities/flooring_history_item.dart';
import 'package:construction_calculator/features/History/Data/flooring_history_local_data.dart';


class FlooringRepository {
  final FlooringLocalDataSource localDataSource;
  FlooringRepository(this.localDataSource);

  List<FlooringHistoryItem> getHistory() => localDataSource.getHistory();

  Future<void> addHistory(FlooringHistoryItem item) =>
      localDataSource.addHistory(item);

  Future<void> clearHistory() => localDataSource.clearHistory();

  Future<void> deleteHistoryItem(FlooringHistoryItem item) =>
      localDataSource.deleteHistoryItem(item);
}
