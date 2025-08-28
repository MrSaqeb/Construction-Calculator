import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/concrete_tube_history_item.dart';

class ConcreteTubeHistoryLocalDataSource {
  final Box<ConcreteTubeHistoryItem> box;

  ConcreteTubeHistoryLocalDataSource(this.box);

  Future<void> add(ConcreteTubeHistoryItem item) async => await box.add(item);

  List<ConcreteTubeHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
