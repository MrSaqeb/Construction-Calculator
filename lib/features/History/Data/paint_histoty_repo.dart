import 'package:construction_calculator/Domain/entities/paint_history_item.dart';
import 'package:construction_calculator/features/History/Data/paint_history_local_data.dart';

class PaintHistoryRepository {
  final PaintLocalDataSource localDataSource;

  PaintHistoryRepository({required this.localDataSource});

  Future<void> addPaintHistory(PaintHistoryItem item) async {
    await localDataSource.addPaintHistory(item);
  }

  Future<List<PaintHistoryItem>> getAllPaintHistory() async {
    return await localDataSource.getAllHistory();
  }

  Future<void> deletePaintHistory(int index) async {
    await localDataSource.delete(index);
  }

  Future<void> clearAllHistory() async {
    await localDataSource.clearAll();
  }
}
