

import 'package:construction_calculator/Domain/entities/boundary_wall_history_item.dart';

import 'boundary_wall_local_data.dart';

class BoundaryWallRepository {
  final BoundaryWallLocalDataSource localDataSource;
  BoundaryWallRepository(this.localDataSource);

  List<BoundaryWallItem> getHistory() => localDataSource.getHistory();

  Future<void> addHistory(BoundaryWallItem item) =>
      localDataSource.addHistory(item);

  Future<void> clearHistory() => localDataSource.clearHistory();

  Future<void> deleteHistoryItem(BoundaryWallItem item) =>
      localDataSource.deleteHistoryItem(item);
}
