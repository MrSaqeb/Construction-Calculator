import 'package:construction_calculator/Domain/entities/stair_history_item.dart';
import 'package:hive/hive.dart';

class StairHistoryLocalDataSource {
  final Box<StairHistoryItem> box;

  StairHistoryLocalDataSource(this.box);

  Future<void> add(StairHistoryItem item) async => await box.add(item);

  List<StairHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
