// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/distance_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AreaUnitConverter extends ConsumerStatefulWidget {
  const AreaUnitConverter({super.key});

  @override
  ConsumerState<AreaUnitConverter> createState() => _AreaUnitConverterState();
}

class _AreaUnitConverterState extends ConsumerState<AreaUnitConverter> {
  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // INPUT CONTROLLERS
  // Cost of Steel Controller
  final TextEditingController areaController = TextEditingController();

  // Result variables
  Map<String, double> convertedValues = {};

  // ================== OPTIONS ==================
  List<String> areaUnitOptions = [
    'Sq.Meter',
    'Sq.Foot',
    'Sq.Centimeter',
    'Sq.Millimeter',
    'Sq.Inch',
    'Sq.Yard',
    'Sq.Kilometer',
    'Sq.Mile',
    'Hectare',
    'Acre',
  ];
  String selectedUnit = "Sq.Foot";

  void _calculate() {
    final double? inputVal = double.tryParse(areaController.text);
    if (inputVal == null) return;

    // Area conversion factors (base = square meter)
    final Map<String, double> areaUnitToSquareMeter = {
      'Sq.Foot': 0.092903,
      'Sq.Centimeter': 0.0001,
      'Sq.Millimeter': 0.000001,
      'Sq.Inch': 0.00064516,
      'Sq.Yard': 0.836127,
      'Sq.Mile': 2589988.11,
      'Sq.Kilometer': 1000000,
      'Sq.Decimeter': 0.01,
      'Sq.Dekameter': 100.0,
      'Sq.Chain': 404.6873,
      'Sq.Perch': 25.2929,
      'Arce': 4046.86,
    };

    final double baseSquareMeter =
        inputVal * areaUnitToSquareMeter[selectedUnit]!;

    setState(() {
      convertedValues = {};
      areaUnitToSquareMeter.forEach((unit, factor) {
        final double value = baseSquareMeter / factor;
        convertedValues[unit] = value;
      });
    });

    _saveHistory();
  }

  void _saveHistory() {
    final double? inputVal = double.tryParse(areaController.text);
    if (inputVal == null || convertedValues.isEmpty) return;

    final item = DistanceHistoryItem(
      inputValue: inputVal,
      inputUnit: selectedUnit,
      convertedValues: Map.from(convertedValues), // all unit conversions

      savedAt: DateTime.now(),
    );

    // --- ADD TO PROVIDER / LIST ---
    ref.read(unifiedHistoryProvider.notifier).addDistance(item);

    // // --- SNACKBAR ---
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Distance conversion saved to history!")),
    // );
  }

  // MATERIAL DROPDOWN
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

  // ================== OPTIONS ==================

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
                padding: const EdgeInsets.only(left: 10, right: 8),
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
              width: 130,
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

      return [
        unit, // Unit
        value.toStringAsFixed(2), // Amount
      ];
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
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
            },
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
          "Area Unit Converter",
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
                'assets/icons/area_icon.svg',
                height: 85,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Area",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            _suffixInputWithDropdown(
              hintText: "Enter Value:",
              controller: areaController,
              dropdownOptions: areaUnitOptions,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!); // update dropdown value
                // _calculate(); // recalc when dropdown changes
              },
              onChangedInput: (_) => {}, // recalc when user types
            ),

            const SizedBox(height: 8),

            // CALCULATE BUTTON
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

            const SizedBox(height: 8),

            // RESULTS
            _resultTable(textColor),
          ],
        ),
      ),
    );
  }
}
