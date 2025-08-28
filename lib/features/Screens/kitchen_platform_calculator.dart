// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/kitchen_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';

class KitchenPlatformCalculator extends ConsumerStatefulWidget {
  const KitchenPlatformCalculator({super.key});

  @override
  ConsumerState<KitchenPlatformCalculator> createState() =>
      _KitchenPlatformCalculatorState();
}

class _KitchenPlatformCalculatorState
    extends ConsumerState<KitchenPlatformCalculator> {
  // THEME COLORS
  final Color orangeColor = const Color(0xFFFF9C00);

  // UNIT OPTIONS
  final List<String> unitOptions = const ["Meter/CM", "Feet/Inch"];
  String selectedUnit = "Meter/CM";

  // GRADE OPTIONS
  final List<String> gradeOptions = const ["12 MM", "15 MM", "18 MM", "20 MM"];
  String selectedGrade = "12 MM";
  // HEIGHT
  final TextEditingController heightM = TextEditingController();
  final TextEditingController heightCM = TextEditingController();
  final TextEditingController heightFT = TextEditingController();
  final TextEditingController heightIN = TextEditingController();

  final TextEditingController widthM = TextEditingController();
  final TextEditingController widthCM = TextEditingController();
  final TextEditingController widthFT = TextEditingController();
  final TextEditingController widthIN = TextEditingController();

  final TextEditingController thicknessCM = TextEditingController();
  final TextEditingController thicknessIN = TextEditingController();
  // Depth
  final TextEditingController depthController = TextEditingController();

  // RESULTS
  double? areaofcounter;

  // ================= CALCULATION LOGIC =================

  // Function for calculation
  void _calculate() {
    final width = _toMetersWidth();
    final height = _toMetersHeight();
    final depth = _toMetersDepth(); // countertop depth in meters

    double volumeM3 = 0;

    switch (selectedFooting) {
      case "L Shape":
        // Length of countertop for L Shape
        final length = width + (height - depth);
        volumeM3 = length * depth;
        break;

      case "U Shape":
        // Length of countertop for U Shape
        final length = height + (width - depth);
        volumeM3 = length * depth;
        break;

      case "I Shape":
        volumeM3 = height * depth;
        break;

      default:
        volumeM3 = width * height;
    }

    setState(() {
      areaofcounter = double.parse(volumeM3.toStringAsFixed(4)); // in m²
    });
    saveKitchenHistory();
  }

  void saveKitchenHistory() async {
    if (areaofcounter == null) {
      return; // Agar calculation nahi hui to save mat karo
    }

    // Naya KitchenCalculationItem create karo
    final newItem = KitchenHistoryItem(
      selectedUnit: selectedUnit,
      shape: selectedFooting,
      height: _toMetersHeight(),
      width: selectedFooting != "I Shape" ? _toMetersWidth() : null,
      depth: _toMetersDepth(),
      area: areaofcounter!,
      savedAt: DateTime.now(),
    );

    // UnifiedHistoryNotifier ko update karo
    ref.read(unifiedHistoryProvider.notifier).addKitchen(newItem);

    // // User ko feedback
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Kitchen calculation saved to history!')),
    // );
  }

  // Depth conversion based on selected unit
  double _toMetersDepth() {
    final value = double.tryParse(depthController.text) ?? 0;
    return selectedUnit == "Meter/CM" ? value : value * 0.3048;
  }

  double _toMetersHeight() {
    if (selectedUnit == "Meter/CM") {
      final m = double.tryParse(heightM.text) ?? 0;
      final cm = double.tryParse(heightCM.text) ?? 0;
      return m + cm / 100.0; // height in meters
    } else {
      final ft = double.tryParse(heightFT.text) ?? 0;
      final inch = double.tryParse(heightIN.text) ?? 0;
      return (ft + inch / 12.0) * 0.3048; // feet/inches → meters
    }
  }

  double _toMetersWidth() {
    if (selectedUnit == "Meter/CM") {
      final m = double.tryParse(widthM.text) ?? 0;
      final cm = double.tryParse(widthCM.text) ?? 0;
      return m + cm / 100.0; // width in meters
    } else {
      final ft = double.tryParse(widthFT.text) ?? 0;
      final inch = double.tryParse(widthIN.text) ?? 0;
      return (ft + inch / 12.0) * 0.3048; // feet/inches → meters
    }
  }

  // ============================= UI HELPERS =============================
  Widget _buildUnitDropdown(Color textColor) {
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
      onChanged: (v) => setState(() {
        selectedUnit = v!;
      }),
      selectedItemBuilder: (context) {
        return unitOptions.map((v) => Center(child: Text(v))).toList();
      },
      items: unitOptions
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
    );
  }

  // Shape options for kitchen platform
  final List<String> shapeOption = ["L Shape", "U Shape", "I Shape"];
  String selectedFooting = "L Shape"; // default selected

  Widget _buildShapeDropdownKitchenWidget(Color textColor) {
    return DropdownButton<String>(
      value: selectedFooting,
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
      onChanged: (v) => setState(() {
        selectedFooting = v!;
      }),
      selectedItemBuilder: (context) {
        return shapeOption.map((v) => Center(child: Text(v))).toList();
      },
      items: shapeOption
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
                hintText: '0',
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
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricDual(
    String label,
    TextEditingController m,
    TextEditingController cm,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _suffixInput(controller: m, unit: 'Meter'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _suffixInput(controller: cm, unit: 'CM'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _imperialDual(
    String label,
    TextEditingController ft,
    TextEditingController inch,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _suffixInput(controller: ft, unit: 'feet'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _suffixInput(controller: inch, unit: 'inch'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _resultTable(Color textColor) {
    if (areaofcounter == null) return const SizedBox.shrink();

    final rows = <List<String>>[
      ['Area Of Counter', '${areaofcounter!.toStringAsFixed(4)} m³'],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
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
              fontSize: 15,
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
                      'Unit / Qty',
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
          "Kitchen Platform Calculation",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
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
            const SizedBox(height: 13),
            const SizedBox(height: 6),

            Center(
              child: SvgPicture.asset(
                'assets/icons/kitchen_platform_icon.svg', // You'll need to add this icon
                height: 85,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 18),
            const SizedBox(height: 20),

            // UNIT DROPDOWN
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
                    width: 150,
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
            // GRADE OF FOOTING DROPDOWN (same design as Grade of Plaster)
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
                      'Shape',
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
                    child: _buildShapeDropdownKitchenWidget(textColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // LENGTH & WIDTH (single set for both units)
            if (selectedUnit == 'Meter/CM') ...[
              _metricDual('Height', heightM, heightCM, textColor),
              const SizedBox(height: 12),
              if (selectedFooting != "I Shape") ...[
                _metricDual('Width', widthM, widthCM, textColor),
                const SizedBox(height: 5),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Depth',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _suffixInput(
                    controller: depthController,
                    unit: selectedUnit == "Meter/CM" ? "Meter" : "Feet",
                  ),
                ],
              ),
            ] else ...[
              _imperialDual('Length', heightFT, heightIN, textColor),
              const SizedBox(height: 12),
              if (selectedFooting != "I Shape") ...[
                _imperialDual('Width', widthFT, widthIN, textColor),
                const SizedBox(height: 5),
              ],
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Depth',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _suffixInput(
                    controller: depthController,
                    unit: selectedUnit == "Meter/CM" ? "Meter" : "Feet",
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

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

            // RESULTS
            _resultTable(textColor),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
