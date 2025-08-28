// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:construction_calculator/Domain/entities/frequency_history_item.dart';

class FrequencyHistoryNotifier
    extends StateNotifier<List<FrequencyHistoryItem>> {
  FrequencyHistoryNotifier() : super([]);

  void addHistory(FrequencyHistoryItem item) {
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

final frequencyHistoryProvider =
    StateNotifierProvider<FrequencyHistoryNotifier, List<FrequencyHistoryItem>>(
      (ref) => FrequencyHistoryNotifier(),
    );
