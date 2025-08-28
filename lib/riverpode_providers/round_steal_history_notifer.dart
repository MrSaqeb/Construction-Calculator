import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/round_steal_history_item.dart';

/// Notifier for Round Steel History (Hive Based)
class RoundSteelHistoryNotifier
    extends StateNotifier<List<RoundStealHistoryItem>> {
  final Box<RoundStealHistoryItem> box;

  RoundSteelHistoryNotifier(this.box) : super(box.values.toList());

  /// ✅ Add new history item
  void addHistory(RoundStealHistoryItem item) {
    box.add(item);
    state = box.values.toList();
  }

  /// ✅ Delete history item by index
  void deleteHistory(int index) {
    if (index >= 0 && index < state.length) {
      box.deleteAt(index);
      state = box.values.toList();
    }
  }

  /// ✅ Clear all history
  void clearHistory() {
    box.clear();
    state = [];
  }
}

/// ✅ Riverpod provider
final roundSteelHistoryProvider =
    StateNotifierProvider<
      RoundSteelHistoryNotifier,
      List<RoundStealHistoryItem>
    >((ref) {
      final box = Hive.box<RoundStealHistoryItem>(HiveBoxes.roundHistory);
      return RoundSteelHistoryNotifier(box);
    });
