import 'package:construction_calculator/Domain/entities/rectangleslot_history_item.dart';
import 'package:hive/hive.dart';

class RectangleSlotHistoryLocalDataSource {
  final Box<RectangleWithSlotHistoryItem> box;

  RectangleSlotHistoryLocalDataSource(this.box);

  Future<void> add(RectangleWithSlotHistoryItem item) async =>
      await box.add(item);

  List<RectangleWithSlotHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
