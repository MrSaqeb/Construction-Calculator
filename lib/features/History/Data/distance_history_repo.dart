import 'package:construction_calculator/Domain/entities/distance_history_item.dart';
import 'package:construction_calculator/features/History/Data/distance_history_local_data.dart';

class DistanceHistoryRepo {
  final DistanceHistoryLocalData localDataSource;

  DistanceHistoryRepo(this.localDataSource);

  /// sari history list wapas karega
  List<DistanceHistoryItem> getHistory() => localDataSource.getHistory();

  /// naya item add karega
  Future<void> addHistory(DistanceHistoryItem item) =>
      localDataSource.addHistory(item);

  /// puri history clear karega
  Future<void> clearHistory() => localDataSource.clearHistory();

  /// ek specific item delete karega (index based)
  Future<void> deleteHistoryItem(int index) =>
      localDataSource.deleteHistoryItem(index);
}
