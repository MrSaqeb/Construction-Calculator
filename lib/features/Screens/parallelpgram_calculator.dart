// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/circle_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';

class ParallelpgramCalculator extends ConsumerStatefulWidget {
  const ParallelpgramCalculator({super.key});

  @override
  ConsumerState<ParallelpgramCalculator> createState() =>
      _ParallelpgramCalculatorState();
}

class _ParallelpgramCalculatorState
    extends ConsumerState<ParallelpgramCalculator> {
  final Color orangeColor = const Color(0xFFFF9C00);

  final TextEditingController baseController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController sideController = TextEditingController();

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
    final double? baseInput = double.tryParse(baseController.text);
    final double? heightInput = double.tryParse(heightController.text);
    final double? sideInput = double.tryParse(sideController.text);

    if (baseInput == null || heightInput == null || sideInput == null) return;

    // ✅ Conversion factors to meters
    final Map<String, double> unitToMeter = {
      'Meter': 1,
      'Feet': 0.3048,
      'Yard': 0.9144,
      'Inch': 0.0254,
      'Mile': 1609.34,
      'KiloMeter': 1000,
      'CentiMeter': 0.01,
    };

    // ✅ Convert values to meters
    final double baseInMeter = baseInput * unitToMeter[selectedUnit]!;
    final double heightInMeter = heightInput * unitToMeter[selectedUnit]!;
    final double sideInMeter = sideInput * unitToMeter[selectedUnit]!;

    // ✅ Area (m²)
    final double areaM2 = baseInMeter * heightInMeter;

    // ✅ Perimeter (m)

    // ✅ Convert back to selected unit
    final double baseInSelected = baseInMeter / unitToMeter[selectedUnit]!;
    final double heightInSelected = heightInMeter / unitToMeter[selectedUnit]!;
    final double sideInSelected = sideInMeter / unitToMeter[selectedUnit]!;

    final double areaInSelected = baseInSelected * heightInSelected;
    final double perimeterInSelected = 2 * (baseInSelected + sideInSelected);

    setState(() {
      areaResult = areaInSelected;
      perimeterResult = perimeterInSelected;

      // ✅ Conversion table
      convertedValues = {
        'meter²': areaM2,
        'feet²': areaM2 * 10.7639,
        'yard²': areaM2 * 1.19599,
        'inch²': areaM2 * 1550.003,
        'mile²': areaM2 / (1609.34 * 1609.34),
        'kilometer²': areaM2 / 1e6,
        'centimeter²': areaM2 * 10000,
        'acre': areaM2 * 0.000247105,
      };
    });

    _saveHistory();
  }

  void _saveHistory() {
    final double? baseVal = double.tryParse(baseController.text);
    final double? heightVal = double.tryParse(heightController.text);
    final double? sideVal = double.tryParse(sideController.text);

    if (baseVal == null || heightVal == null || sideVal == null) return;

    // Area item save karna
    final areaItem = CircleHistoryItem(
      inputValue:
          baseVal, // Agar multiple inputs save karna ho to list/string me store karo
      inputUnit: selectedUnit,
      resultType: "Area",
      resultValue: areaResult,
      savedAt: DateTime.now(),
    );
    ref.read(unifiedHistoryProvider.notifier).addCircle(areaItem);

    // Perimeter item save karna
    final perimeterItem = CircleHistoryItem(
      inputValue: baseVal,
      inputUnit: selectedUnit,
      resultType: "Perimeter",
      resultValue: perimeterResult,
      savedAt: DateTime.now(),
    );
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
                      color: textColor.withOpacity(0.5),
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
          "Parallelogram Area Converter",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 14,
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
                'assets/icons/parallelogram.svg',
                height: 180,
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
                  "Area=L x H",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            _suffixInputWithDropdown(
              hintText: "Enter Base (B):",
              controller: baseController,
              dropdownOptions: pressureUnits,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate(); // ✅ unit change hone par recalc
              },
              onChangedInput: (value) {
                _calculate(); // ✅ typing hone par recalc
              },
            ),
            const SizedBox(height: 10),

            _suffixInputWithDropdown(
              hintText: "Enter Height (H):",
              controller: heightController,
              dropdownOptions: pressureUnits,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate();
              },
              onChangedInput: (value) {
                _calculate();
              },
            ),
            const SizedBox(height: 10),

            _suffixInputWithDropdown(
              hintText:
                  "Enter Side (S):", // 👈 yahan "Side" likh lo, pehle "Base" likha tha
              controller: sideController,
              dropdownOptions: pressureUnits,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate();
              },
              onChangedInput: (value) {
                _calculate();
              },
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
