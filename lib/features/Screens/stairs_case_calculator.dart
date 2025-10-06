// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'dart:math';
import 'package:construction_calculator/Domain/entities/stair_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class StairCalculatorScreen extends ConsumerStatefulWidget {
  const StairCalculatorScreen({super.key});

  @override
  ConsumerState<StairCalculatorScreen> createState() =>
      _StairCalculatorScreenState();
}

class _StairCalculatorScreenState extends ConsumerState<StairCalculatorScreen> {
  final Color orangeColor = const Color(0xFFFF9C00);

  // Riser Dimensions
  final TextEditingController riserLenFT = TextEditingController();
  final TextEditingController riserLenIN = TextEditingController();

  final TextEditingController treadFT = TextEditingController();
  final TextEditingController treadIN = TextEditingController();

  final TextEditingController widthofstairFT = TextEditingController();
  final TextEditingController heightofstairFT = TextEditingController();

  // Extra Inputs
  final TextEditingController waistslabIN = TextEditingController();

  double? _volume;

  double? _cement;

  double? _sand;

  // ignore: non_constant_identifier_names
  double? _Aggregate;

  final List<String> gradeOptions = const [
    "M5 (1:5:10)",
    "M7.5 (1:4:8)",
    "M10 (1:3:6)",
    "M15 (1:2:4)",
    "M20 (1:1.5:3)",
    "M25 (1:1:2)",
  ];
  String selectedGrade = "M15 (1:2:4)";
  List<double> _getRatiosForGrade(String grade) {
    switch (grade) {
      case "M5 (1:5:10)":
        return [1, 5, 10];
      case "M7.5 (1:4:8)":
        return [1, 4, 8];
      case "M10 (1:3:6)":
        return [1, 3, 6];
      case "M15 (1:2:4)":
        return [1, 2, 4];
      case "M20 (1:1.5:3)":
        return [1, 1.5, 3];
      case "M25 (1:1:2)":
        return [1, 1, 2];
      default:
        return [1, 2, 4];
    }
  }

  // ---- Helpers ----
  double _ftInToFeet(String ft, String inch) {
    final f = double.tryParse(ft) ?? 0;
    final i = double.tryParse(inch) ?? 0;
    return f + (i / 12.0);
  }

  void _calculate() {
    // 1. Inputs from controllers
    final riser = _ftInToFeet(riserLenFT.text, riserLenIN.text);
    final tread = _ftInToFeet(treadFT.text, treadIN.text);
    final stairWidth = double.tryParse(widthofstairFT.text) ?? 0;
    final stairHeight = double.tryParse(heightofstairFT.text) ?? 0;
    final waistSlab = (double.tryParse(waistslabIN.text) ?? 0) / 12; // ft

    if (riser <= 0 ||
        tread <= 0 ||
        stairWidth <= 0 ||
        stairHeight <= 0 ||
        waistSlab <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please enter valid stair dimensions")),
      );
      return;
    }

    // 2. Number of Steps
    final totalSteps = (stairHeight / riser).floor().toDouble();

    // 3. Hypotenuse per step run (diagonal step run)
    final stepDiagonal = sqrt(riser * riser + tread * tread);

    // 4. End-area per step: (riser × tread / 2) + (stepDiagonal × waistSlab)
    final endAreaPerStep = (riser * tread) / 2 + (stepDiagonal * waistSlab);

    // 5. Total End-Area
    final totalEndArea = totalSteps * endAreaPerStep;

    // 6. Volume (ft³)
    final volumeFt3 = totalEndArea * stairWidth;

    // 7. Volume in Cubic Meters (for material calculations)
    final volumeM3 = volumeFt3 / 35.3147;

    // 8. Concrete Mix Ratio
    final ratio = _getRatiosForGrade(selectedGrade);
    final totalParts = ratio[0] + ratio[1] + ratio[2];
    final cementPart = ratio[0] / totalParts;
    final sandPart = ratio[1] / totalParts;
    final aggPart = ratio[2] / totalParts;

    // 9. Material Calculations
    final cementVolumeM3 = volumeM3 * cementPart;
    final sandVolumeM3 = volumeM3 * sandPart;
    final aggVolumeM3 = volumeM3 * aggPart;

    final cementBags = cementVolumeM3 / 0.035; // per bag volume
    final sandTon = sandVolumeM3 * 1550 / 1000; // ton
    final aggTon = aggVolumeM3 * 1350 / 1000; // ton

    // 10. Save to state
    setState(() {
      _volume = volumeFt3;
      _cement = cementBags;
      _sand = sandTon;
      _Aggregate = aggTon;
    });
    saveStairHistory(ref);
  }

  Future<void> saveStairHistory(WidgetRef ref) async {
    final historyItem = StairHistoryItem(
      riserFT: riserLenFT.text,
      riserIN: riserLenIN.text,
      treadFT: treadFT.text,
      treadIN: treadIN.text,
      stairWidthFT: widthofstairFT.text,
      stairHeightFT: heightofstairFT.text,
      waistSlabIN: waistslabIN.text,
      grade: selectedGrade,
      volume: _volume ?? 0.0,
      cementBags: _cement ?? 0.0,
      sand: _sand ?? 0.0,
      aggregate: _Aggregate ?? 0.0,
      savedAt: DateTime.now(),
    );

    ref.read(unifiedHistoryProvider.notifier).addStairHistory(historyItem);
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
          "Stair Case Calculator",
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
              // Navigate to History Screen
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
                'assets/icons/stair_case_icon.svg',
                height: 90,

                color: orangeColor,
              ),
            ),
            const SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GRADE DROPDOWN
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
                          'Grade of Concrete',
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
                        width: 115,
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

                // Length of Room
                _imperialDual("Riser", riserLenFT, riserLenIN, textColor),
                const SizedBox(height: 4),

                // Breadth of Room
                _imperialDual("Tread", treadFT, treadIN, textColor),
                const SizedBox(height: 4),

                Text(
                  "Width of Stair",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                _suffixInput(
                  controller: widthofstairFT,
                  unit: "feet",
                  type: TextInputType.number,
                ),
                const SizedBox(height: 4),
                Text(
                  "Height of Stair",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                _suffixInput(
                  controller: heightofstairFT,
                  unit: "feet",
                  type: TextInputType.number,
                ),
                const SizedBox(height: 4),
                Text(
                  "Thickness of waist slab",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                _suffixInput(
                  controller: waistslabIN,
                  unit: "inch",
                  type: TextInputType.number,
                ),
                const SizedBox(height: 4),
              ],
            ),

            const SizedBox(height: 15),
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

            const SizedBox(height: 20),

            // RESULTS
            _resultTable(textColor),
            const SizedBox(height: 12),
          ],
        ),
      ),
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
                hintText: '5',
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
    if (_volume == null) return const SizedBox.shrink();
    final rows = <List<String>>[
      ['Volume', '${(_volume ?? 0).toStringAsFixed(2)} ft³'],
      ['Cement', '${(_cement ?? 0).toStringAsFixed(2)} Bags'],
      ['Sand', '${(_sand ?? 0).toStringAsFixed(2)} Tons'],
      ['Aggregate', '${(_Aggregate ?? 0).toStringAsFixed(2)} Tons'],
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
                          color: r[0] == 'Total Panels'
                              ? orangeColor
                              : textColor,
                          fontWeight: r[0] == 'Total Panels'
                              ? FontWeight.w700
                              : FontWeight.w400,
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
}
