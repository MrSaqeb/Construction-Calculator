import 'package:construction_calculator/Domain/entities/horizontal_elliptical_item.dart';
import 'package:construction_calculator/features/History/Data/horizontal_elliplitical_local_data.dart';

class HorizontalEllipticalRepository {
  final HorizontalEllipticalLocalDataSource localDataSource;

  HorizontalEllipticalRepository(this.localDataSource);

  List<HorizontalEllipticalHistoryItem> getHistory() =>
      localDataSource.getAll();

  Future<void> addHistory(HorizontalEllipticalHistoryItem item) =>
      localDataSource.add(item);

  Future<void> deleteHistoryItem(int index) => localDataSource.delete(index);

  Future<void> clearHistory() => localDataSource.clear();
}
