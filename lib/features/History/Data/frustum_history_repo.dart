import 'package:construction_calculator/Domain/entities/frustum_history_item.dart';
import 'package:construction_calculator/features/History/Data/frustum_local_data.dart';

class FrustumRepository {
  final FrustumLocalDataSource localDataSource;

  FrustumRepository(this.localDataSource);

  List<FrustumHistoryItem> getHistory() => localDataSource.getAll();

  Future<void> addHistory(FrustumHistoryItem item) => localDataSource.add(item);

  Future<void> deleteHistoryItem(int index) => localDataSource.delete(index);

  Future<void> clearHistory() => localDataSource.clear();
}
