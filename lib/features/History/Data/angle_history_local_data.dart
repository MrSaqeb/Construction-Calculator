import 'package:construction_calculator/Domain/entities/angle_history_item.dart';
import 'package:hive/hive.dart';

class AngleHistoryLocalData {
  final Box<AngleHistoryItem> box;

  AngleHistoryLocalData(this.box);

  Future<void> add(AngleHistoryItem item) async => await box.add(item);

  List<AngleHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
