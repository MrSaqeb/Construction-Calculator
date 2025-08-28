import 'package:construction_calculator/Domain/entities/concrete_tube_history_item.dart';
import 'package:construction_calculator/features/History/Data/concrete_tube_history_local_data.dart';

/// Abstract repository (interface)
abstract class IConcreteTubeHistoryRepository {
  Future<void> add(ConcreteTubeHistoryItem item);
  List<ConcreteTubeHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

/// Implementation of Repository
class ConcreteTubeHistoryRepository implements IConcreteTubeHistoryRepository {
  final ConcreteTubeHistoryLocalDataSource local;

  ConcreteTubeHistoryRepository(this.local);

  @override
  Future<void> add(ConcreteTubeHistoryItem item) => local.add(item);

  @override
  List<ConcreteTubeHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
