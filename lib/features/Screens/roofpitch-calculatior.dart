// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/Domain/entities/roof_pitch_history_item.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';

class RoofPitchCalculator extends ConsumerStatefulWidget {
  const RoofPitchCalculator({super.key});

  @override
  ConsumerState<RoofPitchCalculator> createState() =>
      _RoofPitchCalculatorState();
}

class _RoofPitchCalculatorState extends ConsumerState<RoofPitchCalculator> {
  // THEME COLORS
  final Color orangeColor = const Color(0xFFFF9C00);

  // UNIT OPTIONS
  final List<String> unitOptions = const ["Meter/CM", "Feet/Inch"];
  String selectedUnit = "Meter/CM";

  // HEIGHT (Rise)
  final TextEditingController heightM = TextEditingController();
  final TextEditingController heightCM = TextEditingController();
  final TextEditingController heightFT = TextEditingController();
  final TextEditingController heightIN = TextEditingController();

  // WIDTH (Run)
  final TextEditingController widthM = TextEditingController();
  final TextEditingController widthCM = TextEditingController();
  final TextEditingController widthFT = TextEditingController();
  final TextEditingController widthIN = TextEditingController();

  // RESULTS
  double? roofPitch; // ratio rise/run
  double? roofSlope; // %
  double? roofAngle; // degrees

  // ================= CALCULATION LOGIC =================
  void _calculate() {
    double rise;
    double run;

    // Inputs ko meters mein convert karo
    if (selectedUnit == "Meter/CM") {
      rise =
          (double.tryParse(heightM.text) ?? 0) +
          (double.tryParse(heightCM.text) ?? 0) / 100;
      run =
          (double.tryParse(widthM.text) ?? 0) +
          (double.tryParse(widthCM.text) ?? 0) / 100; // full width
    } else {
      rise =
          ((double.tryParse(heightFT.text) ?? 0) +
              (double.tryParse(heightIN.text) ?? 0) / 12) *
          0.3048;
      run =
          (((double.tryParse(widthFT.text) ?? 0) +
              (double.tryParse(widthIN.text) ?? 0)) *
          0.3048); // full width
    }

    if (rise <= 0 || run <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rise and Width must be greater than 0.')),
      );
      return;
    }

    final pitchRatio = rise / (run / 12); // rise/run
    final slopePercent = rise / run * 100;
    final angleDegree = atan(rise / run) * 180 / pi;
    // 1:x format

    setState(() {
      roofPitch = pitchRatio;
      roofSlope = slopePercent;
      roofAngle = angleDegree;
    });
    saveRoofPitchHistory();
  }

  Future<void> saveRoofPitchHistory() async {
    if (roofPitch == null || roofSlope == null || roofAngle == null) return;

    final historyItem = RoofPitchHistoryItem(
      heightM: heightM.text,
      heightCM: heightCM.text,
      heightFT: heightFT.text,
      heightIN: heightIN.text,
      widthM: widthM.text,
      widthCM: widthCM.text,
      widthFT: widthFT.text,
      widthIN: widthIN.text,
      unit: selectedUnit,
      roofPitch: roofPitch!,
      roofSlope: roofSlope!,
      roofAngle: roofAngle!,
    );
    ref.read(unifiedHistoryProvider.notifier).addRoofPitchHistory(historyItem);
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
              child: _suffixInput(controller: ft, unit: 'Feet'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _suffixInput(controller: inch, unit: 'Inch'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _resultTable(Color textColor) {
    if (roofPitch == null) return const SizedBox.shrink();

    final rows = <List<String>>[
      ['Roof Pitch (rise/run)', (roofPitch!.toStringAsFixed(4))],
      ['Slope %', '${roofSlope!.toStringAsFixed(2)}%'],
      ['Angle °', '${roofAngle!.toStringAsFixed(2)}°'],
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

  // ============================= BUILD =============================
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
          "Roof Pitch Calculation",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
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
            const SizedBox(height: 13),
            Center(
              child: SvgPicture.asset(
                'assets/icons/roof_pitch_icon.svg',
                height: 85,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 15),
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

            const SizedBox(height: 15),
            if (selectedUnit == "Meter/CM") ...[
              _metricDual('Rise (Height)', heightM, heightCM, textColor),
              const SizedBox(height: 12),
              _metricDual('Run (Width)', widthM, widthCM, textColor),
            ] else ...[
              _imperialDual('Rise (Height)', heightFT, heightIN, textColor),
              const SizedBox(height: 12),
              _imperialDual('Run (Width)', widthFT, widthIN, textColor),
            ],
            const SizedBox(height: 20),
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
            _resultTable(textColor),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
