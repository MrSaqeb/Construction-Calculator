import 'package:construction_calculator/Domain/entities/stair_history_item.dart';
import 'package:construction_calculator/features/History/Data/stairs_local_history_data.dart';

/// Abstract repository
abstract class IStairHistoryRepository {
  Future<void> add(StairHistoryItem item);
  List<StairHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

/// Implementation
class StairHistoryRepository implements IStairHistoryRepository {
  final StairHistoryLocalDataSource local;

  StairHistoryRepository(this.local);

  @override
  Future<void> add(StairHistoryItem item) => local.add(item);

  @override
  List<StairHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
