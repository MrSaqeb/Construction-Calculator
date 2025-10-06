import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/horizontal_elliptical_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class HorizontalEllipticalNotifier
    extends StateNotifier<List<HorizontalEllipticalHistoryItem>> {
  HorizontalEllipticalNotifier() : super([]) {
    _loadItems();
  }

  late Box<HorizontalEllipticalHistoryItem> _box;

  Future<void> _loadItems() async {
    _box = await Hive.openBox<HorizontalEllipticalHistoryItem>(
      HiveBoxes.horizontalEllipticalHistory,
    );
    state = _box.values.toList();
  }

  Future<void> addItem(HorizontalEllipticalHistoryItem item) async {
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

final horizontalEllipticalProvider =
    StateNotifierProvider<
      HorizontalEllipticalNotifier,
      List<HorizontalEllipticalHistoryItem>
    >((ref) => HorizontalEllipticalNotifier());
