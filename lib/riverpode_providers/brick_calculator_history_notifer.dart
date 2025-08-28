import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/brick_history_item.dart';

class BrickCalculatorHistoryNotifier
    extends StateNotifier<List<BrickHistoryItem>> {
  final Box<BrickHistoryItem> box;

  BrickCalculatorHistoryNotifier(this.box) : super(box.values.toList());

  void addHistory(BrickHistoryItem item) {
    box.add(item);
    state = box.values.toList();
  }

  void deleteHistory(int index) {
    if (index >= 0 && index < state.length) {
      box.deleteAt(index);
      state = box.values.toList();
    }
  }

  void clearHistory() {
    box.clear();
    state = [];
  }
}

final brickCalculatorHistoryProvider =
    StateNotifierProvider<
      BrickCalculatorHistoryNotifier,
      List<BrickHistoryItem>
    >((ref) {
      final box = Hive.box<BrickHistoryItem>(HiveBoxes.brickHistory);
      return BrickCalculatorHistoryNotifier(box);
    });
