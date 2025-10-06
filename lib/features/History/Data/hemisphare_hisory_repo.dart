import 'package:construction_calculator/Domain/entities/hemisphere_history_item.dart';
import 'package:construction_calculator/features/History/Data/hemisphere_history_local_data.dart';

abstract class IHemisphereHistoryRepository {
  Future<void> add(HemisphereHistoryItem item);
  List<HemisphereHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class HemisphereHistoryRepository implements IHemisphereHistoryRepository {
  final HemisphereHistoryLocalDataSource local;

  HemisphereHistoryRepository(this.local);

  @override
  Future<void> add(HemisphereHistoryItem item) => local.add(item);

  @override
  List<HemisphereHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
