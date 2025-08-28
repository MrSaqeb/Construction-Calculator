// lib/domain/repositories/construction_cost_repository.dart

/// Repository interface for domain => implementation lives in data/infrastructure layer.
/// Keeps domain independent from SharedPreferences / DB / network.

// ignore_for_file: dangling_library_doc_comments

abstract class IConstructionCostRepository {
  /// Save user's selected currency/unit (e.g. "PKR", "USD").
  Future<void> saveSelectedUnit(String unit);

  /// Load previously saved unit; returns null if none saved.
  Future<String?> loadSelectedUnit();

  /// If you want to persist last inputs (optional), add:
  /// Future<void> saveLastInputs(String areaText, String costText);
  /// Future<Map<String, String>?> loadLastInputs();
}
