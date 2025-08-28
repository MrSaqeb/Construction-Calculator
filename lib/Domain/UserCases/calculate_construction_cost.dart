// lib/domain/usecases/calculate_construction_cost.dart

import '../entities/construction_cost.dart';

/// Use-case: perform calculation given raw input strings (safe parsing inside entity).
class CalculateConstructionCost {
  /// Returns a tuple-like Map with results.
  Map<String, double> execute({
    String? areaText,
    String? costText,
    double multiplier = 1.5,
  }) {
    final model = ConstructionCost.fromStrings(
      areaText: areaText,
      costText: costText,
    );
    final total = model.totalCost();
    final qty = model.materialQuantity(multiplier: multiplier);
    return {'totalCost': total, 'materialQuantity': qty};
  }
}
