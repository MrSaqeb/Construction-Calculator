import 'package:construction_calculator/Domain/entities/topsoil_history_item.dart';
import 'package:hive/hive.dart';

class TopSoilHistoryLocalDataSource {
  final Box<TopSoilHistoryItem> box;

  TopSoilHistoryLocalDataSource(this.box);

  /// Add new Top Soil history item
  Future<void> add(TopSoilHistoryItem item) async => await box.add(item);

  /// Get all history items
  List<TopSoilHistoryItem> getAll() => box.values.toList();

  /// Delete history item by index
  Future<void> delete(int index) async => await box.deleteAt(index);

  /// Clear all history
  Future<void> clear() async => await box.clear();
}
