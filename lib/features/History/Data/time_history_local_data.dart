import 'package:construction_calculator/Domain/entities/time_history_item.dart';
import 'package:hive/hive.dart';

class TimeHistoryLocalDataSource {
  final Box<TimeHistoryItem> box;

  TimeHistoryLocalDataSource(this.box);

  Future<void> add(TimeHistoryItem item) async => await box.add(item);

  List<TimeHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
