import 'package:construction_calculator/Domain/entities/ruler.dart';
import 'package:construction_calculator/Domain/repositories/ruler_repo.dart';

class MoveLine {
  final RulerRepository repo;
  MoveLine(this.repo);

  Future<RulerEntity> call({required bool isLeft, required double newY}) {
    return repo.moveLine(isLeft: isLeft, newY: newY);
  }
}

class ResetLines {
  final RulerRepository repo;
  ResetLines(this.repo);

  Future<RulerEntity> call() {
    return repo.reset();
  }
}

class CalibrateLines {
  final RulerRepository repo;
  CalibrateLines(this.repo);

  Future<RulerEntity> call() {
    return repo.calibrate();
  }
}
