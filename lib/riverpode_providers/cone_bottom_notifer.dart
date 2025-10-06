import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/cone_bottom_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class ConeBottomNotifier extends StateNotifier<List<ConeBottomHistoryItem>> {
  ConeBottomNotifier() : super([]) {
    _loadItems();
  }

  late Box<ConeBottomHistoryItem> _box;

  Future<void> _loadItems() async {
    _box = await Hive.openBox<ConeBottomHistoryItem>(
      HiveBoxes.coneBottomHistory,
    );
    state = _box.values.toList();
  }

  Future<void> addItem(ConeBottomHistoryItem item) async {
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

final coneBottomProvider =
    StateNotifierProvider<ConeBottomNotifier, List<ConeBottomHistoryItem>>(
      (ref) => ConeBottomNotifier(),
    );
