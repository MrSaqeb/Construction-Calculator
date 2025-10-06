import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import '../Domain/entities/sector_history_item.dart';

class SectorHistoryNotifier extends StateNotifier<List<SectorHistoryItem>> {
  SectorHistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.sectorHistory)) {
      await Hive.openBox<SectorHistoryItem>(HiveBoxes.sectorHistory);
    }
    final box = Hive.box<SectorHistoryItem>(HiveBoxes.sectorHistory);
    state = box.values.toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> add(SectorHistoryItem item) async {
    final box = Hive.box<SectorHistoryItem>(HiveBoxes.sectorHistory);
    await box.add(item);
    state = [...state, item]..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> delete(int index) async {
    final box = Hive.box<SectorHistoryItem>(HiveBoxes.sectorHistory);
    await box.deleteAt(index);
    state = [...state]..removeAt(index);
  }

  Future<void> clear() async {
    final box = Hive.box<SectorHistoryItem>(HiveBoxes.sectorHistory);
    await box.clear();
    state = [];
  }
}

final sectorHistoryProvider =
    StateNotifierProvider<SectorHistoryNotifier, List<SectorHistoryItem>>(
      (ref) => SectorHistoryNotifier(),
    );
