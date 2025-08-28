import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/round_column_history_item.dart';

class RoundColumnRepository {
  Future<List<RoundColumnHistoryItem>> getHistory() async {
    final box = await Hive.openBox<RoundColumnHistoryItem>(
      HiveBoxes.roundColumnHistory,
    );
    return box.values.toList();
  }

  Future<void> saveHistory(RoundColumnHistoryItem item) async {
    final box = await Hive.openBox<RoundColumnHistoryItem>(
      HiveBoxes.roundColumnHistory,
    );
    await box.add(item);
  }

  Future<void> deleteHistory(int key) async {
    final box = await Hive.openBox<RoundColumnHistoryItem>(
      HiveBoxes.roundColumnHistory,
    );
    await box.delete(key);
  }

  Future<void> clearHistory() async {
    final box = await Hive.openBox<RoundColumnHistoryItem>(
      HiveBoxes.roundColumnHistory,
    );
    await box.clear();
  }
}
