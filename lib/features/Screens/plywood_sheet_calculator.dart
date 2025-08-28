// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/plywood_sheet_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class PlywoodSheetScreen extends ConsumerStatefulWidget {
  const PlywoodSheetScreen({super.key});

  @override
  ConsumerState<PlywoodSheetScreen> createState() => _PlywoodSheetScreenState();
}

class _PlywoodSheetScreenState extends ConsumerState<PlywoodSheetScreen> {
  // yaha aapka state logic}
  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // UNIT SELECTION
  final List<String> unitOptions = const ["Meter/CM", "Feet/Inch"];
  String selectedUnit = "Meter/CM";

  // INPUT CONTROLLERS
  // Area Dimensions
  final TextEditingController roomLenM = TextEditingController();
  final TextEditingController roomLenCM = TextEditingController();
  final TextEditingController roomLenFT = TextEditingController();
  final TextEditingController roomLenIN = TextEditingController();

  final TextEditingController roomwtM = TextEditingController();
  final TextEditingController roomwtCM = TextEditingController();
  final TextEditingController roomwtFT = TextEditingController();
  final TextEditingController roomwtIN = TextEditingController();

  // Horizontal Bar Dimensions
  final TextEditingController plyLenM = TextEditingController();
  final TextEditingController plyLenCM = TextEditingController();
  final TextEditingController plyLenFT = TextEditingController();
  final TextEditingController plyLenIN = TextEditingController();

  final TextEditingController plywtM = TextEditingController();
  final TextEditingController plywtCM = TextEditingController();
  final TextEditingController plywtFT = TextEditingController();
  final TextEditingController plywtIN = TextEditingController();

  // Results ko change karo
  int? totalsheet;
  int? roomarea;
  int? plywoodcover;
  void _calculate() {
    double roomLength = 0, roomWidth = 0, plyLength = 0, plyWidth = 0;

    if (selectedUnit == "Meter/CM") {
      roomLength =
          (double.tryParse(roomLenM.text) ?? 0) +
          (double.tryParse(roomLenCM.text) ?? 0) / 100;
      roomWidth =
          (double.tryParse(roomwtM.text) ?? 0) +
          (double.tryParse(roomwtCM.text) ?? 0) / 100;
      plyLength =
          (double.tryParse(plyLenM.text) ?? 0) +
          (double.tryParse(plyLenCM.text) ?? 0) / 100;
      plyWidth =
          (double.tryParse(plywtM.text) ?? 0) +
          (double.tryParse(plywtCM.text) ?? 0) / 100;
    } else {
      roomLength =
          ((double.tryParse(roomLenFT.text) ?? 0) +
              (double.tryParse(roomLenIN.text) ?? 0) / 12) *
          0.3048;
      roomWidth =
          ((double.tryParse(roomwtFT.text) ?? 0) +
              (double.tryParse(roomwtIN.text) ?? 0) / 12) *
          0.3048;
      plyLength =
          ((double.tryParse(plyLenFT.text) ?? 0) +
              (double.tryParse(plyLenIN.text) ?? 0) / 12) *
          0.3048;
      plyWidth =
          ((double.tryParse(plywtFT.text) ?? 0) +
              (double.tryParse(plywtIN.text) ?? 0) / 12) *
          0.3048;
    }

    final roomArea = roomLength * roomWidth; // m²
    final plyCover = plyLength * plyWidth; // m²
    final sheets = (plyCover > 0) ? (roomArea / plyCover).ceil() : 0;

    setState(() {
      roomarea = roomArea.round(); // as integers
      plywoodcover = plyCover.round();
      totalsheet = sheets;
    });
    _savePlywoodSheet();
  }

  Future<void> _savePlywoodSheet() async {
    if (totalsheet == null || roomarea == null || plywoodcover == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please calculate first!')));
      return;
    }

    final plywoodData = PlywoodSheetItem(
      selectedUnit: selectedUnit,
      roomLength:
          (double.tryParse(roomLenM.text) ?? 0) +
          (double.tryParse(roomLenCM.text) ?? 0) / 100,
      roomWidth:
          (double.tryParse(roomwtM.text) ?? 0) +
          (double.tryParse(roomwtCM.text) ?? 0) / 100,
      plyLength:
          (double.tryParse(plyLenM.text) ?? 0) +
          (double.tryParse(plyLenCM.text) ?? 0) / 100,
      plyWidth:
          (double.tryParse(plywtM.text) ?? 0) +
          (double.tryParse(plywtCM.text) ?? 0) / 100,
      totalSheets: totalsheet!,
      roomArea: roomarea!.toDouble(),
      plywoodCover: plywoodcover!.toDouble(),
      savedAt: DateTime.now(),
    );
    await ref
        .read(unifiedHistoryProvider.notifier)
        .addPlywoodSheetHistory(plywoodData);
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
          "PlyWood Sheet Calculator",
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
                'assets/icons/plywood_sheets_icon.svg',
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

            if (selectedUnit == 'Meter/CM') ...[
              _metricDual('Room Length', roomLenM, roomLenCM, textColor),
              const SizedBox(height: 12),
              _metricDual('Room Width', roomwtM, roomwtCM, textColor),
            ] else ...[
              _imperialDual('Room Length', roomLenFT, roomLenIN, textColor),
              const SizedBox(height: 12),
              _imperialDual('Room Width', roomwtFT, roomwtIN, textColor),
            ],

            const SizedBox(height: 12),

            if (selectedUnit == 'Meter/CM') ...[
              _metricDual('PlyWood Length', plyLenM, plyLenCM, textColor),
              const SizedBox(height: 12),
              _metricDual('PlyWood Width', plywtM, plywtCM, textColor),
            ] else ...[
              _imperialDual('PlyWood Length', plyLenFT, plyLenIN, textColor),
              const SizedBox(height: 12),
              _imperialDual('PlyWood Width', plywtFT, plywtIN, textColor),
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
    if (totalsheet == null) return const SizedBox.shrink();

    final areaUnit = selectedUnit == "Meter/CM" ? "m²" : "ft²";

    final rows = <List<String>>[
      ['Total Sheets', '${totalsheet ?? 0} sheets'],
      ['Room Area', '${roomarea ?? 0} $areaUnit'],
      ['Plywood Cover', '${plywoodcover ?? 0} $areaUnit'],
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
