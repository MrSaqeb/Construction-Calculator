import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import '../Domain/entities/arch_history_item.dart';

class ArchHistoryNotifier extends StateNotifier<List<ArchHistoryItem>> {
  ArchHistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    if (!Hive.isBoxOpen(HiveBoxes.archHistory)) {
      await Hive.openBox<ArchHistoryItem>(HiveBoxes.archHistory);
    }
    final box = Hive.box<ArchHistoryItem>(HiveBoxes.archHistory);
    state = box.values.toList()..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> add(ArchHistoryItem item) async {
    final box = Hive.box<ArchHistoryItem>(HiveBoxes.archHistory);
    await box.add(item);
    state = [...state, item]..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> delete(int index) async {
    final box = Hive.box<ArchHistoryItem>(HiveBoxes.archHistory);
    await box.deleteAt(index);
    state = [...state]..removeAt(index);
  }

  Future<void> clear() async {
    final box = Hive.box<ArchHistoryItem>(HiveBoxes.archHistory);
    await box.clear();
    state = [];
  }
}

final archHistoryProvider =
    StateNotifierProvider<ArchHistoryNotifier, List<ArchHistoryItem>>(
      (ref) => ArchHistoryNotifier(),
    );
