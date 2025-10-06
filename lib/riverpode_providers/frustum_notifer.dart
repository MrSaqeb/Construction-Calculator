import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/frustum_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class FrustumNotifier extends StateNotifier<List<FrustumHistoryItem>> {
  FrustumNotifier() : super([]) {
    _loadItems();
  }

  late Box<FrustumHistoryItem> _box;

  Future<void> _loadItems() async {
    _box = await Hive.openBox<FrustumHistoryItem>(HiveBoxes.frustumHistory);
    state = _box.values.toList();
  }

  Future<void> addItem(FrustumHistoryItem item) async {
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

final frustumProvider =
    StateNotifierProvider<FrustumNotifier, List<FrustumHistoryItem>>(
      (ref) => FrustumNotifier(),
    );
