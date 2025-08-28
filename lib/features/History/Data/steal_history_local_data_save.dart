import 'package:construction_calculator/Domain/entities/steal_we_history_item.dart';

import 'package:hive/hive.dart';

class SteelHistoryLocalDataSource {
  final Box<StealHistoryItem> box;

  SteelHistoryLocalDataSource(this.box);

  Future<void> add(StealHistoryItem item) async {
    await box.add(item);
  }

  List<StealHistoryItem> getAll() {
    return box.values.toList();
  }

  Future<void> delete(int index) async {
    await box.deleteAt(index);
  }

  Future<void> clear() async {
    await box.clear();
  }
}
