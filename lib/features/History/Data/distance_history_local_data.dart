import 'package:construction_calculator/Domain/entities/distance_history_item.dart';
import 'package:hive/hive.dart';

class DistanceHistoryLocalData {
  final Box<DistanceHistoryItem> box;

  DistanceHistoryLocalData(this.box);

  Future<void> addHistory(DistanceHistoryItem item) async =>
      await box.add(item);

  List<DistanceHistoryItem> getHistory() => box.values.toList();

  Future<void> deleteHistoryItem(int index) async => await box.deleteAt(index);

  Future<void> clearHistory() async => await box.clear();
}
