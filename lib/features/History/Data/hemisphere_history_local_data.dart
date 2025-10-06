import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/hemisphere_history_item.dart';

class HemisphereHistoryLocalDataSource {
  final Box<HemisphereHistoryItem> box;

  HemisphereHistoryLocalDataSource(this.box);

  Future<void> add(HemisphereHistoryItem item) async => await box.add(item);

  List<HemisphereHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
