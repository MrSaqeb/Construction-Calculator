import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/horizontal_capsule_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class HorizontalCapsuleNotifier
    extends StateNotifier<List<HorizontalCapsuleItem>> {
  HorizontalCapsuleNotifier() : super([]) {
    _loadItems();
  }

  late Box<HorizontalCapsuleItem> _box;

  Future<void> _loadItems() async {
    _box = await Hive.openBox<HorizontalCapsuleItem>(
      HiveBoxes.horizontalCapsuleHistory,
    );
    state = _box.values.toList();
  }

  Future<void> addItem(HorizontalCapsuleItem item) async {
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

final horizontalCapsuleProvider =
    StateNotifierProvider<
      HorizontalCapsuleNotifier,
      List<HorizontalCapsuleItem>
    >((ref) => HorizontalCapsuleNotifier());
