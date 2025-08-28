import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:construction_calculator/Domain/entities/square_bar_history_item.dart';
import 'package:hive/hive.dart';

// Notifier for Square Bar History
class SquareBarHistoryNotifier
    extends StateNotifier<List<SquareBarHistoryItem>> {
  final Box<SquareBarHistoryItem> box;

  SquareBarHistoryNotifier(this.box) : super(box.values.toList());

  // Add new history item
  void addHistory(SquareBarHistoryItem item) {
    box.add(item); // Save to Hive
    state = box.values.toList(); // Update state
  }

  // Delete history item by index
  void deleteHistory(int index) {
    if (index >= 0 && index < state.length) {
      box.deleteAt(index);
      state = box.values.toList();
    }
  }

  // Clear all history
  void clearHistory() {
    box.clear();
    state = [];
  }
}

// Riverpod provider
final squareBarHistoryProvider =
    StateNotifierProvider<SquareBarHistoryNotifier, List<SquareBarHistoryItem>>(
      (ref) {
        final box = Hive.box<SquareBarHistoryItem>('square_bar_history');
        return SquareBarHistoryNotifier(box);
      },
    );
