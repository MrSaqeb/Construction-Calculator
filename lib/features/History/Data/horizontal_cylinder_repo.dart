import 'package:construction_calculator/Domain/entities/horizontal_cylinder_item.dart';
import 'package:construction_calculator/features/History/Data/horizontal_cylinder_local_data.dart';

class HorizontalCylinderRepository {
  final HorizontalCylinderLocalDataSource localDataSource;

  HorizontalCylinderRepository(this.localDataSource);

  List<HorizontalCylinderItem> getHistory() => localDataSource.getAll();

  Future<void> addHistory(HorizontalCylinderItem item) =>
      localDataSource.add(item);

  Future<void> deleteHistoryItem(int index) => localDataSource.delete(index);

  Future<void> clearHistory() => localDataSource.clear();
}
