import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/sector_history_item.dart';

class SectorHistoryLocalDataSource {
  final Box<SectorHistoryItem> box;

  SectorHistoryLocalDataSource(this.box);

  Future<void> add(SectorHistoryItem item) async => await box.add(item);

  List<SectorHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
