import 'package:construction_calculator/Domain/entities/vertical_elliptical_item.dart';
import 'package:hive/hive.dart';

class VerticalEllipticalLocalDataSource {
  final Box<VerticalEllipticalItem> box;

  VerticalEllipticalLocalDataSource(this.box);

  Future<void> add(VerticalEllipticalItem item) async => await box.add(item);

  List<VerticalEllipticalItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
