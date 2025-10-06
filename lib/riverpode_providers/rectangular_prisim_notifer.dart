import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/rectangular_prism_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class RectangularPrismNotifier
    extends StateNotifier<List<RectangularPrismItem>> {
  RectangularPrismNotifier() : super([]) {
    _loadItems();
  }

  late Box<RectangularPrismItem> _box;

  Future<void> _loadItems() async {
    _box = await Hive.openBox<RectangularPrismItem>(
      HiveBoxes.rectangularPrismHistory,
    );
    state = _box.values.toList();
  }

  Future<void> addItem(RectangularPrismItem item) async {
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

final rectangularPrismProvider =
    StateNotifierProvider<RectangularPrismNotifier, List<RectangularPrismItem>>(
      (ref) => RectangularPrismNotifier(),
    );
