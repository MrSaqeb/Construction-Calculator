import 'package:construction_calculator/Domain/entities/speed_history_item.dart';
import 'package:hive/hive.dart';

class SpeedHistoryLocalData {
  final Box<SpeedHistoryItem> box;

  SpeedHistoryLocalData(this.box);

  Future<void> add(SpeedHistoryItem item) async => await box.add(item);

  List<SpeedHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
