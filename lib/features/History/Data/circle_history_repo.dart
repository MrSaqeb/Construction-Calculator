import 'package:construction_calculator/Domain/entities/circle_history_item.dart';
import 'package:construction_calculator/features/History/Data/circle_history_local_history_data.dart';

/// ✅ Repository for Circle History
class CircleHistoryRepository {
  final CircleHistoryLocalDataSource localDataSource;

  CircleHistoryRepository({required this.localDataSource});

  Future<List<CircleHistoryItem>> getHistory() async {
    return await localDataSource.getAll();
  }

  Future<void> saveHistory(CircleHistoryItem item) async {
    await localDataSource.add(item);
  }

  Future<void> deleteHistory(int index) async {
    await localDataSource.delete(index);
  }

  Future<void> clearHistory() async {
    await localDataSource.clear();
  }
}
