// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';

class TriangleCalculator extends ConsumerStatefulWidget {
  const TriangleCalculator({super.key});

  @override
  ConsumerState<TriangleCalculator> createState() => _TriangleCalculatorState();
}

class _TriangleCalculatorState extends ConsumerState<TriangleCalculator> {
  final Color orangeColor = const Color(0xFFFF9C00);

  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();
  final TextEditingController cController = TextEditingController();

  // Default selected unit
  String selectedUnit = "Meter";

  // Converted values
  Map<String, double> convertedValues = {};
  double areaResult = 0;
  double perimeterResult = 0;
  bool _viewOtherUnits = false;
  // Available pressure units
  final List<String> pressureUnits = [
    'Meter',
    'Feet',
    'Yard', // PSI',
    'Inch',
    'Mile',
    'KiloMeter',
    'CentiMeter',
  ];

  // Convert given value from selectedUnit to meters
  double toMeters(double value, String unit) {
    switch (unit) {
      case 'Feet':
        return value * 0.3048;
      case 'Yard':
        return value * 0.9144;
      case 'Inch':
        return value * 0.0254;
      case 'Mile':
        return value * 1609.34;
      case 'KiloMeter':
        return value * 1000;
      case 'CentiMeter':
        return value * 0.01;
      default: // Meter
        return value;
    }
  }

  // Convert value in meters back to target unit
  double fromMeters(double value, String unit) {
    switch (unit) {
      case 'Feet':
        return value / 0.3048;
      case 'Yard':
        return value / 0.9144;
      case 'Inch':
        return value / 0.0254;
      case 'Mile':
        return value / 1609.34;
      case 'KiloMeter':
        return value / 1000;
      case 'CentiMeter':
        return value / 0.01;
      default: // Meter
        return value;
    }
  }

  void _calculate() {
    final double? aInput = double.tryParse(aController.text);
    final double? bInput = double.tryParse(bController.text);
    final double? cInput = double.tryParse(cController.text);

    if (aInput == null || bInput == null || cInput == null) return;

    // Step 1: Convert inputs to meters
    final double a = toMeters(aInput, selectedUnit);
    final double b = toMeters(bInput, selectedUnit);
    final double c = toMeters(cInput, selectedUnit);

    // Step 2: Perimeter (in meters)
    final double perimeterMeters = a + b + c;

    // Step 3: Semi-perimeter
    final double s = perimeterMeters / 2;

    // Step 4: Area using Heron's formula (in meters²)
    final double areaMeters = sqrt(s * (s - a) * (s - b) * (s - c));

    // Step 5: Convert back to selected unit
    final double perimeterConverted = fromMeters(perimeterMeters, selectedUnit);
    final double areaConverted =
        areaMeters *
        pow(fromMeters(1, selectedUnit), 2); // ✅ only one conversion for unit²

    setState(() {
      perimeterResult = perimeterConverted;
      areaResult = areaConverted;

      // ✅ Fill converted values table (all units in area²)
      convertedValues = {
        for (var unit in pressureUnits)
          unit: areaMeters * pow(fromMeters(1, unit), 2),
      };
    });
  }

  // DROPDOWN BUILDER
  Widget _buildDropdown({
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: selectedValue,
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
      onChanged: onChanged,
      selectedItemBuilder: (context) {
        return options.map((v) => Center(child: Text(v))).toList();
      },
      items: options
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
    );
  }

  Widget _suffixInputWithDropdown({
    String? hintText,
    TextEditingController? controller,
    List<String>? dropdownOptions,
    String? selectedValue,
    ValueChanged<String?>? onChanged,
    TextInputType type = const TextInputType.numberWithOptions(decimal: true),
    ValueChanged<String>? onChangedInput,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.4),
      ),
      child: Row(
        children: [
          // Input field with hint
          if (controller != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 8),
                child: TextField(
                  controller: controller,
                  keyboardType: type,
                  textAlign: TextAlign.left, // left align input and hint
                  textAlignVertical:
                      TextAlignVertical.center, // vertical center
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText ?? '0', // ✅ labelText becomes hint
                    hintStyle: TextStyle(
                      color: textColor.withOpacity(0.5), // theme-aware color
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onChangedInput,
                ),
              ),
            ),

          // Dropdown at the end
          if (dropdownOptions != null && dropdownOptions.isNotEmpty)
            Container(
              height: 55,
              width: 115,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(50),
                  right: Radius.circular(50),
                ),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: _buildDropdown(
                options: dropdownOptions,
                selectedValue: selectedValue ?? dropdownOptions.first,
                onChanged: (v) {
                  if (onChanged != null) onChanged(v);
                  _calculate(); // dropdown change callback
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _resultTable(Color textColor) {
    if (convertedValues.isEmpty) return const SizedBox.shrink();

    final rows = convertedValues.entries.map((e) {
      final unit = e.key;
      final value = e.value;

      return [unit, value.toStringAsFixed(2)];
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white38,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Area Calculator Result for ",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black, // black text
                  ),
                ),
                TextSpan(
                  text: "Circle",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: orangeColor, // orange text
                  ),
                ),
                TextSpan(
                  text: " :",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black, // black color for colon
                  ),
                ),
              ],
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
                      'Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF9C00),
                      ),
                    ),
                  ),
                ],
              ),
              ...rows.map(
                (r) => TableRow(
                  children: r.map((c) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        c,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _suffixInputWithText({
    String? hintText,
    TextEditingController? controller,
    String? suffixText,
    ValueChanged<String>? onChangedInput,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.4),
      ),
      child: Row(
        children: [
          // Input field (readonly result bhi ho sakta hai)
          if (controller != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 8),
                child: TextField(
                  controller: controller,
                  readOnly: true, // 👈 result field hai, user edit na kare
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText ?? '0',
                    hintStyle: TextStyle(
                      color: textColor,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onChangedInput,
                ),
              ),
            ),

          // ✅ Fixed Text (Area + unit OR Perimeter + unit)
          if (suffixText != null)
            Container(
              height: 55,
              width: 115,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(50),
                  right: Radius.circular(50),
                ),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: Text(
                suffixText,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: orangeColor,
                  fontWeight: FontWeight.w600,
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
          "Triangle Area Converter",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 17,
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
                'assets/icons/triangle.svg',
                height: 150,
                color: orangeColor,
              ),
            ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Formula:",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Area = √[s(s - a)(s - b)(s - c)]\n While:\n s = (a + b + c) / 2",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            _suffixInputWithDropdown(
              hintText: "Enter Edge 1(a) :",
              controller: aController,
              dropdownOptions: pressureUnits,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate(); // ✅ unit change hone par result update
              },
              onChangedInput: (value) {
                _calculate(); // ✅ input change hone par result update
              },
            ),
            const SizedBox(height: 10),

            _suffixInputWithDropdown(
              hintText: "Enter Edge 2(b) :",
              controller: bController,
              dropdownOptions: pressureUnits,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate(); // ✅ unit change hone par result update
              },
              onChangedInput: (value) {
                _calculate(); // ✅ input change hone par result update
              },
            ),
            const SizedBox(height: 10),

            _suffixInputWithDropdown(
              hintText: "Enter Edge 3(c) :",
              controller: cController,
              dropdownOptions: pressureUnits,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate(); // ✅ unit change hone par result update
              },
              onChangedInput: (value) {
                _calculate(); // ✅ input change hone par result update
              },
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Result:",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),

            _suffixInputWithText(
              hintText: "Result",
              controller: TextEditingController(
                text: "${areaResult.toStringAsFixed(2)} $selectedUnit²",
              ),
              suffixText: "Area",
            ),

            const SizedBox(height: 10),

            _suffixInputWithText(
              hintText: "Result",
              controller: TextEditingController(
                text: perimeterResult.toStringAsFixed(2),
              ),
              suffixText: "Perimeter",
            ),

            /// Result Table toggle
            if (_viewOtherUnits) ...[
              const SizedBox(height: 10),

              // ✅ Table show when true
              _resultTable(textColor),

              const SizedBox(height: 10),
            ],

            /// Toggle Button
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _viewOtherUnits = !_viewOtherUnits;
                  });
                },
                child: Text(
                  _viewOtherUnits
                      ? "Hide Results in Other Units"
                      : "View Results in Other Units",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationColor: Color(0xFFFF9C00),
                    color: Color(0xFFFF9C00),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
