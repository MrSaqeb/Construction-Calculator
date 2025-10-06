import 'package:construction_calculator/Domain/entities/lshape_history_item.dart';
import 'package:construction_calculator/features/History/Data/Lshape_history_local_data.dart';

abstract class ILShapeHistoryRepository {
  Future<void> add(LShapeHistoryItem item);
  List<LShapeHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class LShapeHistoryRepository implements ILShapeHistoryRepository {
  final LShapeHistoryLocalDataSource local;

  LShapeHistoryRepository(this.local);

  @override
  Future<void> add(LShapeHistoryItem item) => local.add(item);

  @override
  List<LShapeHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
