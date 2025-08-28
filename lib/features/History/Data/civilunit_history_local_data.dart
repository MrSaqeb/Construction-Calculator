import 'package:construction_calculator/Domain/entities/civilunitconversion_history_item.dart';
import 'package:hive/hive.dart';

class CivilunitHistoryLocalData {
  final Box<ConversionHistory> box;

  CivilunitHistoryLocalData(this.box);

  Future<void> add(ConversionHistory item) async => await box.add(item);

  List<ConversionHistory> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
