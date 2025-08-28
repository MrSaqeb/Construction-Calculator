import 'package:construction_calculator/Domain/entities/excavation_history_item.dart';
import 'package:construction_calculator/features/History/Data/excavation_histoy_local_data.dart';

class ExcavationRepository {
  final ExcavationLocalDataSource localDataSource;

  ExcavationRepository(this.localDataSource);

  List<ExcavationHistoryItem> getHistory() => localDataSource.getHistory();

  Future<void> addHistory(ExcavationHistoryItem item) =>
      localDataSource.addHistory(item);

  Future<void> clearHistory() => localDataSource.clearHistory();

  Future<void> deleteHistoryItem(ExcavationHistoryItem item) =>
      localDataSource.deleteHistoryItem(item);
}
