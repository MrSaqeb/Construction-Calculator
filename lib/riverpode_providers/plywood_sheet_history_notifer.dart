import 'package:construction_calculator/Domain/entities/plywood_sheet_history_item.dart';
import 'package:construction_calculator/features/History/Data/plywood_sheet_history_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlywoodSheetNotifier extends StateNotifier<List<PlywoodSheetItem>> {
  final PlywoodSheetRepository repository;

  PlywoodSheetNotifier(this.repository) : super([]) {
    loadSheets();
  }

  void loadSheets() {
    state = repository.getAllSheets();
  }

  Future<void> addSheet(PlywoodSheetItem item) async {
    await repository.addSheet(item);
    loadSheets();
  }

  Future<void> deleteSheet(int index) async {
    await repository.deleteSheet(index);
    loadSheets();
  }

  Future<void> clearAll() async {
    await repository.clearAll();
    loadSheets();
  }
}
