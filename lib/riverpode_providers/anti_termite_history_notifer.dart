import 'package:construction_calculator/Domain/entities/anti_termite_history_item.dart';
import 'package:construction_calculator/features/History/Data/anti_termite_history_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AntiTermiteNotifier extends StateNotifier<List<AntiTermiteHistoryItem>> {
  final AntiTermiteRepository repository;

  AntiTermiteNotifier({required this.repository}) : super([]) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    final history = await repository.getHistory();
    state = history;
  }

  Future<void> addHistory(AntiTermiteHistoryItem item) async {
    await repository.saveHistory(item);
    await loadHistory();
  }

  Future<void> deleteHistory(int key) async {
    await repository.deleteHistory(key);
    await loadHistory();
  }

  Future<void> clearHistory() async {
    await repository.clearHistory();
    state = [];
  }
}
