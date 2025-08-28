import 'package:construction_calculator/Domain/entities/time_history_item.dart';
import 'package:construction_calculator/features/History/Data/time_history_local_data.dart';

abstract class ITimeHistoryRepository {
  Future<void> add(TimeHistoryItem item);
  List<TimeHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class TimeHistoryRepository implements ITimeHistoryRepository {
  final TimeHistoryLocalDataSource local;

  TimeHistoryRepository(this.local);

  @override
  Future<void> add(TimeHistoryItem item) => local.add(item);

  @override
  List<TimeHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
