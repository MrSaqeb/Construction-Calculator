import 'package:construction_calculator/Domain/entities/mass_history_item.dart';
import 'package:construction_calculator/features/History/Data/mass_history_local_data.dart';

abstract class IMassHistoryRepository {
  Future<void> add(MassHistoryItem item);
  List<MassHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class MassHistoryRepository implements IMassHistoryRepository {
  final MassHistoryLocalDataSource local;

  MassHistoryRepository(this.local);

  @override
  Future<void> add(MassHistoryItem item) => local.add(item);

  @override
  List<MassHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
