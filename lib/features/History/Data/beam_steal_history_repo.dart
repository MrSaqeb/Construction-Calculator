import 'package:construction_calculator/Domain/entities/beam_steal_history_item.dart';
import 'package:construction_calculator/features/History/Data/beam_steal_history_loacal_data.dart';

/// Abstract repository (interface)
abstract class IBeamSteelHistoryRepository {
  Future<void> add(BeamStealHistoryItem item);
  List<BeamStealHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

/// Implementation of Repository
class BeamSteelHistoryRepository implements IBeamSteelHistoryRepository {
  final BeamSteelHistoryLocalDataSource local;

  BeamSteelHistoryRepository(this.local);

  @override
  Future<void> add(BeamStealHistoryItem item) => local.add(item);

  @override
  List<BeamStealHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
