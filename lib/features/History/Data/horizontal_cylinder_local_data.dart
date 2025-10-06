import 'package:construction_calculator/Domain/entities/horizontal_cylinder_item.dart';
import 'package:hive/hive.dart';

class HorizontalCylinderLocalDataSource {
  final Box<HorizontalCylinderItem> box;

  HorizontalCylinderLocalDataSource(this.box);

  Future<void> add(HorizontalCylinderItem item) async => await box.add(item);

  List<HorizontalCylinderItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
