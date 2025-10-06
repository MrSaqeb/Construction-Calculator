import 'package:construction_calculator/Domain/entities/cone_bottom_history_item.dart';
import 'package:construction_calculator/features/History/Data/cone_bottom_local_data.dart';

class ConeBottomRepository {
  final ConeBottomLocalDataSource localDataSource;

  ConeBottomRepository(this.localDataSource);

  List<ConeBottomHistoryItem> getHistory() => localDataSource.getAll();

  Future<void> addHistory(ConeBottomHistoryItem item) =>
      localDataSource.add(item);

  Future<void> deleteHistoryItem(int index) => localDataSource.delete(index);

  Future<void> clearHistory() => localDataSource.clear();
}
