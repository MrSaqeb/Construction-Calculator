import 'package:construction_calculator/Domain/entities/horizontal_capsule_item.dart';
import 'package:construction_calculator/features/History/Data/horizontal_capsule_local_data.dart';

class HorizontalCapsuleRepository {
  final HorizontalCapsuleLocalDataSource localDataSource;

  HorizontalCapsuleRepository(this.localDataSource);

  List<HorizontalCapsuleItem> getHistory() => localDataSource.getAll();

  Future<void> addHistory(HorizontalCapsuleItem item) =>
      localDataSource.add(item);

  Future<void> deleteHistoryItem(int index) => localDataSource.delete(index);

  Future<void> clearHistory() => localDataSource.clear();
}
