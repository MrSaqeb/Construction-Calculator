import 'package:construction_calculator/Domain/entities/rectangleslot_history_item.dart';
import 'package:construction_calculator/features/History/Data/rectangleslot_history_local_data.dart';

abstract class IRectangleSlotHistoryRepository {
  Future<void> add(RectangleWithSlotHistoryItem item);
  List<RectangleWithSlotHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class RectangleSlotHistoryRepository
    implements IRectangleSlotHistoryRepository {
  final RectangleSlotHistoryLocalDataSource local;

  RectangleSlotHistoryRepository(this.local);

  @override
  Future<void> add(RectangleWithSlotHistoryItem item) => local.add(item);

  @override
  List<RectangleWithSlotHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
