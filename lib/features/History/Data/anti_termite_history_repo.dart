import 'package:construction_calculator/Domain/entities/anti_termite_history_item.dart';
import 'package:construction_calculator/features/History/Data/anit_termite_local_history_data.dart';

class AntiTermiteRepository {
  final AntiTermiteLocalDataSource localDataSource;

  AntiTermiteRepository({required this.localDataSource});

  Future<void> saveHistory(AntiTermiteHistoryItem item) async {
    await localDataSource.save(item);
  }

  Future<List<AntiTermiteHistoryItem>> getHistory() async {
    return await localDataSource.getAll();
  }

  Future<void> deleteHistory(int key) async {
    await localDataSource.delete(key);
  }

  Future<void> clearHistory() async {
    await localDataSource.clearAll();
  }
}
