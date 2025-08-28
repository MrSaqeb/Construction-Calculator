import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/topsoil_history_item.dart';

// ✅ StateNotifier for Top Soil History
class TopSoilHistoryNotifier extends StateNotifier<List<TopSoilHistoryItem>> {
  TopSoilHistoryNotifier() : super([]) {
    _loadHistory();
  }

  // Hive box
  late Box<TopSoilHistoryItem> _box;

  Future<void> _loadHistory() async {
    _box = await Hive.openBox<TopSoilHistoryItem>('topsoil_history');
    state = _box.values.toList();
  }

  Future<void> addHistory(TopSoilHistoryItem item) async {
    await _box.add(item);
    state = _box.values.toList();
  }

  Future<void> deleteHistory(int index) async {
    await _box.deleteAt(index);
    state = _box.values.toList();
  }

  Future<void> clearHistory() async {
    await _box.clear();
    state = [];
  }
}

// ✅ Riverpod provider
final topSoilHistoryProvider =
    StateNotifierProvider<TopSoilHistoryNotifier, List<TopSoilHistoryItem>>(
      (ref) => TopSoilHistoryNotifier(),
    );
