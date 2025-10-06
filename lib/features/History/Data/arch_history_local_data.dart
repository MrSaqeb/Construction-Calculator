import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/arch_history_item.dart';

class ArchHistoryLocalDataSource {
  final Box<ArchHistoryItem> box;

  ArchHistoryLocalDataSource(this.box);

  Future<void> add(ArchHistoryItem item) async => await box.add(item);

  List<ArchHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
