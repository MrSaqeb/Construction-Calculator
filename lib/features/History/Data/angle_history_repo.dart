import 'package:construction_calculator/Domain/entities/angle_history_item.dart';
import 'package:construction_calculator/features/History/Data/angle_history_local_data.dart';

abstract class IAngleHistoryRepository {
  Future<void> add(AngleHistoryItem item);
  List<AngleHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class AngleHistoryRepository implements IAngleHistoryRepository {
  final AngleHistoryLocalData local;

  AngleHistoryRepository(this.local);

  @override
  Future<void> add(AngleHistoryItem item) => local.add(item);

  @override
  List<AngleHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
