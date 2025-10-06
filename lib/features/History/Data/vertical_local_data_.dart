import 'package:hive/hive.dart';
import 'package:construction_calculator/Domain/entities/vertical_cylinder_item.dart';

class VerticalCylinderLocalDataSource {
  final Box<VerticalCylinderHistoryItem> box;

  VerticalCylinderLocalDataSource(this.box);

  Future<void> add(VerticalCylinderHistoryItem item) async =>
      await box.add(item);

  List<VerticalCylinderHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
