import 'package:construction_calculator/Domain/entities/vertical_capsule_item.dart';
import 'package:hive/hive.dart';

class VerticalCapsuleLocalDataSource {
  final Box<VerticalCapsuleItem> box;

  VerticalCapsuleLocalDataSource(this.box);

  Future<void> add(VerticalCapsuleItem item) async => await box.add(item);

  List<VerticalCapsuleItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
