import 'package:construction_calculator/Domain/entities/civilunitconversion_history_item.dart';
import 'package:hive/hive.dart';

class CivilUnitRepository {
  final String boxName = "civil_unit_history";

  Future<List<ConversionHistory>> getHistory() async {
    final box = await Hive.openBox<ConversionHistory>(boxName);
    return box.values.toList();
  }

  Future<void> saveHistory(ConversionHistory item) async {
    final box = await Hive.openBox<ConversionHistory>(boxName);
    await box.add(item);
  }

  Future<void> deleteHistory(int key) async {
    final box = await Hive.openBox<ConversionHistory>(boxName);
    await box.delete(key);
  }

  Future<void> clearHistory() async {
    final box = await Hive.openBox<ConversionHistory>(boxName);
    await box.clear();
  }
}
