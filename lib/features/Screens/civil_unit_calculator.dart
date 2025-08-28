// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/civilunitconversion_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class UnitConversionCalculator extends ConsumerStatefulWidget {
  const UnitConversionCalculator({super.key});

  @override
  ConsumerState<UnitConversionCalculator> createState() =>
      _UnitConversionCalculatorState();
}

class _UnitConversionCalculatorState
    extends ConsumerState<UnitConversionCalculator> {
  final Color orangeColor = const Color(0xFFFF9C00);

  // --- Controllers & Variables ---
  final TextEditingController inputValue = TextEditingController();
  final List<String> decimalOptions = ["1", "2", "3", "Scientific"];
  String selectedDecimalOption = "1";

  // Conversion Type Lists
  final Map<String, List<String>> unitCategories = {
    "Length": [
      "Meter",
      "Kilometer",
      "Centimeter",
      "Millimeter",
      "Feet",
      "Inch",
      "Yard",
      "Mile",
    ],
    "Area": [
      "Sq.Meter",
      "Sq.Kilometer",
      "Sq.Feet",
      "Sq.Inch",
      "Hectare",
      "Acre",
    ],
    "Volume": ["Cubic Meter", "Cubic Feet", "Liter", "Milliliter", "Gallon"],
    "Weight": ["Kilogram", "Gram", "Tonne", "Pound", "Ounce"],
  };

  // Default selections
  String selectedConversionType = "Length";
  late String selectedUnit = unitCategories["Length"]!.first;
  late String targetUnit = unitCategories["Length"]!.last;

  double? convertedValue;

  // Conversion Factors (base system me rakho)
  final Map<String, double> lengthFactors = {
    "Meter": 1.0,
    "Kilometer": 1000.0,
    "Centimeter": 0.01,
    "Millimeter": 0.001,
    "Feet": 0.3048,
    "Inch": 0.0254,
    "Yard": 0.9144,
    "Mile": 1609.34,
  };

  final Map<String, double> areaFactors = {
    "Sq.Meter": 1.0,
    "Sq.Kilometer": 1e6,
    "Sq.Feet": 0.092903,
    "Sq.Inch": 0.00064516,
    "Hectare": 10000.0,
    "Acre": 4046.86,
  };

  final Map<String, double> volumeFactors = {
    "Cubic Meter": 1.0,
    "Cubic Feet": 0.0283168,
    "Liter": 0.001,
    "Milliliter": 1e-6,
    "Gallon": 0.00378541, // US Gallon
  };

  final Map<String, double> weightFactors = {
    "Kilogram": 1.0,
    "Gram": 0.001,
    "Tonne": 1000.0,
    "Pound": 0.453592,
    "Ounce": 0.0283495,
  };

  void _calculate() {
    final val = double.tryParse(inputValue.text) ?? 0;
    if (val <= 0) return;

    Map<String, double> factors;

    switch (selectedConversionType) {
      case "Length":
        factors = lengthFactors;
        break;
      case "Area":
        factors = areaFactors;
        break;
      case "Volume":
        factors = volumeFactors;
        break;
      case "Weight":
        factors = weightFactors;
        break;
      default:
        factors = {};
    }

    if (factors.containsKey(selectedUnit) && factors.containsKey(targetUnit)) {
      double inBase = val * (factors[selectedUnit] ?? 1);
      double result = inBase / (factors[targetUnit] ?? 1);

      setState(() {
        convertedValue = result;
      });

      // ✅ save conversion to history
      saveCivilUnitHistory(
        ref,
        inputValue: inputValue.text,
        fromUnit: selectedUnit,
        toUnit: targetUnit,
        resultValue: result.toString(),
      );
    } else {
      setState(() {
        convertedValue = null;
      });
    }
  }

  Future<void> saveCivilUnitHistory(
    WidgetRef ref, {
    required String inputValue,
    required String fromUnit,
    required String toUnit,
    required String resultValue,
  }) async {
    final historyItem = ConversionHistory(
      inputValue: inputValue,
      fromUnit: fromUnit,
      toUnit: toUnit,
      resultValue: resultValue,
      timestamp: DateTime.now(),
    );

    // agar box closed ho to bhi provider ko call kare
    ref.read(unifiedHistoryProvider.notifier).addCivilUnit(historyItem);
  }

  @override
  void initState() {
    super.initState();
    selectedUnit = unitCategories[selectedConversionType]!.first;
    targetUnit = unitCategories[selectedConversionType]!.length > 1
        ? unitCategories[selectedConversionType]![1]
        : unitCategories[selectedConversionType]!.first;
  }

  // Conversion Type Dropdown
  Widget _buildConversionTypeDropdown(Color textColor) {
    return DropdownButton<String>(
      value: selectedConversionType,
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down, color: orangeColor, size: 23),

      underline: Container(height: 0),
      style: TextStyle(
        color: orangeColor,
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      onChanged: (v) {
        setState(() {
          selectedConversionType = v!;
          selectedUnit = unitCategories[selectedConversionType]!.first;
          targetUnit = unitCategories[selectedConversionType]!.length > 1
              ? unitCategories[selectedConversionType]![1]
              : selectedUnit;
        });
      },
      items: unitCategories.keys
          .map(
            (type) => DropdownMenuItem(
              value: type,
              child: Center(child: Text(type)),
            ),
          )
          .toList(),
    );
  }

  // Units Dropdown (Dynamic for "From" unit)
  Widget _buildUnitDropdown(Color textColor) {
    return DropdownButton<String>(
      value: selectedUnit,
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down, color: orangeColor, size: 23),
      elevation: 16,
      underline: Container(height: 0),
      style: TextStyle(
        color: orangeColor,
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      onChanged: (v) {
        setState(() {
          selectedUnit = v!;
          // agar dono same ho jaye to target alag set karo
          if (selectedUnit == targetUnit) {
            final list = unitCategories[selectedConversionType]!;
            targetUnit = list.firstWhere(
              (u) => u != selectedUnit,
              orElse: () => selectedUnit,
            );
          }
        });
      },
      items: unitCategories[selectedConversionType]!
          .map(
            (unit) => DropdownMenuItem(
              value: unit,
              child: Center(child: Text(unit)),
            ),
          )
          .toList(),
    );
  }

  Widget _builddecimalDropdown(Color textColor) {
    return DropdownButton<String>(
      value: selectedDecimalOption,
      icon: Icon(Icons.arrow_drop_down, color: orangeColor, size: 22),
      elevation: 16,
      isExpanded: true,
      style: TextStyle(
        color: orangeColor,
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      underline: Container(height: 0),
      onChanged: (v) => setState(() {
        selectedDecimalOption = v!;
      }),
      selectedItemBuilder: (context) {
        return decimalOptions.map((v) => Center(child: Text(v))).toList();
      },
      items: decimalOptions
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
    );
  }

  Widget _suffixInput({
    required TextEditingController controller,
    required String unit,
    TextInputType type = const TextInputType.numberWithOptions(decimal: true),
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(50),
          right: Radius.circular(50),
        ),
        border: Border.all(color: orangeColor, width: 2),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Text(
              "Value",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: type,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: textColor,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: '10',
                hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
              ),
            ),
          ),
          Container(
            width: 65,
            alignment: Alignment.center,
            child: Text(
              unit,
              style: TextStyle(
                color: orangeColor,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultTable(Color textColor) {
    if (inputValue.text.isEmpty) return const SizedBox.shrink();

    final double? val = double.tryParse(inputValue.text);
    if (val == null || val <= 0) return const SizedBox.shrink();

    // 🔹 Factor Map Select karo based on Conversion Type
    Map<String, double> factors;
    switch (selectedConversionType) {
      case "Length":
        factors = lengthFactors;
        break;
      case "Area":
        factors = areaFactors;
        break;
      case "Volume":
        factors = volumeFactors;
        break;
      case "Weight":
        factors = weightFactors;
        break;
      default:
        factors = {};
    }

    // 🔹 Base value (selected unit se convert karke)
    double baseValue = val * (factors[selectedUnit] ?? 1);

    // 🔹 Decimal precision handle karna
    String formatValue(double number) {
      if (selectedDecimalOption == "Scientific") {
        return number.toStringAsExponential(2);
      } else {
        int decimals = int.tryParse(selectedDecimalOption) ?? 2;
        return number.toStringAsFixed(decimals);
      }
    }

    // 🔹 Table rows create karna
    final List<TableRow> rows = factors.keys.map((unit) {
      double result = baseValue / (factors[unit] ?? 1);
      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              unit,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              formatValue(result),
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      );
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white38,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculation & Result',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Table(
            border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
            columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(2)},
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Unit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF9C00),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Value',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF9C00),
                      ),
                    ),
                  ),
                ],
              ),
              ...rows,
            ],
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
          "Civil Unit Conversion",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/icons/civil_unit_icon.svg',
                height: 90,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 18),
            //conversion type dropdown
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                  width: 0.2,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Conversion Type',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 55,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(50),
                        right: Radius.circular(50),
                      ),
                      border: Border.all(color: orangeColor, width: 2),
                    ),
                    child: _buildConversionTypeDropdown(textColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                  width: 0.2,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Units',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 55,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(50),
                        right: Radius.circular(50),
                      ),
                      border: Border.all(color: orangeColor, width: 2),
                    ),
                    child: _buildUnitDropdown(textColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _suffixInput(controller: inputValue, unit: selectedUnit),
            const SizedBox(height: 8),
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                  width: 0.2,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Decimal Precision',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 55,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(50),
                        right: Radius.circular(50),
                      ),
                      border: Border.all(color: orangeColor, width: 2),
                    ),
                    child: _builddecimalDropdown(textColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // calculate button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Result',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _resultTable(textColor),
          ],
        ),
      ),
    );
  }
}
