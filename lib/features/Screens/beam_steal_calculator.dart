// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/beam_steal_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BeamStealCalculator extends ConsumerStatefulWidget {
  const BeamStealCalculator({super.key});

  @override
  ConsumerState<BeamStealCalculator> createState() =>
      _BeamStealCalculatorState();
}

class _BeamStealCalculatorState extends ConsumerState<BeamStealCalculator> {
  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // INPUT CONTROLLERS

  // Size Controllers
  final TextEditingController sizeAController = TextEditingController();
  final TextEditingController sizeTController = TextEditingController();
  final TextEditingController sizeBController = TextEditingController();
  final TextEditingController sizeSController = TextEditingController();

  // Length Controller
  final TextEditingController lengthController = TextEditingController();

  // Cost of Steel Controller
  final TextEditingController costOfSteelController = TextEditingController();

  // Pieces Controller
  final TextEditingController piecesController = TextEditingController();

  // RESULT VALUES
  double? weightkg;
  double? weighttons;
  double? cost;

  // MATERIAL DENSITY (kg/m³)
  final Map<String, double> materialDensities = {
    "Steel": 7850,
    "Aluminum": 2700,
    "Lead": 11340,
    "Iron": 7874,
    "Gold": 19320,
  };

  // ✅ Unit Conversion Function
  double convertToMeter(double value, String unit) {
    switch (unit) {
      case "mm":
        return value / 1000;
      case "cm":
        return value / 100;
      case "inch":
        return value * 0.0254;
      case "foot":
        return value * 0.3048;
      case "yard":
        return value * 0.9144;
      case "meter":
      default:
        return value;
    }
  }

  void _calculate() {
    // --- INPUT VALUES ---
    final double sizeA = double.tryParse(sizeAController.text) ?? 0;
    final double sizeB = double.tryParse(sizeBController.text) ?? 0;
    final double sizeT = double.tryParse(sizeTController.text) ?? 0;
    final double sizeS = double.tryParse(sizeSController.text) ?? 0;
    final double length = double.tryParse(lengthController.text) ?? 0;
    final double costPerKg = double.tryParse(costOfSteelController.text) ?? 0;
    final int pieces = int.tryParse(piecesController.text) ?? 1;

    // --- CONVERSIONS ---
    final double lengthM = convertToMeter(length, selectedLengthUnit);
    final double A = convertToMeter(sizeA, selectedLengthUnit);
    final double B = convertToMeter(sizeB, selectedLengthUnit);
    final double T = convertToMeter(sizeT, selectedLengthUnit);
    final double S = convertToMeter(sizeS, selectedLengthUnit);

    // --- MATERIAL DENSITY ---
    final double density = materialDensities[selectedMaterial] ?? 7850;

    // --- CROSS-SECTION AREA (m²) ---
    double area = 0;

    if (A > 0 && B > 0 && T == 0 && S == 0) {
      // Rectangular
      area = A * B;
    } else if (A > 0 && B == 0 && T == 0 && S == 0) {
      // Circular (A = diameter)
      area = 3.14159 * (A / 2) * (A / 2);
    } else if (A > 0 && B > 0 && T > 0 && S > 0) {
      // T-Beam
      area = (A * T) + (S * (B - T));
    } else {
      // Default Rectangular
      area = A * B;
    }

    // --- VOLUME (m³) ---
    final double volume = area * lengthM * pieces;
    setState(() {
      // --- RESULTS ---
      weightkg = volume * density;
      weighttons = weightkg! / 1000;
      cost = weightkg! * costPerKg;
    });
    _saveHistory();
  }

  void _saveHistory() {
    if (weightkg == null || weighttons == null || cost == null) return;

    // --- USER INPUTS ---
    final double sizeA = double.tryParse(sizeAController.text) ?? 0;
    final double sizeB = double.tryParse(sizeBController.text) ?? 0;
    final double sizeT = double.tryParse(sizeTController.text) ?? 0;
    final double sizeS = double.tryParse(sizeSController.text) ?? 0;
    final double length = double.tryParse(lengthController.text) ?? 0;
    final double costPerKg = double.tryParse(costOfSteelController.text) ?? 0;
    final int pieces = int.tryParse(piecesController.text) ?? 1;

    // --- CREATE HISTORY ITEM ---
    final item = BeamStealHistoryItem(
      sizeA: sizeA,
      sizeB: sizeB,
      sizeT: sizeT,
      sizeS: sizeS,
      length: length,
      pieces: pieces,
      material: selectedMaterial,
      lengthUnit: selectedLengthUnit,
      weightUnit: selectedWeightUnit,
      costPerKg: costPerKg,
      weightKg: weightkg!,
      weightTons: weighttons!,
      totalCost: cost!,
      savedAt: DateTime.now(),
    );

    // --- ADD TO PROVIDER / LIST ---
    ref.read(unifiedHistoryProvider.notifier).addBeamSteel(item);

    // --- SNACKBAR ---
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text("History saved!")));
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

  final List<String> materialOptions = const [
    "Steel",
    "Aluminum",
    "Lead",
    "Iron",
    "Gold",
  ];
  String selectedMaterial = "Steel";

  final List<String> lengthUnitOptions = const [
    "mm",
    "cm",
    "inch",
    "foot",
    "yard",
    "meter",
  ];
  String selectedLengthUnit = "mm";

  final List<String> weightUnitOptions = const ["kg", "lb", "ton"];
  String selectedWeightUnit = "kg";

  Widget _suffixInputWithDropdown({
    String? labelText,
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
          // Left side content with padding
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                if (labelText != null) ...[
                  Text(
                    labelText,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (controller != null)
                  SizedBox(
                    width: 100,
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
                        //  hintText: '10',
                        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Dropdown always at the end (no padding)
          if (dropdownOptions != null && dropdownOptions.isNotEmpty)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 55,
                  width: 90,
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
                    onChanged: onChanged ?? (_) {},
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _suffixInput({
    required TextEditingController controller,
    String? textarea, // Optional text at the start
    String? unit, // Optional unit at the end
    TextInputType type = const TextInputType.numberWithOptions(decimal: true),
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white30,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(width: 0.4, color: Colors.black.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          // Optional Start Text
          if (textarea != null && textarea.isNotEmpty) ...[
            Text(
              textarea,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor.withOpacity(0.5),
              ),
            ),
          ],

          // Center Input
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: type,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: textColor.withOpacity(0.5),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                // // hintText: '10',
                // hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
              ),
            ),
          ),

          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(100),
                right: Radius.circular(100),
              ),
              border: Border.all(color: orangeColor, width: 1),
            ),
            child: Center(
              child: unit?.trim().isNotEmpty == true
                  ? Text(
                      unit!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: orangeColor,
                      ),
                    )
                  : SizedBox.shrink(), // just empty space if unit is null/empty
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultTable(Color textColor) {
    if (weightkg == null) return const SizedBox.shrink();

    final rows = <List<String>>[
      ['Weight', '${weightkg!.toStringAsFixed(2)} Kg'],

      ['Weight', '${weighttons!.toStringAsFixed(2)} Tons'],
      ['Cost', '${cost!.toStringAsFixed(2)} Amount'],
    ];

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
                      'Material',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF9C00),
                      ),
                    ),
                  ),
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
                ],
              ),
              ...rows.map(
                (r) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(r[0], style: TextStyle(color: textColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        r[1],
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
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
          "Beam Steal Calculator",
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
                'assets/icons/beam_steal_icon.svg',
                height: 85,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 4),

            // UNIT DROPDOWN
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                  width: 0.4,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Steal Type',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: textColor,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 55,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(50),
                        right: Radius.circular(50),
                      ),
                      border: Border.all(color: orangeColor, width: 1),
                    ),
                    child: _buildDropdown(
                      options: materialOptions,
                      selectedValue: selectedMaterial,
                      onChanged: (v) => setState(() => selectedMaterial = v!),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            _suffixInputWithDropdown(
              labelText: "Enter Size (A)", // Label
              controller: sizeAController, // Input Field
              dropdownOptions: lengthUnitOptions, // Dropdown List
              selectedValue: selectedLengthUnit, // Dropdown Selected

              onChanged: (v) =>
                  setState(() => selectedLengthUnit = v!), // Callback
            ),

            const SizedBox(height: 8),

            _suffixInputWithDropdown(
              labelText: "Enter Size (T)", // Label
              controller: sizeTController, // Input Field
              dropdownOptions: lengthUnitOptions, // Dropdown List
              selectedValue: selectedLengthUnit, // Dropdown Selected
              onChanged: (v) =>
                  setState(() => selectedLengthUnit = v!), // Callback
            ),

            const SizedBox(height: 8),

            _suffixInputWithDropdown(
              labelText: "Enter Size (B)", // Label
              controller: sizeBController, // Input Field
              dropdownOptions: lengthUnitOptions, // Dropdown List
              selectedValue: selectedLengthUnit, // Dropdown Selected
              onChanged: (v) =>
                  setState(() => selectedLengthUnit = v!), // Callback
            ),

            const SizedBox(height: 8),

            _suffixInputWithDropdown(
              labelText: "Enter Size (S)", // Label
              controller: sizeSController, // Input Field
              dropdownOptions: lengthUnitOptions, // Dropdown List
              selectedValue: selectedLengthUnit, // Dropdown Selected
              onChanged: (v) =>
                  setState(() => selectedLengthUnit = v!), // Callback
            ),

            const SizedBox(height: 8),

            _suffixInputWithDropdown(
              labelText: "Enter Length Value", // Label
              controller: lengthController, // Input Field
              dropdownOptions: lengthUnitOptions, // Dropdown List
              selectedValue: selectedLengthUnit, // Dropdown Selected
              onChanged: (v) =>
                  setState(() => selectedLengthUnit = v!), // Callback
            ),

            const SizedBox(height: 8),
            _suffixInput(
              textarea: "Enter Beam Quantity",
              controller: piecesController,
              unit: "Pcs",
            ),
            const SizedBox(height: 8),

            _suffixInputWithDropdown(
              labelText: "Enter Steal Cost", // Label
              controller: costOfSteelController, // Input Field
              dropdownOptions: weightUnitOptions, // Dropdown List
              selectedValue: selectedWeightUnit, // Dropdown Selected
              onChanged: (v) =>
                  setState(() => selectedWeightUnit = v!), // Callback
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
