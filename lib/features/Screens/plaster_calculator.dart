// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/plaster_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';

class PlasterCalculatorScreen extends ConsumerStatefulWidget {
  const PlasterCalculatorScreen({super.key});

  @override
  ConsumerState<PlasterCalculatorScreen> createState() =>
      _PlasterCalculatorScreenState();
}

class _PlasterCalculatorScreenState
    extends ConsumerState<PlasterCalculatorScreen> {
  // THEME COLORS
  final Color orangeColor = const Color(0xFFFF9C00);

  // UNIT OPTIONS
  final List<String> unitOptions = const ["Meter/CM", "Feet/Inch"];
  String selectedUnit = "Meter/CM";

  // GRADE OPTIONS
  final List<String> gradeOptions = const ["12 MM", "15 MM", "18 MM", "20 MM"];
  String selectedGrade = "12 MM";

  // List of options for dropdown
  final List<String> gradeOptionsForFooting = ["C.M 1:3", "C.M 1:4", "C.M 1:5"];

  String selectedFooting = "C.M 1:3"; // default selected

  // INPUT CONTROLLERS
  final TextEditingController lenM = TextEditingController();
  final TextEditingController lenCM = TextEditingController();
  final TextEditingController lenFT = TextEditingController();
  final TextEditingController lenIN = TextEditingController();

  final TextEditingController widthM = TextEditingController();
  final TextEditingController widthCM = TextEditingController();
  final TextEditingController widthFT = TextEditingController();
  final TextEditingController widthIN = TextEditingController();

  final TextEditingController thicknessCM = TextEditingController();
  final TextEditingController thicknessIN = TextEditingController();

  // RESULTS
  double? area;
  double? cementBags;
  double? sandCft;

  // ================= CALCULATION LOGIC =================

  // Function for calculation
  void _calculate() {
    final length = _toMetersLength(); // meters/feet se meters me convert
    final width = _toMetersWidth(); // meters/feet se meters me convert
    final ratios = _getRatiosForGrade(selectedGrade); // 1:4 => [1,4]

    // ✅ AREA
    final area = length * width;

    // ✅ Plaster thickness (12 mm = 0.012 m)
    final thickness = 0.012;

    // ✅ Wet Volume
    final wetVol = area * thickness;

    // ✅ Dry Volume (27% extra wastage/bulking)
    final dryVol = wetVol * 1.27;

    // ✅ Cement : Sand ratio
    final totalParts = ratios.reduce((a, b) => a + b);

    final cementVol = dryVol * (ratios[0] / totalParts);
    final sandVol = dryVol * (ratios[1] / totalParts);

    // ✅ Cement → bags (1 bag = 0.035 m³)
    final cementBagsCalc = cementVol / 0.035;

    // ✅ Sand → CFT
    final sandCftCalc = sandVol * 35.3147;

    setState(() {
      this.area = double.parse(area.toStringAsFixed(2));
      cementBags = cementBagsCalc.ceilToDouble(); // bags round up
      sandCft = double.parse(sandCftCalc.toStringAsFixed(2));
    });
    savePlasterHistory(ref);
  }

  Future<void> savePlasterHistory(WidgetRef ref) async {
    final historyItem = PlasterHistoryItem(
      lenM: lenM.text,
      lenCM: lenCM.text,
      lenFT: lenFT.text,
      lenIN: lenIN.text,
      widthM: widthM.text,
      widthCM: widthCM.text,
      widthFT: widthFT.text,
      widthIN: widthIN.text,
      grade: selectedGrade,
      area: area ?? 0.0, // ✅ sirf ek hi area save hoga
      cementBags: cementBags ?? 0.0,
      sandCft: sandCft ?? 0.0,
      unit: selectedUnit, // "m²" ya "ft²"
    );

    if (Hive.isBoxOpen(HiveBoxes.plasterHistory)) {
    } else {}

    // ✅ Riverpod unified history update
    ref.read(unifiedHistoryProvider.notifier).addPlaster(historyItem);
  }

  List<double> _getRatiosForGrade(String grade) {
    switch (grade) {
      case "12 MM":
        return [1, 3];
      case "15 MM":
        return [1, 4];
      case "18 MM":
        return [1, 5];
      case "20 MM":
        return [1, 6];

      default:
        return [1, 3];
    }
  }

  double _toMetersLength() {
    if (selectedUnit == "Meter/CM") {
      final m = double.tryParse(lenM.text) ?? 0;
      final cm = double.tryParse(lenCM.text) ?? 0;
      return m + cm / 100.0;
    } else {
      final ft = double.tryParse(lenFT.text) ?? 0;
      final inch = double.tryParse(lenIN.text) ?? 0;
      return (ft + inch / 12.0) * 0.3048;
    }
  }

  double _toMetersWidth() {
    if (selectedUnit == "Meter/CM") {
      final m = double.tryParse(widthM.text) ?? 0;
      final cm = double.tryParse(widthCM.text) ?? 0;
      return m + cm / 100.0;
    } else {
      final ft = double.tryParse(widthFT.text) ?? 0;
      final inch = double.tryParse(widthIN.text) ?? 0;
      return (ft + inch / 12.0) * 0.3048;
    }
  }

  // Ratios based on selected grade

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

  Widget _buildGradeDropdown(Color textColor) {
    return DropdownButton<String>(
      value: selectedGrade,
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
        selectedGrade = v!;
      }),
      selectedItemBuilder: (context) {
        return gradeOptions.map((v) => Center(child: Text(v))).toList();
      },
      items: gradeOptions
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
    );
  }

  // Dropdown widget
  /// Widget for Grade of Footing Dropdown
  Widget _buildGradeDropdownFootingWidget(Color textColor) {
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
        // Display values like "C.M 1:3"
        return gradeOptionsForFooting
            .map((v) => Center(child: Text(v)))
            .toList();
      },
      items: gradeOptionsForFooting
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
    if (area == null) return const SizedBox.shrink();

    final rows = <List<String>>[
      ['Area', '${area!.toStringAsFixed(3)} m³'],
      ['Cement', '${cementBags!.toStringAsFixed(2)} Bags'],
      ['Sand', '${sandCft!.toStringAsFixed(2)} Cft'],
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
          "Plaster Calculator",
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
                'assets/icons/plastering_icon.svg', // You'll need to add this icon
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
                      'Grade of Footing',
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
                    child: _buildGradeDropdownFootingWidget(textColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // GRADE OF PLASTER DROPDOWN
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
                      'Grade of Plaster',
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
                    child: _buildGradeDropdown(textColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // LENGTH & WIDTH (single set for both units)
            if (selectedUnit == 'Meter/CM') ...[
              _metricDual('Length', lenM, lenCM, textColor),
              const SizedBox(height: 12),
              _metricDual('Width', widthM, widthCM, textColor),
            ] else ...[
              _imperialDual('Length', lenFT, lenIN, textColor),
              const SizedBox(height: 12),
              _imperialDual('Width', widthFT, widthIN, textColor),
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
