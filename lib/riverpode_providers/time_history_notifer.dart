// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:construction_calculator/Domain/entities/time_history_item.dart';

class TimeHistoryNotifier extends StateNotifier<List<TimeHistoryItem>> {
  TimeHistoryNotifier() : super([]);

  void addHistory(TimeHistoryItem item) {
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

final timeHistoryProvider =
    StateNotifierProvider<TimeHistoryNotifier, List<TimeHistoryItem>>(
      (ref) => TimeHistoryNotifier(),
    );
