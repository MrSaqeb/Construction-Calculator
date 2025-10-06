import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/lshape_history_item.dart';

class LShapeHistoryLocalDataSource {
  final Box<LShapeHistoryItem> box;

  LShapeHistoryLocalDataSource(this.box);

  Future<void> add(LShapeHistoryItem item) async => await box.add(item);

  List<LShapeHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
