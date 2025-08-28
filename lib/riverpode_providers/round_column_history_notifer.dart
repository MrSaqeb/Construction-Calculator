import 'package:construction_calculator/Domain/entities/round_column_history_item.dart';
import 'package:construction_calculator/features/History/Data/round_column_history_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundColumnNotifier extends StateNotifier<List<RoundColumnHistoryItem>> {
  final RoundColumnRepository repository;

  RoundColumnNotifier({required this.repository}) : super([]) {
    loadHistory();
  }

  /// 🔹 Load all saved history
  Future<void> loadHistory() async {
    final history = await repository.getHistory();
    state = history;
  }

  /// 🔹 Add new history item
  Future<void> addHistory(RoundColumnHistoryItem item) async {
    await repository.saveHistory(item);
    await loadHistory();
  }

  /// 🔹 Delete by Hive key
  Future<void> deleteHistory(int key) async {
    await repository.deleteHistory(key);
    await loadHistory();
  }

  /// 🔹 Clear all history
  Future<void> clearHistory() async {
    await repository.clearHistory();
    state = [];
  }
}
