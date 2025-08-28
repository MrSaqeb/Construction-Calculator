// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:construction_calculator/Domain/entities/flooring_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';

class FlooringCalculatorScreen extends ConsumerStatefulWidget {
  const FlooringCalculatorScreen({super.key});

  @override
  ConsumerState<FlooringCalculatorScreen> createState() =>
      _FlooringCalculatorScreenState();
}

class _FlooringCalculatorScreenState
    extends ConsumerState<FlooringCalculatorScreen> {
  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // UNIT SELECTION
  final List<String> unitOptions = const ["Meter/CM", "Feet/Inch"];
  String selectedUnit = "Meter/CM";

  // FLOOR DIMENSIONS
  final TextEditingController lenM = TextEditingController();
  final TextEditingController lenCM = TextEditingController();
  final TextEditingController lenFT = TextEditingController();
  final TextEditingController lenIN = TextEditingController();

  final TextEditingController widM = TextEditingController();
  final TextEditingController widCM = TextEditingController();
  final TextEditingController widFT = TextEditingController();
  final TextEditingController widIN = TextEditingController();

  // TILE SIZE (always in feet for calculation)
  final TextEditingController tileLenFT = TextEditingController(text: '1');
  final TextEditingController tileWidFT = TextEditingController(text: '1');

  // Results
  int? totaltile;
  double? masonryVol;
  double? cementBags;
  double? sandTons;

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
      final m = double.tryParse(widM.text) ?? 0;
      final cm = double.tryParse(widCM.text) ?? 0;
      return m + cm / 100.0;
    } else {
      final ft = double.tryParse(widFT.text) ?? 0;
      final inch = double.tryParse(widIN.text) ?? 0;
      return (ft + inch / 12.0) * 0.3048;
    }
  }

  void _calculate() {
    // Get floor dimensions in meters
    final lengthMeters = _toMetersLength();
    final widthMeters = _toMetersWidth();

    // Get tile dimensions in feet and convert to meters
    final tileLengthFt = double.tryParse(tileLenFT.text) ?? 1.0;
    final tileWidthFt = double.tryParse(tileWidFT.text) ?? 1.0;

    final tileLengthM = tileLengthFt * 0.3048;
    final tileWidthM = tileWidthFt * 0.3048;

    // Calculate flooring area
    final flooringArea = lengthMeters * widthMeters;

    // Calculate area of one tile

    // Calculate number of tiles using accurate formula
    final tilesAlongLength = (lengthMeters / tileLengthM).ceil();
    final tilesAlongWidth = (widthMeters / tileWidthM).ceil();
    final tilesWithoutWastage = tilesAlongLength * tilesAlongWidth;

    // Add 10% for wastage and cutting
    final totalTilesNeeded = (tilesWithoutWastage * 1.10).ceil();

    // Calculate mortar requirements (12mm thickness)
    final mortarThickness = 0.012;
    final mortarVolume = flooringArea * mortarThickness;

    // Calculate cement and sand for mortar (1:4 ratio)
    final dryVolume = mortarVolume * 1.33;
    final cementVolume = dryVolume / 5;
    final cementBagsNeeded = cementVolume / 0.035;
    final sandVolume = (dryVolume * 4) / 5;
    final sandTonsNeeded = sandVolume * 1.6;

    // Update state with results
    setState(() {
      totaltile = totalTilesNeeded;
      masonryVol = mortarVolume;
      cementBags = cementBagsNeeded;
      sandTons = sandTonsNeeded;
    });
    saveFlooringHistory();
  }

  void saveFlooringHistory() async {
    if (totaltile == null ||
        masonryVol == null ||
        cementBags == null ||
        sandTons == null) {
      return; // Agar calculation nahi hui to save mat karo
    }

    // Naya FlooringHistoryItem create karo
    final newItem = FlooringHistoryItem(
      selectedUnit: selectedUnit,
      floorLength: _toMetersLength(),
      floorWidth: _toMetersWidth(),
      tileLength: double.tryParse(tileLenFT.text) ?? 1.0,
      tileWidth: double.tryParse(tileWidFT.text) ?? 1.0,
      totalTiles: totaltile!,
      cementBags: cementBags!,
      sandTons: sandTons!,
      mortarVolume: masonryVol!,
      savedAt: DateTime.now(),
    );

    // UnifiedHistoryNotifier ko update karo
    ref.read(unifiedHistoryProvider.notifier).addFlooring(newItem);
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text(' data saved to history!')));
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

  Widget _tileSizeInputs(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dimension of Tile',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Length',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _suffixInput(controller: tileLenFT, unit: 'ft'),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Width',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: textColor.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _suffixInput(controller: tileWidFT, unit: 'ft'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _resultTable(Color textColor) {
    if (totaltile == null) return const SizedBox.shrink();

    final rows = <List<String>>[
      ['Tiles', (totaltile ?? 0).toStringAsFixed(0)],
      ['Cement', (cementBags ?? 0).toStringAsFixed(2), 'Bags'],
      ['Sand', (sandTons ?? 0).toStringAsFixed(3), 'Tons'],
      ['Volume', (masonryVol ?? 0).toStringAsFixed(3), 'm³'],
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
                        '${r[1]}  ${r.length > 2 ? r[2] : ''}',
                        style: TextStyle(
                          color: r[0] == 'Mortar Volume'
                              ? orangeColor
                              : textColor,
                          fontWeight: r[0] == 'Mortar Volume'
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
          "Flooring Calculator",
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
            const SizedBox(height: 14),
            Center(
              child: SvgPicture.asset(
                'assets/icons/flooring_icon.svg',
                height: 90,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 18),

            // Unit Dropdown
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

            const SizedBox(height: 16),

            // LENGTH & WIDTH
            if (selectedUnit == 'Meter/CM') ...[
              _metricDual('Length', lenM, lenCM, textColor),
              const SizedBox(height: 12),
              _metricDual('Width', widM, widCM, textColor),
            ] else ...[
              _imperialDual('Length', lenFT, lenIN, textColor),
              const SizedBox(height: 12),
              _imperialDual('Width', widFT, widIN, textColor),
            ],

            const SizedBox(height: 16),

            // TILE SIZE (always in feet)
            _tileSizeInputs(textColor),

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
          ],
        ),
      ),
    );
  }
}
