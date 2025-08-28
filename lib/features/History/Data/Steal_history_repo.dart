import 'package:construction_calculator/Domain/entities/steal_we_history_item.dart';

import 'package:construction_calculator/features/History/Data/steal_history_local_data_save.dart';

/// Abstract repository (interface)
abstract class ISteelHistoryRepository {
  Future<void> add(StealHistoryItem item);
  List<StealHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

/// Implementation of Repository
class SteelHistoryRepository implements ISteelHistoryRepository {
  final SteelHistoryLocalDataSource local;

  SteelHistoryRepository(this.local);

  @override
  Future<void> add(StealHistoryItem item) => local.add(item);

  @override
  List<StealHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
