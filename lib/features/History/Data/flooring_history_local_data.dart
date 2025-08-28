import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/flooring_history_item.dart';

class FlooringLocalDataSource {
  final Box<FlooringHistoryItem> flooringBox;

  FlooringLocalDataSource(this.flooringBox);

  List<FlooringHistoryItem> getHistory() {
    return flooringBox.values.toList();
  }

  Future<void> addHistory(FlooringHistoryItem item) async {
    await flooringBox.add(item);
  }

  Future<void> clearHistory() async {
    await flooringBox.clear();
  }

  Future<void> deleteHistoryItem(FlooringHistoryItem item) async {
    final key = flooringBox.keys.firstWhere(
      (k) => flooringBox.get(k) == item,
      orElse: () => null,
    );
    if (key != null) {
      await flooringBox.delete(key);
    }
  }
}
