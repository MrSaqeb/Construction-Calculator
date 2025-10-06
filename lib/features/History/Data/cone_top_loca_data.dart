import 'package:construction_calculator/Domain/entities/cone_top_history_item.dart';
import 'package:hive/hive.dart';

class ConeTopLocalDataSource {
  final Box<ConeTopHistoryItem> box;

  ConeTopLocalDataSource(this.box);

  Future<void> add(ConeTopHistoryItem item) async => await box.add(item);

  List<ConeTopHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
