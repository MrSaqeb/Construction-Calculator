import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/anti_termite_history_item.dart';
import 'package:hive/hive.dart';

class AntiTermiteLocalDataSource {
  Future<Box<AntiTermiteHistoryItem>> _openBox() async {
    return await Hive.openBox<AntiTermiteHistoryItem>(
      HiveBoxes.antiTermiteHistory,
    );
  }

  Future<void> save(AntiTermiteHistoryItem item) async {
    final box = await _openBox();

    // Duplicate check
    final exists = box.values.any(
      (e) =>
          e.lenM == item.lenM &&
          e.lenCM == item.lenCM &&
          e.lenFT == item.lenFT &&
          e.lenIN == item.lenIN &&
          e.widthM == item.widthM &&
          e.widthCM == item.widthCM &&
          e.widthFT == item.widthFT &&
          e.widthIN == item.widthIN &&
          e.area == item.area &&
          e.chemicalQuantity == item.chemicalQuantity &&
          e.unit == item.unit,
    );

    if (!exists) {
      await box.add(item);
    }
  }

  Future<List<AntiTermiteHistoryItem>> getAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> delete(int key) async {
    final box = await _openBox();
    await box.delete(key);
  }

  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
