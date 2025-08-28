
import 'package:construction_calculator/Domain/entities/beam_steal_history_item.dart';
import 'package:hive/hive.dart';

class BeamSteelHistoryLocalDataSource {
  final Box<BeamStealHistoryItem> box;

  BeamSteelHistoryLocalDataSource(this.box);

  /// Add new item
  Future<void> add(BeamStealHistoryItem item) async => await box.add(item);

  /// Get all items
  List<BeamStealHistoryItem> getAll() => box.values.toList();

  /// Delete by index
  Future<void> delete(int index) async => await box.deleteAt(index);

  /// Clear all items
  Future<void> clear() async => await box.clear();
}
