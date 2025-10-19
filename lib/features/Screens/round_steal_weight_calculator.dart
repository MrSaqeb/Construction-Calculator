// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/round_steal_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundStealCalculator extends ConsumerStatefulWidget {
  const RoundStealCalculator({super.key});

  @override
  ConsumerState<RoundStealCalculator> createState() =>
      _RoundStealCalculatorState();
}

class _RoundStealCalculatorState extends ConsumerState<RoundStealCalculator> {
  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // INPUT CONTROLLERS

  // Size Controllers
  final TextEditingController diamterSController = TextEditingController();

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
    "Steel": 7850, // typical mild steel
    "Aluminum": 2700, // pure aluminum
    "Lead": 11340, // pure lead
    "Iron": 7874, // pure iron
    "Gold": 19320, // pure gold
    "Brass": 8500, // average brass alloy
    "Copper": 8960, // pure copper
    "Zinc": 7135, // pure zinc
    "Nickel": 8908, // pure nickel
    "Tin": 7310, // pure tin
    "Silver": 10490, // pure silver
    "Mercury": 13534, // liquid mercury
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
    final double diameter = double.tryParse(diamterSController.text) ?? 0;
    final double length = double.tryParse(lengthController.text) ?? 0;
    final double costPerKg = double.tryParse(costOfSteelController.text) ?? 0;
    final int pieces = int.tryParse(piecesController.text) ?? 1;

    // --- CONVERSIONS ---
    final double lengthM = convertToMeter(length, selectedLengthUnit);
    final double diameterM = convertToMeter(diameter, selectedLengthUnit);

    // --- MATERIAL DENSITY ---
    final double density = materialDensities[selectedMaterial] ?? 7850;

    // --- CROSS-SECTION AREA (circle) ---
    final double radius = diameterM / 2;
    final double area = 3.14159 * radius * radius; // πr²

    // --- VOLUME (m³) ---
    final double volume = area * lengthM * pieces;

    // --- RESULTS ---
    setState(() {
      weightkg = volume * density;
      weighttons = weightkg! / 1000;
      cost = weightkg! * costPerKg;
    });
    _saveHistory();
  }

  void _saveHistory() {
    if (weightkg == null || weighttons == null || cost == null) return;

    // --- USER INPUTS ---
    final double length = double.tryParse(lengthController.text) ?? 0;
    final double costPerKg = double.tryParse(costOfSteelController.text) ?? 0;
    final int pieces = int.tryParse(piecesController.text) ?? 1;
    final double diameter = double.tryParse(diamterSController.text) ?? 0;
    // --- CREATE HISTORY ITEM ---
    final item = RoundStealHistoryItem(
      diameter: diameter,
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
    ref.read(unifiedHistoryProvider.notifier).addRoundSteel(item);

    //   // --- SNACKBAR ---
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text("History saved!")));
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
    "Brass",
    "Copper",
    "Zinc",
    "Nickel",
    "Tin",
    "Silver",
    "Mercury",
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
    String? hintText, // ✅ labelText hatado, hintText use karo
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
          // Input field
          if (controller != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: TextField(
                  controller: controller,
                  keyboardType: type,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText ?? '0', // ✅ hint text yahin set hoga
                    hintStyle: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: onChangedInput,
                ),
              ),
            ),

          // Dropdown
          if (dropdownOptions != null && dropdownOptions.isNotEmpty)
            Container(
              height: 55,
              width: 120,
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
                  _calculate();
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _suffixInput({
    required TextEditingController controller,
    String? hintText, // ✅ yahi text hint banega
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
      child: Row(
        children: [
          // Input Field — textarea ko hint me shift kar diya
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: TextField(
                controller: controller,
                keyboardType: type,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: textColor,
                ),
                decoration: InputDecoration(
                  hintText: hintText ?? '',
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          // Unit Box
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
                  : const SizedBox.shrink(),
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
          "Round Bar Steal Calculator",
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
                'assets/icons/round_bar_icon.svg',
                height: 85,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 8),

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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    width: 110,
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
              hintText: "Length", // Label
              controller: lengthController, // Input Field
              dropdownOptions: lengthUnitOptions, // Dropdown List
              selectedValue: selectedLengthUnit, // Dropdown Selected
              onChanged: (v) =>
                  setState(() => selectedLengthUnit = v!), // Callback
            ),

            const SizedBox(height: 8),
            _suffixInputWithDropdown(
              hintText: "Diameter", // Label
              controller: diamterSController, // Input Field
              dropdownOptions: lengthUnitOptions, // Dropdown List
              selectedValue: selectedLengthUnit, // Dropdown Selected
              onChanged: (v) =>
                  setState(() => selectedLengthUnit = v!), // Callback
            ),

            const SizedBox(height: 8),

            _suffixInput(
              hintText: "Quantity",
              controller: piecesController,
              unit: "Pcs",
            ),
            const SizedBox(height: 8),

            _suffixInputWithDropdown(
              hintText: "Steal Cost", // Label
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
