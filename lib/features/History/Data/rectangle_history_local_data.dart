import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/rectangle_history_item.dart';

class RectangleHistoryLocalDataSource {
  final Box<RectangleHistoryItem> box;

  RectangleHistoryLocalDataSource(this.box);

  Future<void> add(RectangleHistoryItem item) async => await box.add(item);

  List<RectangleHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
