import 'package:construction_calculator/Domain/entities/horizontal_elliptical_item.dart';
import 'package:hive/hive.dart';

class HorizontalEllipticalLocalDataSource {
  final Box<HorizontalEllipticalHistoryItem> box;

  HorizontalEllipticalLocalDataSource(this.box);

  Future<void> add(HorizontalEllipticalHistoryItem item) async =>
      await box.add(item);

  List<HorizontalEllipticalHistoryItem> getAll() => box.values.toList();

  Future<void> delete(int index) async => await box.deleteAt(index);

  Future<void> clear() async => await box.clear();
}
