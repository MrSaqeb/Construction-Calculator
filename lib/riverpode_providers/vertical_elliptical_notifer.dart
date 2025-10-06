import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/vertical_elliptical_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class VerticalEllipticalNotifier
    extends StateNotifier<List<VerticalEllipticalItem>> {
  VerticalEllipticalNotifier() : super([]) {
    _loadItems();
  }

  late Box<VerticalEllipticalItem> _box;

  Future<void> _loadItems() async {
    _box = await Hive.openBox<VerticalEllipticalItem>(
      HiveBoxes.verticalEllipticalHistory,
    );
    state = _box.values.toList();
  }

  Future<void> addItem(VerticalEllipticalItem item) async {
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

final verticalEllipticalProvider =
    StateNotifierProvider<
      VerticalEllipticalNotifier,
      List<VerticalEllipticalItem>
    >((ref) => VerticalEllipticalNotifier());
