import 'package:construction_calculator/Domain/entities/fuel_history_item.dart';
import 'package:construction_calculator/features/History/Data/fuel_history_local_data.dart';

abstract class IFuelHistoryRepository {
  Future<void> add(FuelHistoryItem item);
  List<FuelHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class FuelHistoryRepository implements IFuelHistoryRepository {
  final FuelHistoryLocalData local;

  FuelHistoryRepository(this.local);

  @override
  Future<void> add(FuelHistoryItem item) => local.add(item);

  @override
  List<FuelHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
