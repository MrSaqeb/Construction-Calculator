import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/cone_top_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class ConeTopNotifier extends StateNotifier<List<ConeTopHistoryItem>> {
  ConeTopNotifier() : super([]) {
    _loadItems();
  }

  late Box<ConeTopHistoryItem> _box;

  Future<void> _loadItems() async {
    _box = await Hive.openBox<ConeTopHistoryItem>(HiveBoxes.coneTopHistory);
    state = _box.values.toList();
  }

  Future<void> addItem(ConeTopHistoryItem item) async {
    await _box.add(item);
    state = _box.values.toList();
  }

  Future<void> removeItem(int index) async {
    await _box.deleteAt(index);
    state = _box.values.toList();
  }

  Future<void> clearAll() async {
    await _box.clear();
    state = [];
  }
}

final coneTopProvider =
    StateNotifierProvider<ConeTopNotifier, List<ConeTopHistoryItem>>(
      (ref) => ConeTopNotifier(),
    );
