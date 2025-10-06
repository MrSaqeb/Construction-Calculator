import 'package:construction_calculator/Domain/entities/rectangular_prism_item.dart';
import 'package:hive/hive.dart';

class RectangularPrismLocalDataSource {
  final Box<RectangularPrismItem> box;

  RectangularPrismLocalDataSource(this.box);

  Future<void> add(RectangularPrismItem item) async => await box.add(item);

  List<RectangularPrismItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
