import 'package:construction_calculator/Domain/entities/pressure_history_item.dart';
import 'package:hive/hive.dart';

class PressureHistoryLocalData {
  final Box<PressureHistoryItem> box;

  PressureHistoryLocalData(this.box);

  Future<void> add(PressureHistoryItem item) async => await box.add(item);

  List<PressureHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
