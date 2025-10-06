import 'package:construction_calculator/Domain/entities/arch_history_item.dart';
import 'package:construction_calculator/features/History/Data/arch_history_local_data.dart';

abstract class IArchHistoryRepository {
  Future<void> add(ArchHistoryItem item);
  List<ArchHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class ArchHistoryRepository implements IArchHistoryRepository {
  final ArchHistoryLocalDataSource local;

  ArchHistoryRepository(this.local);

  @override
  Future<void> add(ArchHistoryItem item) => local.add(item);

  @override
  List<ArchHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
