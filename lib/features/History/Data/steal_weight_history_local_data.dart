import 'package:construction_calculator/Domain/entities/steal_weight_history_item.dart';
import 'package:hive/hive.dart';

class StealHistoryLocalDataSource {
  final Box<StealWeightHistory> box;

  StealHistoryLocalDataSource(this.box);

  Future<void> add(StealWeightHistory item) async => await box.add(item);

  List<StealWeightHistory> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
