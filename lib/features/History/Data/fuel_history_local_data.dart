import 'package:construction_calculator/Domain/entities/fuel_history_item.dart';
import 'package:hive/hive.dart';

class FuelHistoryLocalData {
  final Box<FuelHistoryItem> box;

  FuelHistoryLocalData(this.box);

  Future<void> add(FuelHistoryItem item) async => await box.add(item);

  List<FuelHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
