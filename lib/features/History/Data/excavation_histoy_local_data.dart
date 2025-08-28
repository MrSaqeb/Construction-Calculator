import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/excavation_history_item.dart';

class ExcavationLocalDataSource {
  final Box<ExcavationHistoryItem> excavationBox;

  ExcavationLocalDataSource(this.excavationBox);

  List<ExcavationHistoryItem> getHistory() {
    return excavationBox.values.toList();
  }

  Future<void> addHistory(ExcavationHistoryItem item) async {
    await excavationBox.add(item);
  }

  Future<void> clearHistory() async {
    await excavationBox.clear();
  }

  Future<void> deleteHistoryItem(ExcavationHistoryItem item) async {
    final key = excavationBox.keys.firstWhere(
      (k) => excavationBox.get(k) == item,
      orElse: () => null,
    );
    if (key != null) {
      await excavationBox.delete(key);
    }
  }
}
