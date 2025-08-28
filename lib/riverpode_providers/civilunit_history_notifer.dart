import 'package:construction_calculator/Domain/entities/civilunitconversion_history_item.dart';
import 'package:construction_calculator/features/History/Data/civilunit_history_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CivilUnitNotifier extends StateNotifier<List<ConversionHistory>> {
  final CivilUnitRepository repository;

  CivilUnitNotifier({required this.repository}) : super([]) {
    loadHistory();
  }

  /// Load all history items from Hive
  Future<void> loadHistory() async {
    final history = await repository.getHistory();
    state = history;
  }

  /// Add new conversion history
  Future<void> addHistory(ConversionHistory item) async {
    await repository.saveHistory(item);
    await loadHistory();
  }

  /// Delete single history record by Hive key
  Future<void> deleteHistory(int key) async {
    await repository.deleteHistory(key);
    await loadHistory();
  }

  /// Clear all history
  Future<void> clearHistory() async {
    await repository.clearHistory();
    state = [];
  }
}
