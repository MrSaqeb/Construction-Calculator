// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:construction_calculator/Domain/entities/pressure_history_item.dart';

class PressureHistoryNotifier extends StateNotifier<List<PressureHistoryItem>> {
  PressureHistoryNotifier() : super([]);

  void addHistory(PressureHistoryItem item) {
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

final pressureHistoryProvider =
    StateNotifierProvider<PressureHistoryNotifier, List<PressureHistoryItem>>(
      (ref) => PressureHistoryNotifier(),
    );
