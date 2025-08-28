import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:construction_calculator/Domain/entities/distance_history_item.dart';
import 'package:construction_calculator/features/History/Data/distance_history_repo.dart';

class DistanceHistoryNotifier extends StateNotifier<List<DistanceHistoryItem>> {
  final DistanceHistoryRepo repo;

  DistanceHistoryNotifier(this.repo) : super([]) {
    _loadHistory();
  }

  /// pehli dafa sari history load karna
  void _loadHistory() {
    final items = repo.getHistory();
    state = items;
  }

  /// naya item add karna
  Future<void> addItem(DistanceHistoryItem item) async {
    await repo.addHistory(item);
    _loadHistory(); // refresh state
  }

  /// ek item delete karna (index based)
  Future<void> deleteItem(int index) async {
    await repo.deleteHistoryItem(index);
    _loadHistory(); // refresh state
  }

  /// puri history clear karna
  Future<void> clearAll() async {
    await repo.clearHistory();
    state = [];
  }
}
