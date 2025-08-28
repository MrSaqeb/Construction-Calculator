import 'package:construction_calculator/Domain/entities/steal_weight_history_item.dart';
import 'package:construction_calculator/features/History/Data/steal_weight_history_local_data.dart';

/// Abstract repository (interface)
abstract class IStealHistoryRepository {
  Future<void> add(StealWeightHistory item);
  List<StealWeightHistory> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

/// Implementation of Repository
class StealHistoryRepository implements IStealHistoryRepository {
  final StealHistoryLocalDataSource local;

  StealHistoryRepository(this.local);

  @override
  Future<void> add(StealWeightHistory item) => local.add(item);

  @override
  List<StealWeightHistory> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
