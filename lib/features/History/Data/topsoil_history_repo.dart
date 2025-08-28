import 'package:construction_calculator/Domain/entities/topsoil_history_item.dart';
import 'package:construction_calculator/features/History/Data/topsoil_history_local_data.dart';

/// Abstract repository (interface)
abstract class ITopSoilHistoryRepository {
  Future<void> add(TopSoilHistoryItem item);
  List<TopSoilHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

/// Implementation of Repository
class TopSoilHistoryRepository implements ITopSoilHistoryRepository {
  final TopSoilHistoryLocalDataSource local;

  TopSoilHistoryRepository(this.local);

  @override
  Future<void> add(TopSoilHistoryItem item) => local.add(item);

  @override
  List<TopSoilHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
