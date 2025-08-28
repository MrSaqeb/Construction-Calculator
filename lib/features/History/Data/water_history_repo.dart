

import 'package:construction_calculator/Domain/entities/water_sump_history_item.dart';
import 'package:construction_calculator/features/History/Data/water_history_local_data.dart';

class WaterSumpRepository {
  final WaterSumpLocalDataSource localDataSource;
  WaterSumpRepository(this.localDataSource);

  List<WaterSumpHistoryItem> getHistory() => localDataSource.getHistory();

  Future<void> addHistory(WaterSumpHistoryItem item) =>
      localDataSource.addHistory(item);

  Future<void> deleteHistoryItem(WaterSumpHistoryItem item) =>
      localDataSource.deleteHistoryItem(item);

  Future<void> clearHistory() => localDataSource.clearHistory();
}
