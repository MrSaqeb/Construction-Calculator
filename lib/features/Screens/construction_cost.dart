// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads

import 'dart:io';
import 'package:construction_calculator/Domain/entities/construction_cost_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:construction_calculator/Core/theme/app_fonts.dart';

class ConstructionCostScreen extends ConsumerStatefulWidget {
  const ConstructionCostScreen({super.key});

  @override
  ConsumerState<ConstructionCostScreen> createState() =>
      _ConstructionCostScreenState();
}

class _ConstructionCostScreenState
    extends ConsumerState<ConstructionCostScreen> {
  final TextEditingController areaController = TextEditingController();
  final TextEditingController costController = TextEditingController();

  double? totalCost;
  bool _viewMore = false;
  String selectedUnit = "PKR";
  final Color orangeColor = const Color(0xFFFF9C00);

  // 20+ Countries Currencies
  final Map<String, String> currencyOptions = {
    'PKR': 'Pakistani Rupee',
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'INR': 'Indian Rupee',
    'AED': 'UAE Dirham',
    'SAR': 'Saudi Riyal',
    'CNY': 'Chinese Yuan',
    'JPY': 'Japanese Yen',
    'CAD': 'Canadian Dollar',
    'AUD': 'Australian Dollar',
    'SGD': 'Singapore Dollar',
    'MYR': 'Malaysian Ringgit',
    'THB': 'Thai Baht',
    'KRW': 'South Korean Won',
    'TRY': 'Turkish Lira',
    'RUB': 'Russian Ruble',
    'BHD': 'Bahraini Dinar',
    'QAR': 'Qatari Riyal',
    'OMR': 'Omani Rial',
    'KWD': 'Kuwaiti Dinar',
  };

  // Conversion rates (example rates, update with real values)
  final Map<String, double> conversionRates = {
    'PKR': 1.0, // Base currency
    'USD': 280.0, // 1 USD = 280 PKR
    'EUR': 300.0,
    'GBP': 350.0,
    'INR': 3.5,
    'AED': 76.0,
    'SAR': 75.0,
    'CNY': 40.0,
    'JPY': 2.0,
    'CAD': 210.0,
    'AUD': 190.0,
    'SGD': 210.0,
    'MYR': 65.0,
    'THB': 8.0,
    'KRW': 0.22,
    'TRY': 15.0,
    'RUB': 3.0,
    'BHD': 740.0,
    'QAR': 77.0,
    'OMR': 720.0,
    'KWD': 900.0,
  };

  // Material Quantities
  Map<String, String> materialQuantities = {
    "Cement": "0 Bags",
    "Sand": "0 CFT",
    "Aggregate": "0 CFT",
    "Steel": "0 Kg",
    "Paint": "0 lt",
  };

  // Material Costs
  Map<String, String> materialCosts = {
    "Cement": "0 PKR",
    "Sand": "0 PKR",
    "Aggregate": "0 PKR",
    "Steel": "0 PKR",
    "Finishers": "0 PKR",
    "Fittings": "0 PKR",
    "Total Cost": "0 PKR",
  };

  @override
  void initState() {
    super.initState();
    _loadSavedUnit();
  }

  Future<void> _loadSavedUnit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedUnit = prefs.getString("selected_unit") ?? "PKR";
    });
  }

  Future<void> _saveUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selected_unit", unit);
  }

  Widget _buildCurrencyDropdown() {
    return DropdownButton<String>(
      value: selectedUnit,
      icon: Icon(Icons.arrow_drop_down, color: orangeColor, size: 23),
      elevation: 16,
      isExpanded: true,
      style: TextStyle(
        color: orangeColor,
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      underline: Container(height: 0),
      onChanged: (String? newValue) {
        setState(() {
          selectedUnit = newValue!;
          _saveUnit(selectedUnit);
          calculate();
        });
      },
      // Yeh selected text ko bhi center karega
      selectedItemBuilder: (context) {
        return currencyOptions.keys.map((value) {
          return Center(child: Text(value));
        }).toList();
      },
      items: currencyOptions.keys.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  void calculate() {
    final double? area = double.tryParse(areaController.text);
    final double? costPerSqFt = double.tryParse(costController.text);

    if (area == null || costPerSqFt == null) {
      setState(() {
        totalCost = null;
        materialQuantities = {
          "Cement": "0 Bags",
          "Sand": "0 CFT",
          "Aggregate": "0 CFT",
          "Steel": "0 Kg",
          "Paint": "0 lt",
          "Bricks": "0 Bricks",
        };
        materialCosts = {
          "Cement": "0 $selectedUnit",
          "Sand": "0 $selectedUnit",
          "Aggregate": "0 $selectedUnit",
          "Steel": "0 $selectedUnit",
          "Finishers": "0 $selectedUnit",
          "Fittings": "0 $selectedUnit",
          "Total Cost": "0 $selectedUnit",
        };
      });
      return;
    }

    final double totalCostPKR = area * costPerSqFt;

    final Map<String, double> costPercentages = {
      "Cement": 0.164,
      "Sand": 0.123,
      "Aggregate": 0.074,
      "Steel": 0.246,
      "Finishers": 0.165,
      "Fittings": 0.228,
    };

    final double rate = conversionRates[selectedUnit] ?? 1.0;

    final double cementCost = totalCostPKR * costPercentages["Cement"]!;
    final double sandCost = totalCostPKR * costPercentages["Sand"]!;
    final double aggregateCost = totalCostPKR * costPercentages["Aggregate"]!;
    final double steelCost = totalCostPKR * costPercentages["Steel"]!;
    final double finishersCost = totalCostPKR * costPercentages["Finishers"]!;
    final double fittingsCost = totalCostPKR * costPercentages["Fittings"]!;

    // Approximate quantities for other materials
    final double cementQty = area * 0.4; // Bags approx
    final double sandQty = area * 0.816; // CFT approx
    final double aggregateQty = area * 0.608; // CFT approx
    final double paintQty = area * 0.18; // lt approx

    // Steel calculation parameters
    final double steelDiameter = 12.0; // mm
    final double steelLength = 20.0; // ft
    final double approxSteelWeightKg = area * 4.0; // steel kg
    final double weightPerRodKg =
        (steelDiameter * steelDiameter / 162.28) * steelLength;
    final int numberOfRods = (approxSteelWeightKg / weightPerRodKg).ceil();
    final double steelWeightKg = numberOfRods * weightPerRodKg;

    // Bricks calculation
    const double bricksPerSqFt = 10; // 1 sq.ft me 10 bricks
    final double bricksQty = area * bricksPerSqFt;

    setState(() {
      totalCost = totalCostPKR / rate;

      materialQuantities = {
        "Cement": "${cementQty.toStringAsFixed(2)} Bags",
        "Sand": "${sandQty.toStringAsFixed(2)} CFT",
        "Aggregate": "${aggregateQty.toStringAsFixed(2)} CFT",
        "Steel": "${steelWeightKg.toStringAsFixed(2)} Kg",
        "Paint": "${paintQty.toStringAsFixed(2)} lt",
        "Bricks": "${bricksQty.toStringAsFixed(0)} Bricks",
      };

      materialCosts = {
        "Cement": "${(cementCost / rate).toStringAsFixed(2)} $selectedUnit",
        "Sand": "${(sandCost / rate).toStringAsFixed(2)} $selectedUnit",
        "Aggregate":
            "${(aggregateCost / rate).toStringAsFixed(2)} $selectedUnit",
        "Steel": "${(steelCost / rate).toStringAsFixed(2)} $selectedUnit",
        "Finishers":
            "${(finishersCost / rate).toStringAsFixed(2)} $selectedUnit",
        "Fittings": "${(fittingsCost / rate).toStringAsFixed(2)} $selectedUnit",
        "Total Cost":
            "${(totalCostPKR / rate).toStringAsFixed(2)} $selectedUnit",
      };
    });

    saveHistory();
  }

  void saveHistory() async {
    // Naya object create karo (copy of data)
    final newItem = ConstructionCostHistoryItem(
      area: double.tryParse(areaController.text) ?? 0,
      costInput: double.tryParse(costController.text) ?? 0,
      costPerSqFt: double.tryParse(costController.text) ?? 0,
      totalCost: totalCost ?? 0,
      materialQuantity:
          double.tryParse(materialQuantities["Cement"]?.split(" ")[0] ?? "0") ??
          0,
      unit: selectedUnit,
      dateTime: DateTime.now(),
      cementCost:
          double.tryParse(materialCosts["Cement"]?.split(" ")[0] ?? "0") ?? 0,
      sandCost:
          double.tryParse(materialCosts["Sand"]?.split(" ")[0] ?? "0") ?? 0,
      aggregateCost:
          double.tryParse(materialCosts["Aggregate"]?.split(" ")[0] ?? "0") ??
          0,
      streetCost:
          double.tryParse(materialCosts["Steel"]?.split(" ")[0] ?? "0") ?? 0,
      finishersCost:
          double.tryParse(materialCosts["Finishers"]?.split(" ")[0] ?? "0") ??
          0,
      fittingsCost:
          double.tryParse(materialCosts["Fittings"]?.split(" ")[0] ?? "0") ?? 0,
      cementQty:
          double.tryParse(materialQuantities["Cement"]?.split(" ")[0] ?? "0") ??
          0,
      sandQty:
          double.tryParse(materialQuantities["Sand"]?.split(" ")[0] ?? "0") ??
          0,
      aggregateQty:
          double.tryParse(
            materialQuantities["Aggregate"]?.split(" ")[0] ?? "0",
          ) ??
          0,
      paintQty:
          double.tryParse(materialQuantities["Paint"]?.split(" ")[0] ?? "0") ??
          0,
      streetQty:
          double.tryParse(materialQuantities["Steel"]?.split(" ")[0] ?? "0") ??
          0,
      bricksQty:
          double.tryParse(materialQuantities["Bricks"]?.split(" ")[0] ?? "0") ??
          0,
      materialCosts: Map.from(materialCosts),
      materialQuantities: Map.from(materialQuantities),
    );

    // StateNotifier ko update karo
    ref.read(unifiedHistoryProvider.notifier).addConstruction(newItem);
  }

  Widget _buildMaterialTable(
    BuildContext context,
    String title,
    Map<String, String> data,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor, // Title ka color light/dark ke hisaab se
          ),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
          columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(2)},
          children: [
            /// Header row (always orange)
            TableRow(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: const Text(
                    "Material",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9C00),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title.contains("Cost")
                        ? "Unit ($selectedUnit)"
                        : "Quantity",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9C00),
                    ),
                  ),
                ),
              ],
            ),

            /// Data rows
            ...data.entries.map((entry) {
              final formattedValue = title.contains("Cost")
                  ? formatCost(entry.value)
                  : formatQuantity(entry.value);

              final isTotalCostRow = entry.key.toLowerCase() == "total cost";

              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      entry.key,
                      style: isTotalCostRow
                          ? TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  textColor, // Total cost title dynamic color
                            )
                          : TextStyle(color: textColor), // Normal rows dynamic
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      formattedValue,
                      style: isTotalCostRow
                          ? const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF9C00), // Always orange
                            )
                          : TextStyle(color: textColor), // Normal rows dynamic
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String formatCost(String value) {
    // Try parse double and format to 4 decimal places
    final double? val = double.tryParse(value);
    if (val == null) return value;
    return val.toStringAsFixed(4);
  }

  String formatQuantity(String value) {
    // Value expected as "number unit", e.g. "5.00 Bags" or "12.5 Kg"
    final parts = value.split(' ');
    if (parts.isEmpty) return value;

    final numStr = parts[0];
    final unit = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    final double? numVal = double.tryParse(numStr);
    if (numVal == null) return value;

    // If integer, show without decimals, else show decimals as needed
    String formattedNum;
    if (numVal == numVal.roundToDouble()) {
      formattedNum = numVal.toInt().toString();
    } else {
      formattedNum = numVal.toString();
    }

    return "$formattedNum $unit".trim();
  }

  Widget buildInputField({
    required String hintText,
    required String unit,
    required TextEditingController controller,
    bool isDropdown = false,
    required Color textColor,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: textColor,
                ),
                decoration: InputDecoration(
                  hintText: hintText, // ✅ hint dikhaye jab field empty ho
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontWeight: FontWeight.w500,

                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          Container(
            height: 57,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(45),
                right: Radius.circular(45),
              ),
              border: Border.all(color: orangeColor, width: 2),
            ),
            child: isDropdown
                ? _buildCurrencyDropdown()
                : Center(
                    child: Text(
                      unit,
                      style: TextStyle(
                        color: orangeColor,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: orangeColor,
        leading: IconButton(
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Construction Cost",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),

            onPressed: () {
              // Navigate to History Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            SvgPicture.asset(
              "assets/icons/construction_cost_icon.svg",
              height: 80,
              color: orangeColor,
            ),
            const SizedBox(height: 20),
            buildInputField(
              hintText: "Enter Builtup Area",
              unit: "FT²",
              controller: areaController,
              textColor: textColor,
            ),
            const SizedBox(height: 16),
            buildInputField(
              hintText: "Enter Cost (Per Sq Feet)",

              unit: selectedUnit,
              controller: costController,
              isDropdown: true,
              textColor: textColor,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF9C00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Result",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            if (totalCost != null)
              Container(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white38,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Calculation & Result",
                      style: AppTheme.headingMedium.copyWith(color: textColor),
                    ),
                    const SizedBox(height: 10),

                    /// Cost result line
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: textColor,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "Approximate Cost Required:\n${areaController.text}FT² × ${costController.text}$selectedUnit/FT² = ",
                          ),
                          const TextSpan(text: "   "),
                          TextSpan(
                            text:
                                "${totalCost!.toStringAsFixed(0)} $selectedUnit",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: orangeColor, // Always orange
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Quantity result line
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: textColor,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "Quantity of Material Required (approx):\n${areaController.text}FT² × 1.5 = ",
                          ),
                          const TextSpan(text: "   "),
                          TextSpan(
                            text:
                                "${(double.parse(areaController.text) * 1.5).toStringAsFixed(0)} cubic feet",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: orangeColor, // Always orange
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Extra info section
                    if (_viewMore) ...[
                      Text(
                        "Assuming a multiplier of 1.5",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildMaterialTable(
                        context,
                        "Approximated Cost Required:",
                        materialCosts,
                      ),
                      _buildMaterialTable(
                        context,
                        "Quantity of Material Required:",
                        materialQuantities,
                      ),
                      const SizedBox(height: 12),
                    ],

                    /// View More / Less button (unchanged)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _viewMore = !_viewMore;
                          });
                        },
                        child: Text(
                          _viewMore ? "View Less" : "View More",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            decorationColor: const Color(0xFFFF9C00),
                            color: const Color(0xFFFF9C00), // Always orange
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
