import 'package:construction_calculator/Domain/entities/concreteblock_history_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';

class ConcreteBlockHistoryNotifier
    extends StateNotifier<List<ConcreteBlockHistory>> {
  final Box<ConcreteBlockHistory> _box;

  ConcreteBlockHistoryNotifier(this._box) : super(_box.values.toList());

  /// Add new history item
 Future<void> addHistory(ConcreteBlockHistory item) async {
    final exists = _box.values.any(
      (e) =>
          e.dateTime == item.dateTime &&
          e.unitType == item.unitType &&
          e.length == item.length &&
          e.height == item.height &&
          e.thickness == item.thickness,
    );

    if (!exists) await _box.add(item);
    state = _box.values.toList();
  }


  /// Delete history item by index
  Future<void> deleteHistory(int index) async {
    if (index >= 0 && index < _box.length) {
      await _box.deleteAt(index);
      state = _box.values.toList();
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await _box.clear();
    state = [];
  }
}

/// Riverpod Provider
final concreteBlockHistoryProvider =
    StateNotifierProvider<
      ConcreteBlockHistoryNotifier,
      List<ConcreteBlockHistory>
    >((ref) {
      // Ensure box is already opened in main() before using it
      final box = Hive.box<ConcreteBlockHistory>(
        HiveBoxes.concreteBlockHistory, // consistent naming
      );
      return ConcreteBlockHistoryNotifier(box);
    });
