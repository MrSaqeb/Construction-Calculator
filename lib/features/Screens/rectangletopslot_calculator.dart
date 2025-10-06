// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/rectangleslot_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';

class RectangleTopSlotCalculator extends ConsumerStatefulWidget {
  const RectangleTopSlotCalculator({super.key});

  @override
  ConsumerState<RectangleTopSlotCalculator> createState() =>
      _RectangleTopSlotCalculatorState();
}

class _RectangleTopSlotCalculatorState
    extends ConsumerState<RectangleTopSlotCalculator> {
  final Color orangeColor = const Color(0xFFFF9C00);

  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();
  final TextEditingController cController = TextEditingController();

  final TextEditingController dController = TextEditingController();

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
  void _calculate() {
    final double? a = double.tryParse(aController.text);
    final double? b = double.tryParse(bController.text);
    final double? c = double.tryParse(cController.text);
    final double? d = double.tryParse(dController.text);

    if (a == null || b == null || c == null || d == null) {
      areaResult = 0;
      perimeterResult = 0;
      convertedValues.clear();
      return;
    }

    // Conversion factors to meters
    final Map<String, double> unitToMeter = {
      'Meter': 1,
      'Feet': 0.3048,
      'Yard': 0.9144,
      'Inch': 0.0254,
      'Mile': 1609.34,
      'KiloMeter': 1000,
      'CentiMeter': 0.01,
    };

    // Convert to meters
    double aM = a * (unitToMeter[selectedUnit] ?? 1.0);
    double bM = b * (unitToMeter[selectedUnit] ?? 1.0);
    double cM = c * (unitToMeter[selectedUnit] ?? 1.0);
    double dM = d * (unitToMeter[selectedUnit] ?? 1.0);

    // Area calculation
    double areaM2 = (aM * bM) - (cM * dM);

    // Approximate perimeter (rectangle perimeter + slot edges)
    double perimeterM =
        2 * (aM + bM) + 2 * (cM + dM); // optional simple approximation

    // Convert back to selected unit
    double factor = unitToMeter[selectedUnit] ?? 1.0;
    areaResult = areaM2 / (factor * factor);
    perimeterResult = perimeterM / factor;

    // Conversion table for area
    convertedValues.clear();
    for (var unit in pressureUnits) {
      double f = unitToMeter[unit] ?? 1.0;
      convertedValues[unit] = areaM2 / (f * f);
    }

    setState(() {});
    _saveHistory();
  }

  void _saveHistory() {
    final double? aVal = double.tryParse(aController.text);
    final double? bVal = double.tryParse(bController.text);
    final double? cVal = double.tryParse(cController.text);
    final double? dVal = double.tryParse(dController.text);

    if (aVal == null || bVal == null || cVal == null || dVal == null) return;

    final item = RectangleWithSlotHistoryItem(
      a: aVal,
      b: bVal,
      c: cVal,
      d: dVal,
      unit: selectedUnit,
      area: areaResult,
      perimeter: perimeterResult,
      savedAt: DateTime.now(),
    );

    final notifier = ref.read(unifiedHistoryProvider.notifier);
    notifier.addRectangleSlot(item);
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
          "Top Slot Area Converter",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 18,
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
                'assets/icons/topslot.svg',
                height: 130,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 15),
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
                  "Area = (A x B) + (C x D)",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textColor, // theme-aware
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _suffixInputWithDropdown(
              hintText: "Enter Size(A):",
              controller: aController,
              dropdownOptions: pressureUnits,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate();
              },
              onChangedInput: (v) => _calculate(),
            ),

            const SizedBox(height: 10),

            _suffixInputWithDropdown(
              hintText: "Enter Size(B):",
              controller: bController,
              dropdownOptions: pressureUnits,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate();
              },
              onChangedInput: (v) => _calculate(),
            ),
            const SizedBox(height: 10),

            _suffixInputWithDropdown(
              hintText: "Enter Size(C):",
              controller: cController,
              dropdownOptions: pressureUnits,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate();
              },
              onChangedInput: (v) => _calculate(),
            ),
            const SizedBox(height: 10),

            _suffixInputWithDropdown(
              hintText: "Enter Size (D):",
              controller: dController,
              dropdownOptions: pressureUnits,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate();
              },
              onChangedInput: (v) => _calculate(),
            ),
            const SizedBox(height: 10),

            Text(
              "Result:",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
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
