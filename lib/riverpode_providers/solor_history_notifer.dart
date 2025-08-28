// lib/features/Screens/providers/solar_history_provider.dart

import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/solar_roofttop_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final solarHistoryProvider =
    StateNotifierProvider<SolarHistoryNotifier, List<HistoryItem>>(
      (ref) => SolarHistoryNotifier(),
    );

class SolarHistoryNotifier extends StateNotifier<List<HistoryItem>> {
  SolarHistoryNotifier() : super([]) {
    _loadHistory();
  }

  late Box<SolarHistoryItem> _box;

  Future<void> _loadHistory() async {
    _box = await Hive.openBox<SolarHistoryItem>(HiveBoxes.solarHistory);
    final historyItems = _box.values
        .map(
          (item) => HistoryItem(
            type: HiveBoxes.solarHistory,
            data: item,
            timestamp: item.timestamp,
          ),
        )
        .toList();
    state = historyItems;
  }

  Future<void> addSolar(SolarHistoryItem item) async {
    // Duplicate check
    final exists = _box.values.any(
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
      final key = await _box.add(item);
      final savedItem = _box.get(key);
      if (savedItem != null) {
        _addToState(
          HistoryItem(
            type: HiveBoxes.solarHistory,
            data: savedItem,
            timestamp: savedItem.timestamp,
          ),
        );
      }
    }
  }

  void _addToState(HistoryItem item) {
    state = [...state, item];
  }

  Future<void> clearHistory() async {
    await _box.clear();
    state = [];
  }
}
