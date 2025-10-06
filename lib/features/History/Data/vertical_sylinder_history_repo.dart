import 'package:construction_calculator/Domain/entities/vertical_cylinder_item.dart';
import 'package:construction_calculator/features/History/Data/vertical_local_data_.dart';

/// Abstract repository (interface)
abstract class IVerticalCylinderRepository {
  Future<void> add(VerticalCylinderHistoryItem item);
  List<VerticalCylinderHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

/// Implementation of Repository
class VerticalCylinderRepository implements IVerticalCylinderRepository {
  final VerticalCylinderLocalDataSource local;

  VerticalCylinderRepository(this.local);

  @override
  Future<void> add(VerticalCylinderHistoryItem item) => local.add(item);

  @override
  List<VerticalCylinderHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
