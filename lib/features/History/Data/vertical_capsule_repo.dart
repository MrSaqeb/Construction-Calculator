import 'package:construction_calculator/Domain/entities/vertical_capsule_item.dart';
import 'package:construction_calculator/features/History/Data/vertical_capsule_local_data.dart';

class VerticalCapsuleRepository {
  final VerticalCapsuleLocalDataSource localDataSource;

  VerticalCapsuleRepository(this.localDataSource);

  List<VerticalCapsuleItem> getHistory() => localDataSource.getAll();

  Future<void> addHistory(VerticalCapsuleItem item) =>
      localDataSource.add(item);

  Future<void> deleteHistoryItem(int index) => localDataSource.delete(index);

  Future<void> clearHistory() => localDataSource.clear();
}
