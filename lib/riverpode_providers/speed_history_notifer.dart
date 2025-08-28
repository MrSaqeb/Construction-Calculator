// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:construction_calculator/Domain/entities/speed_history_item.dart';

class SpeedHistoryNotifier extends StateNotifier<List<SpeedHistoryItem>> {
  SpeedHistoryNotifier() : super([]);

  void addHistory(SpeedHistoryItem item) {
    final exists = state.firstWhereOrNull(
      (h) =>
          h.inputValue == item.inputValue &&
          h.inputUnit == item.inputUnit &&
          MapEquality().equals(h.convertedValues, item.convertedValues),
    );

    if (exists == null) {
      state = [...state, item];
    }
  }

  void clearHistory() {
    state = [];
  }
}

final speedHistoryProvider =
    StateNotifierProvider<SpeedHistoryNotifier, List<SpeedHistoryItem>>(
      (ref) => SpeedHistoryNotifier(),
    );
