import 'package:construction_calculator/Domain/entities/rectangle_history_item.dart';
import 'package:construction_calculator/features/History/Data/rectangle_history_local_data.dart';

abstract class IRectangleHistoryRepository {
  Future<void> add(RectangleHistoryItem item);
  List<RectangleHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class RectangleHistoryRepository implements IRectangleHistoryRepository {
  final RectangleHistoryLocalDataSource local;

  RectangleHistoryRepository(this.local);

  @override
  Future<void> add(RectangleHistoryItem item) => local.add(item);

  @override
  List<RectangleHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
