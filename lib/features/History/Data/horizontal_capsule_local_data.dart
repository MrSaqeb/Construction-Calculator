import 'package:construction_calculator/Domain/entities/horizontal_capsule_item.dart';
import 'package:hive/hive.dart';

class HorizontalCapsuleLocalDataSource {
  final Box<HorizontalCapsuleItem> box;

  HorizontalCapsuleLocalDataSource(this.box);

  Future<void> add(HorizontalCapsuleItem item) async => await box.add(item);

  List<HorizontalCapsuleItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
