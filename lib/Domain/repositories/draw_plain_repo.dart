import 'package:construction_calculator/Domain/entities/draw_plain_model.dart';

abstract class DrawRepository {
  Future<void> saveAction(DrawAction action);
  Future<List<DrawAction>> loadActions();
}
