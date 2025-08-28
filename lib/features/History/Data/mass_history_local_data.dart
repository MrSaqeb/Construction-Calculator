import 'package:construction_calculator/Domain/entities/mass_history_item.dart';
import 'package:hive/hive.dart';

class MassHistoryLocalDataSource {
  final Box<MassHistoryItem> box;

  MassHistoryLocalDataSource(this.box);

  Future<void> add(MassHistoryItem item) async => await box.add(item);

  List<MassHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
