import 'package:construction_calculator/Domain/entities/sector_history_item.dart';
import 'package:construction_calculator/features/History/Data/sector_history_local_data.dart';

abstract class ISectorHistoryRepository {
  Future<void> add(SectorHistoryItem item);
  List<SectorHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class SectorHistoryRepository implements ISectorHistoryRepository {
  final SectorHistoryLocalDataSource local;

  SectorHistoryRepository(this.local);

  @override
  Future<void> add(SectorHistoryItem item) => local.add(item);

  @override
  List<SectorHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
