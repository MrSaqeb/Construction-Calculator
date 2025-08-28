import 'package:construction_calculator/Domain/entities/pressure_history_item.dart';
import 'package:construction_calculator/features/History/Data/pressure_history_local_data.dart';

abstract class IPressureHistoryRepository {
  Future<void> add(PressureHistoryItem item);
  List<PressureHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class PressureHistoryRepository implements IPressureHistoryRepository {
  final PressureHistoryLocalData local;

  PressureHistoryRepository(this.local);

  @override
  Future<void> add(PressureHistoryItem item) => local.add(item);

  @override
  List<PressureHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
