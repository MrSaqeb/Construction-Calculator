import 'package:construction_calculator/Domain/entities/frequency_history_item.dart';
import 'package:construction_calculator/features/History/Data/frequency_history_local_data.dart';

abstract class IFrequencyHistoryRepository {
  Future<void> add(FrequencyHistoryItem item);
  List<FrequencyHistoryItem> getAll();
  Future<void> delete(int index);
  Future<void> clear();
}

class FrequencyHistoryRepository implements IFrequencyHistoryRepository {
  final FrequencyHistoryLocalData local;

  FrequencyHistoryRepository(this.local);

  @override
  Future<void> add(FrequencyHistoryItem item) => local.add(item);

  @override
  List<FrequencyHistoryItem> getAll() => local.getAll();

  @override
  Future<void> delete(int index) => local.delete(index);

  @override
  Future<void> clear() => local.clear();
}
