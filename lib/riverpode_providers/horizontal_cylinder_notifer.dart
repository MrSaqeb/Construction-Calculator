import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/horizontal_cylinder_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class HorizontalCylinderNotifier
    extends StateNotifier<List<HorizontalCylinderItem>> {
  HorizontalCylinderNotifier() : super([]) {
    _loadItems();
  }

  late Box<HorizontalCylinderItem> _box;

  Future<void> _loadItems() async {
    _box = await Hive.openBox<HorizontalCylinderItem>(
      HiveBoxes.horizontalCylinderHistory,
    );
    state = _box.values.toList();
  }

  Future<void> addItem(HorizontalCylinderItem item) async {
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

final horizontalCylinderProvider =
    StateNotifierProvider<
      HorizontalCylinderNotifier,
      List<HorizontalCylinderItem>
    >((ref) => HorizontalCylinderNotifier());
