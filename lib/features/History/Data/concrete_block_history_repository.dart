import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/concreteblock_history_item.dart';
import 'package:hive/hive.dart';

class ConcreteBlockHistoryLocalDataSource {
  final Box<ConcreteBlockHistory> _box = Hive.box<ConcreteBlockHistory>(
    HiveBoxes.concreteBlockHistory,
  );

  List<ConcreteBlockHistory> getHistory() => _box.values.toList();

  Future<void> addHistory(ConcreteBlockHistory item) async {
    // check duplicate if needed
    final exists = _box.values.any(
      (e) =>
          e.dateTime == item.dateTime &&
          e.unitType == item.unitType &&
          e.length == item.length &&
          e.height == item.height &&
          e.thickness == item.thickness,
    );

    if (!exists) await _box.add(item);
  }

  Future<void> deleteHistoryItem(ConcreteBlockHistory item) async {
    final key = _box.keys.firstWhere(
      (k) => _box.get(k) == item,
      orElse: () => null,
    );
    if (key != null) await _box.delete(key);
  }

  Future<void> clearHistory() async => await _box.clear();
}
