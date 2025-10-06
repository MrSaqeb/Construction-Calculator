import 'package:construction_calculator/Domain/entities/frustum_history_item.dart';
import 'package:hive/hive.dart';

class FrustumLocalDataSource {
  final Box<FrustumHistoryItem> box;

  FrustumLocalDataSource(this.box);

  Future<void> add(FrustumHistoryItem item) async => await box.add(item);

  List<FrustumHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
