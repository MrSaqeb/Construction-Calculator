import 'package:construction_calculator/Domain/entities/air_history_item.dart';
import 'package:construction_calculator/features/History/Data/air_condition_history_local_data.dart';

/// Abstract repository (interface)
abstract class IAirHistoryRepository {
  Future<void> add(AirHistoryItem item);
  List<AirHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

/// Implementation of Repository
class AirHistoryRepository implements IAirHistoryRepository {
  final AirHistoryLocalDataSource local;

  AirHistoryRepository(this.local);

  @override
  Future<void> add(AirHistoryItem item) => local.add(item);

  @override
  List<AirHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
