// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/boundary_wall_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class BoundaryWallCalculatorScreen extends ConsumerStatefulWidget {
  const BoundaryWallCalculatorScreen({super.key});

  @override
  ConsumerState<BoundaryWallCalculatorScreen> createState() =>
      _BoundaryWallCalculatorScreenState();
}

class _BoundaryWallCalculatorScreenState
    extends ConsumerState<BoundaryWallCalculatorScreen> {
  // yaha aapka state logic}
  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // UNIT SELECTION
  final List<String> unitOptions = const ["Meter/CM", "Feet/Inch"];
  String selectedUnit = "Meter/CM";

  // INPUT CONTROLLERS
  // Area Dimensions
  final TextEditingController areaLenM = TextEditingController();
  final TextEditingController areaLenCM = TextEditingController();
  final TextEditingController areaLenFT = TextEditingController();
  final TextEditingController areaLenIN = TextEditingController();

  final TextEditingController areaHtM = TextEditingController();
  final TextEditingController areaHtCM = TextEditingController();
  final TextEditingController areaHtFT = TextEditingController();
  final TextEditingController areaHtIN = TextEditingController();

  // Horizontal Bar Dimensions
  final TextEditingController barLenM = TextEditingController();
  final TextEditingController barLenCM = TextEditingController();
  final TextEditingController barLenFT = TextEditingController();
  final TextEditingController barLenIN = TextEditingController();

  final TextEditingController barHtM = TextEditingController();
  final TextEditingController barHtCM = TextEditingController();
  final TextEditingController barHtFT = TextEditingController();
  final TextEditingController barHtIN = TextEditingController();

  // Results
  int? totalPanels;
  int? totalHorizontalBars;
  int? totalVerticalBars;

  void _calculate() async {
    double areaLength = 0;
    double areaHeight = 0;
    double barLength = 0;
    double barHeight = 0;

    // Parse inputs
    if (selectedUnit == "Meter/CM") {
      areaLength =
          (double.tryParse(areaLenM.text) ?? 0) +
          (double.tryParse(areaLenCM.text) ?? 0) / 100;
      areaHeight =
          (double.tryParse(areaHtM.text) ?? 0) +
          (double.tryParse(areaHtCM.text) ?? 0) / 100;
      barLength =
          (double.tryParse(barLenM.text) ?? 0) +
          (double.tryParse(barLenCM.text) ?? 0) / 100;
      barHeight =
          (double.tryParse(barHtM.text) ?? 0) +
          (double.tryParse(barHtCM.text) ?? 0) / 100;
    } else {
      areaLength =
          (double.tryParse(areaLenFT.text) ?? 0) +
          (double.tryParse(areaLenIN.text) ?? 0) / 12;
      areaHeight =
          (double.tryParse(areaHtFT.text) ?? 0) +
          (double.tryParse(areaHtIN.text) ?? 0) / 12;
      barLength =
          (double.tryParse(barLenFT.text) ?? 0) +
          (double.tryParse(barLenIN.text) ?? 0) / 12;
      barHeight =
          (double.tryParse(barHtFT.text) ?? 0) +
          (double.tryParse(barHtIN.text) ?? 0) / 12;
    }

    if (areaLength <= 0 ||
        areaHeight <= 0 ||
        barLength <= 0 ||
        barHeight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all dimensions properly!')),
      );
      return;
    }

    // Simple Calculation Logic
    setState(() {
      totalPanels = (areaLength / barLength).ceil();
      totalHorizontalBars = totalPanels! * (areaHeight / barHeight).ceil();
      totalVerticalBars = totalPanels!;
    });

    // Save using Riverpod provider
    await _saveBoundaryWall();
  }

  Future<void> _saveBoundaryWall() async {
    if (totalPanels == null ||
        totalHorizontalBars == null ||
        totalVerticalBars == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please calculate first!')));
      return;
    }

    final wallData = BoundaryWallItem(
      selectedUnit: selectedUnit,
      areaLength:
          (double.tryParse(areaLenM.text) ?? 0) +
          (double.tryParse(areaLenCM.text) ?? 0) / 100,
      areaHeight:
          (double.tryParse(areaHtM.text) ?? 0) +
          (double.tryParse(areaHtCM.text) ?? 0) / 100,
      barLength:
          (double.tryParse(barLenM.text) ?? 0) +
          (double.tryParse(barLenCM.text) ?? 0) / 100,
      barHeight:
          (double.tryParse(barHtM.text) ?? 0) +
          (double.tryParse(barHtCM.text) ?? 0) / 100,
      totalHorizontalBars: totalHorizontalBars!,
      totalVerticalBars: totalVerticalBars!,
      totalPanels: totalPanels!,
      savedAt: DateTime.now(),
    );

    // ⚡ Here is the fix: use `ref` from ConsumerState
    await ref.read(unifiedHistoryProvider.notifier).addBoundaryWall(wallData);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Boundary Wall data saved to history!')),
    // );
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
          "Boundary Wall Calculator",
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
            const SizedBox(height: 14),
            const SizedBox(height: 7),

            Center(
              child: SvgPicture.asset(
                'assets/icons/boundary_wall_icon.svg',
                height: 90,

                color: orangeColor,
              ),
            ),
            const SizedBox(height: 18),

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
                    width: 180,
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

            const SizedBox(height: 20),

            // AREA TO BE COVERED SECTION
            Text(
              'Area to be Covered by Precast Wall',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 12),

            if (selectedUnit == 'Meter/CM') ...[
              _metricDual('Length of Area', areaLenM, areaLenCM, textColor),
              const SizedBox(height: 12),
              _metricDual('Height of Area', areaHtM, areaHtCM, textColor),
            ] else ...[
              _imperialDual('Length of Area', areaLenFT, areaLenIN, textColor),
              const SizedBox(height: 12),
              _imperialDual('Height of Area', areaHtFT, areaHtIN, textColor),
            ],

            const SizedBox(height: 20),

            // HORIZONTAL BAR DIMENSIONS
            Text(
              'Dimension of Horizontal Bar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 12),

            if (selectedUnit == 'Meter/CM') ...[
              _metricDual('Length of Bar', barLenM, barLenCM, textColor),
              const SizedBox(height: 12),
              _metricDual('Height of Bar', barHtM, barHtCM, textColor),
            ] else ...[
              _imperialDual('Length of Bar', barLenFT, barLenIN, textColor),
              const SizedBox(height: 12),
              _imperialDual('Height of Bar', barHtFT, barHtIN, textColor),
            ],

            const SizedBox(height: 20),
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
                hintText: '10',
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
    if (totalPanels == null) return const SizedBox.shrink();

    final rows = <List<String>>[
      ['Total Panels', (totalPanels ?? 0).toStringAsFixed(0)],
      ['Horizontal Bars', (totalHorizontalBars ?? 0).toStringAsFixed(0)],
      ['Vertical Post', (totalVerticalBars ?? 0).toStringAsFixed(0)],
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
