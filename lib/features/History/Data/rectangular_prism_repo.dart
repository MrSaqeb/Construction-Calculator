import 'package:construction_calculator/Domain/entities/rectangular_prism_item.dart';
import 'package:construction_calculator/features/History/Data/rectangular_prisim_local_data.dart';

class RectangularPrismRepository {
  final RectangularPrismLocalDataSource localDataSource;

  RectangularPrismRepository(this.localDataSource);

  List<RectangularPrismItem> getHistory() => localDataSource.getAll();

  Future<void> addHistory(RectangularPrismItem item) =>
      localDataSource.add(item);

  Future<void> deleteHistoryItem(int index) => localDataSource.delete(index);

  Future<void> clearHistory() => localDataSource.clear();
}
