import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/vertical_capsule_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class VerticalCapsuleNotifier extends StateNotifier<List<VerticalCapsuleItem>> {
  VerticalCapsuleNotifier() : super([]) {
    _loadItems();
  }

  late Box<VerticalCapsuleItem> _box;

  Future<void> _loadItems() async {
    _box = await Hive.openBox<VerticalCapsuleItem>(
      HiveBoxes.verticalCapsuleHistory,
    );
    state = _box.values.toList();
  }

  Future<void> addItem(VerticalCapsuleItem item) async {
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

final verticalCapsuleProvider =
    StateNotifierProvider<VerticalCapsuleNotifier, List<VerticalCapsuleItem>>(
      (ref) => VerticalCapsuleNotifier(),
    );
