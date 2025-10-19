// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/circle_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';

class QuadilateralCalculator extends ConsumerStatefulWidget {
  const QuadilateralCalculator({super.key});

  @override
  ConsumerState<QuadilateralCalculator> createState() =>
      _QuadilateralCalculatorState();
}

class _QuadilateralCalculatorState
    extends ConsumerState<QuadilateralCalculator> {
  final Color orangeColor = const Color(0xFFFF9C00);

  final TextEditingController base1Controller = TextEditingController();
  final TextEditingController base2Controller = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String selectedUnit = "Meter";
  Map<String, double> convertedValues = {};
  double areaResult = 0;
  double perimeterResult = 0;
  bool _viewOtherUnits = false;

  final List<String> units = [
    'Meter',
    'Feet',
    'Yard',
    'Inch',
    'Mile',
    'KiloMeter',
    'CentiMeter',
  ];

  void _calculate() {
    final double? base1Input = double.tryParse(base1Controller.text);
    final double? base2Input = double.tryParse(base2Controller.text);
    final double? heightInput = double.tryParse(heightController.text);

    if (base1Input == null || base2Input == null || heightInput == null) return;

    final Map<String, double> unitToMeter = {
      'Meter': 1,
      'Feet': 0.3048,
      'Yard': 0.9144,
      'Inch': 0.0254,
      'Mile': 1609.34,
      'KiloMeter': 1000,
      'CentiMeter': 0.01,
    };

    final double base1M = base1Input * unitToMeter[selectedUnit]!;
    final double base2M = base2Input * unitToMeter[selectedUnit]!;
    final double heightM = heightInput * unitToMeter[selectedUnit]!;

    // ✅ Area in m²
    final double areaM2 = ((base1M + base2M) / 2) * heightM;

    // ✅ Perimeter in meters (assuming non-parallel sides = height)
    final double perimeterM = base1M + base2M + 2 * heightM;

    // ✅ Convert back to selected unit
    final double areaSelected =
        areaM2 / (unitToMeter[selectedUnit]! * unitToMeter[selectedUnit]!);
    final double perimeterSelected = perimeterM / unitToMeter[selectedUnit]!;

    final Map<String, double> areaTable = {};
    for (var u in units) {
      areaTable[u] = areaM2 / (unitToMeter[u]! * unitToMeter[u]!);
    }

    setState(() {
      areaResult = areaSelected;
      perimeterResult = perimeterSelected;
      convertedValues = areaTable;
    });

    _saveHistory();
  }

  void _saveHistory() {
    final double? base1Val = double.tryParse(base1Controller.text);
    if (base1Val == null) return;

    final areaItem = CircleHistoryItem(
      inputValue: base1Val,
      inputUnit: selectedUnit,
      resultType: "Area",
      resultValue: areaResult,
      savedAt: DateTime.now(),
    );

    final perimeterItem = CircleHistoryItem(
      inputValue: base1Val,
      inputUnit: selectedUnit,
      resultType: "Perimeter",
      resultValue: perimeterResult,
      savedAt: DateTime.now(),
    );

    ref.read(unifiedHistoryProvider.notifier).addCircle(areaItem);
    ref.read(unifiedHistoryProvider.notifier).addCircle(perimeterItem);
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
          if (controller != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 8),
                child: TextField(
                  controller: controller,
                  keyboardType: type,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText ?? '0',
                    hintStyle: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => _calculate(),
                ),
              ),
            ),
          if (dropdownOptions != null && dropdownOptions.isNotEmpty)
            Container(
              height: 55,
              width: 115,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: _buildDropdown(
                options: dropdownOptions,
                selectedValue: selectedValue ?? dropdownOptions.first,
                onChanged: (v) {
                  if (onChanged != null) onChanged(v);
                  _calculate();
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
      final value = e.value.toStringAsFixed(2);
      return [unit, value];
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
                const TextSpan(
                  text: "Area Calculator Result for ",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "Quadrilateral",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: orangeColor,
                  ),
                ),
                const TextSpan(
                  text: " :",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
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
              const TableRow(
                children: [
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
                      child: Text(c, style: TextStyle(color: textColor)),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 8),
              child: TextField(
                controller: controller,
                readOnly: true,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hintText ?? '0',
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          if (suffixText != null)
            Container(
              height: 55,
              width: 115,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(50),
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
          "Quadrilateral Area Converter",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 15,
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
                'assets/icons/quadrilateral.svg',
                height: 150,
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
                  "Area = (B1 + B2)/2 × H",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _suffixInputWithDropdown(
              hintText: "Enter Base 1 (B1):",
              controller: base1Controller,
              dropdownOptions: units,
              selectedValue: selectedUnit,
              onChanged: (v) => setState(() => selectedUnit = v!),
            ),
            const SizedBox(height: 10),
            _suffixInputWithDropdown(
              hintText: "Enter Base 2 (B2):",
              controller: base2Controller,
              dropdownOptions: units,
              selectedValue: selectedUnit,
              onChanged: (v) => setState(() => selectedUnit = v!),
            ),
            const SizedBox(height: 10),
            _suffixInputWithDropdown(
              hintText: "Enter Height (H):",
              controller: heightController,
              dropdownOptions: units,
              selectedValue: selectedUnit,
              onChanged: (v) => setState(() => selectedUnit = v!),
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
              controller: TextEditingController(
                text: "${areaResult.toStringAsFixed(2)} $selectedUnit²",
              ),
              suffixText: "Area",
            ),
            const SizedBox(height: 10),
            _suffixInputWithText(
              controller: TextEditingController(
                text: perimeterResult.toStringAsFixed(2),
              ),
              suffixText: "Perimeter",
            ),
            if (_viewOtherUnits) ...[
              const SizedBox(height: 10),
              _resultTable(textColor),
              const SizedBox(height: 10),
            ],
            Center(
              child: TextButton(
                onPressed: () =>
                    setState(() => _viewOtherUnits = !_viewOtherUnits),
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
