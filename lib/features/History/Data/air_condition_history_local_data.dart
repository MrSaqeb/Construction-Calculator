import 'package:construction_calculator/Domain/entities/air_history_item.dart';
import 'package:hive/hive.dart';

class AirHistoryLocalDataSource {
  final Box<AirHistoryItem> box;

  AirHistoryLocalDataSource(this.box);

  Future<void> add(AirHistoryItem item) async => await box.add(item);

  List<AirHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
