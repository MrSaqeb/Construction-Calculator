import 'package:shared_preferences/shared_preferences.dart';

class ConstructionCost {
  final double area;
  final double costPerSqFt;

  ConstructionCost({required this.area, required this.costPerSqFt});

  /// ✅ Null aur string conversion safe banane ke liye
  factory ConstructionCost.fromInput({String? areaText, String? costText}) {
    final double safeArea = double.tryParse(areaText?.trim() ?? '') ?? 0.0;
    final double safeCost = double.tryParse(costText?.trim() ?? '') ?? 0.0;

    return ConstructionCost(area: safeArea, costPerSqFt: safeCost);
  }

  /// ✅ Business Logic: Total Cost
  double calculateTotalCost() {
    return area * costPerSqFt;
  }

  /// ✅ Business Logic: Material Quantity
  double calculateMaterialQuantity({double multiplier = 1.5}) {
    return area * multiplier;
  }

  /// ✅ Convert to Map (local storage ke liye)
  Map<String, dynamic> toMap() {
    return {"area": area, "costPerSqFt": costPerSqFt};
  }

  /// ✅ Create from Map
  factory ConstructionCost.fromMap(Map<String, dynamic> map) {
    return ConstructionCost(
      area: (map["area"] ?? 0.0) as double,
      costPerSqFt: (map["costPerSqFt"] ?? 0.0) as double,
    );
  }

  /// ✅ Save to SharedPreferences
  static Future<void> saveToPrefs(ConstructionCost cost) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("area", cost.area);
    await prefs.setDouble("costPerSqFt", cost.costPerSqFt);
  }

  /// ✅ Load from SharedPreferences
  static Future<ConstructionCost> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final area = prefs.getDouble("area") ?? 0.0;
    final costPerSqFt = prefs.getDouble("costPerSqFt") ?? 0.0;
    return ConstructionCost(area: area, costPerSqFt: costPerSqFt);
  }

  // ignore: strict_top_level_inference
  static fromStrings({String? areaText, String? costText}) {}
}
