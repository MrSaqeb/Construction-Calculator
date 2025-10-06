import 'package:construction_calculator/Domain/entities/vertical_elliptical_item.dart';
import 'package:construction_calculator/features/History/Data/vertical_elliplitical_local_data.dart';

class VerticalEllipticalRepository {
  final VerticalEllipticalLocalDataSource localDataSource;

  VerticalEllipticalRepository(this.localDataSource);

  List<VerticalEllipticalItem> getHistory() => localDataSource.getAll();

  Future<void> addHistory(VerticalEllipticalItem item) =>
      localDataSource.add(item);

  Future<void> deleteHistoryItem(int index) => localDataSource.delete(index);

  Future<void> clearHistory() => localDataSource.clear();
}
