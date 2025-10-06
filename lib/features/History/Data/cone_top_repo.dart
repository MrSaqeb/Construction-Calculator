import 'package:construction_calculator/Domain/entities/cone_top_history_item.dart';
import 'package:construction_calculator/features/History/Data/cone_top_loca_data.dart';

class ConeTopRepository {
  final ConeTopLocalDataSource localDataSource;

  ConeTopRepository(this.localDataSource);

  List<ConeTopHistoryItem> getHistory() => localDataSource.getAll();

  Future<void> addHistory(ConeTopHistoryItem item) => localDataSource.add(item);

  Future<void> deleteHistoryItem(int index) => localDataSource.delete(index);

  Future<void> clearHistory() => localDataSource.clear();
}
