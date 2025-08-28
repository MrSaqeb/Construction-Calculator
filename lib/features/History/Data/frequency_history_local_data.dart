import 'package:construction_calculator/Domain/entities/frequency_history_item.dart';
import 'package:hive/hive.dart';

class FrequencyHistoryLocalData {
  final Box<FrequencyHistoryItem> box;

  FrequencyHistoryLocalData(this.box);

  Future<void> add(FrequencyHistoryItem item) async => await box.add(item);

  List<FrequencyHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
