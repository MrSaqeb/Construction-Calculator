import 'package:construction_calculator/Domain/entities/draw_plain_model.dart';
import 'package:construction_calculator/Domain/repositories/draw_plain_repo.dart';

class DrawRepositoryImpl implements DrawRepository {
  final List<DrawAction> _actions = [];

  @override
  Future<void> saveAction(DrawAction action) async {
    _actions.add(action);
  }

  @override
  Future<List<DrawAction>> loadActions() async {
    return _actions;
  }
}
