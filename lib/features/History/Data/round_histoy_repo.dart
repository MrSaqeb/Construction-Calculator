import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/round_steal_history_item.dart';
import 'package:hive/hive.dart';

class RoundStealRepository {
  Future<List<RoundStealHistoryItem>> getHistory() async {
    final box = await Hive.openBox<RoundStealHistoryItem>(
      HiveBoxes.roundHistory,
    );
    return box.values.toList();
  }

  Future<void> saveHistory(RoundStealHistoryItem item) async {
    final box = await Hive.openBox<RoundStealHistoryItem>(
      HiveBoxes.roundHistory,
    );
    await box.add(item);
  }

  Future<void> deleteHistory(int key) async {
    final box = await Hive.openBox<RoundStealHistoryItem>(
      HiveBoxes.roundHistory,
    );
    await box.delete(key);
  }

  Future<void> clearHistory() async {
    final box = await Hive.openBox<RoundStealHistoryItem>(
      HiveBoxes.roundHistory,
    );
    await box.clear();
  }
}
