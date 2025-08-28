import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/solar_roofttop_history_item.dart';
import 'package:hive/hive.dart';

class SolarRooftopRepository {
  late Box<SolarHistoryItem> _solarBox;

  Future<void> init() async {
    _solarBox = await Hive.openBox<SolarHistoryItem>(HiveBoxes.solarHistory);
  }

  Future<void> addSolar(SolarHistoryItem item) async {
    // Duplicate check
    final exists = _solarBox.values.any(
      (e) =>
          e.consumptionType == item.consumptionType &&
          e.inputConsumption == item.inputConsumption &&
          e.dailyUnit == item.dailyUnit &&
          e.kwSystem == item.kwSystem &&
          e.totalPanels == item.totalPanels &&
          e.rooftopAreaSqFt == item.rooftopAreaSqFt &&
          e.rooftopAreaSqM == item.rooftopAreaSqM,
    );

    if (!exists) {
      await _solarBox.add(item);
    }
  }

  List<SolarHistoryItem> getAllHistory() {
    return _solarBox.values.toList().reversed.toList(); // latest first
  }

  Future<void> clearHistory() async {
    await _solarBox.clear();
  }
}
