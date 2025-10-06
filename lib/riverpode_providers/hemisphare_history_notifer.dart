import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import '../Domain/entities/hemisphere_history_item.dart';

class HemisphereHistoryNotifier
    extends StateNotifier<List<HemisphereHistoryItem>> {
  HemisphereHistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.hemisphereHistory)) {
      await Hive.openBox<HemisphereHistoryItem>(HiveBoxes.hemisphereHistory);
    }
    final box = Hive.box<HemisphereHistoryItem>(HiveBoxes.hemisphereHistory);
    state = box.values.toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> add(HemisphereHistoryItem item) async {
    final box = Hive.box<HemisphereHistoryItem>(HiveBoxes.hemisphereHistory);
    await box.add(item);
    state = [...state, item]..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> delete(int index) async {
    final box = Hive.box<HemisphereHistoryItem>(HiveBoxes.hemisphereHistory);
    await box.deleteAt(index);
    state = [...state]..removeAt(index);
  }

  Future<void> clear() async {
    final box = Hive.box<HemisphereHistoryItem>(HiveBoxes.hemisphereHistory);
    await box.clear();
    state = [];
  }
}

final hemisphereHistoryProvider =
    StateNotifierProvider<
      HemisphereHistoryNotifier,
      List<HemisphereHistoryItem>
    >((ref) => HemisphereHistoryNotifier());
