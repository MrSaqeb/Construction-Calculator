import 'package:construction_calculator/Domain/entities/ruler.dart';

abstract class RulerRepository {
  Future<RulerEntity> moveLine({required bool isLeft, required double newY});
  Future<RulerEntity> reset();
  Future<RulerEntity> calibrate();
}
