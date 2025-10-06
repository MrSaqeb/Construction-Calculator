import 'package:construction_calculator/Domain/entities/cone_bottom_history_item.dart';
import 'package:hive/hive.dart';

class ConeBottomLocalDataSource {
  final Box<ConeBottomHistoryItem> box;

  ConeBottomLocalDataSource(this.box);

  Future<void> add(ConeBottomHistoryItem item) async => await box.add(item);

  List<ConeBottomHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
