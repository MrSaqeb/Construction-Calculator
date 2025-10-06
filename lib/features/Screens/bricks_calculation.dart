// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'dart:io';
import 'dart:math';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/brick_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

class BrickCalculationScreen extends ConsumerStatefulWidget {
  const BrickCalculationScreen({super.key});

  @override
  ConsumerState<BrickCalculationScreen> createState() =>
      _BrickCalculationScreenState();
}

class _BrickCalculationScreenState
    extends ConsumerState<BrickCalculationScreen> {
  bool isMetric = true; // true = meters/cm, false = feet/inch

  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // UNIT SELECTION — like currency dropdown style
  final List<String> unitOptions = const ["Meter/CM", "Feet/Inch"];
  String selectedUnit = "Meter/CM";

  // INPUT CONTROLLERS
  // Length
  final TextEditingController lenM = TextEditingController();
  final TextEditingController lenCM = TextEditingController();
  final TextEditingController lenFT = TextEditingController();
  final TextEditingController lenIN = TextEditingController();
  // Height
  final TextEditingController htM = TextEditingController();
  final TextEditingController htCM = TextEditingController();
  final TextEditingController htFT = TextEditingController();
  final TextEditingController htIN = TextEditingController();
  // Thickness (single value: cm for Metric, inch for Imperial)
  final TextEditingController thick = TextEditingController();
  // Mortar ratio dropdown (1:X)
  final List<int> ratios = const [3, 4, 5, 6, 7, 8];
  int selectedRatioX = 6;
  // Brick size (in cm)
  final TextEditingController brickLcm = TextEditingController(text: '19');
  final TextEditingController brickWcm = TextEditingController(text: '9');
  final TextEditingController brickHcm = TextEditingController(text: '9');

  // RESULT MODEL
  int? totalBricks;
  double? masonryVol; // m³
  double? cementBags; // 50kg
  double? sandTons; // tons

  // =============== CALCULATION LOGIC (website-style) ==================
  // Constants (industry typical)
  static const double jointM = 0.01; // 10 mm mortar joint
  static const double wasteFactor = 1.15; // +15% wastage
  static const double dryFactor = 1.25; // wet→dry conversion +25%
  static const double bagVolumeM3 = 0.035; // 1 cement bag volume ≈ 0.035 m³
  static const double sandDensityKgPerM3 = 1500; // dry loose sand

  double _toMeters_LengthHeight() {
    if (selectedUnit == "Meter/CM") {
      final m = double.tryParse(lenM.text) ?? 0;
      final cm = double.tryParse(lenCM.text) ?? 0;
      return m + (cm / 100.0);
    } else {
      final ft = double.tryParse(lenFT.text) ?? 0;
      final inch = double.tryParse(lenIN.text) ?? 0;
      return (ft + inch / 12.0) * 0.3048;
    }
  }

  double _toMeters_Height() {
    if (selectedUnit == "Meter/CM") {
      final m = double.tryParse(htM.text) ?? 0;
      final cm = double.tryParse(htCM.text) ?? 0;
      return m + (cm / 100.0);
    } else {
      final ft = double.tryParse(htFT.text) ?? 0;
      final inch = double.tryParse(htIN.text) ?? 0;
      return (ft + inch / 12.0) * 0.3048;
    }
  }

  double _toMeters_Thickness() {
    if (selectedUnit == "Meter/CM") {
      // thickness entered in cm
      final cm = double.tryParse(thick.text) ?? 0; // cm
      return cm / 100.0; // m
    } else {
      // thickness entered in inches
      final inch = double.tryParse(thick.text) ?? 0; // in
      return (inch / 12.0) * 0.3048; // m
    }
  }

  void _calculate() {
    // 1) wall volume
    final Lm = _toMeters_LengthHeight();
    final Hm = _toMeters_Height();
    final Tm = _toMeters_Thickness();
    final wallVolM3 = max(0.0, Lm * Hm * Tm);

    // 2) Brick sizes (input always in cm)
    final bL = (double.tryParse(brickLcm.text) ?? 0) / 100.0; // m
    final bW = (double.tryParse(brickWcm.text) ?? 0) / 100.0; // m
    final bH = (double.tryParse(brickHcm.text) ?? 0) / 100.0; // m

    // With-mortar approx (add 10mm each side)
    final bLm = bL + jointM;
    final bWm = bW + jointM;
    final bHm = bH + jointM;

    final brickVolWithMortar = max(1e-9, bLm * bWm * bHm);
    final brickVolWithoutMortar = max(1e-9, bL * bW * bH);

    // 3) Total bricks (ceil)
    final bricks = (wallVolM3 / brickVolWithMortar).ceil();

    // 4) Mortar wet volume then dry with factors
    final mortarWet = max(0.0, wallVolM3 - bricks * brickVolWithoutMortar);
    final mortarDry = mortarWet * wasteFactor * dryFactor;

    // 5) Mix 1:X split
    final parts = 1 + selectedRatioX; // total parts
    final cementVol = mortarDry * (1 / parts);
    final sandVol = mortarDry * (selectedRatioX / parts);

    // 6) Cement (bags) & Sand (tons)
    final bags = cementVol / bagVolumeM3;
    final sandKg = sandVol * sandDensityKgPerM3;
    final sandTon = sandKg / 1000.0;

    setState(() {
      totalBricks = bricks;
      masonryVol = wallVolM3; // m³
      cementBags = bags;
      sandTons = sandTon;
    });
    saveBrickHistory(ref);
  }

  Future<void> saveBrickHistory(WidgetRef ref) async {
    // 1️⃣ Naya BrickHistoryItem object
    final historyItem = BrickHistoryItem(
      lenM: lenM.text,
      lenCM: lenCM.text,
      lenFT: lenFT.text,
      lenIN: lenIN.text,
      htM: htM.text,
      htCM: htCM.text,
      htFT: htFT.text,
      htIN: htIN.text,
      thickness: thick.text,
      brickLcm: brickLcm.text,
      brickWcm: brickWcm.text,
      brickHcm: brickHcm.text,
      mortarX: selectedRatioX,
      bricksQty: totalBricks?.toDouble() ?? 0.0,
      unit: selectedUnit,
    );

    // 2️⃣ Hive box me store karo
    if (Hive.isBoxOpen(HiveBoxes.brickHistory)) {
    } else {}

    // 3️⃣ UnifiedHistoryProvider me add karo using addBrick
    ref.read(unifiedHistoryProvider.notifier).addBrick(historyItem);
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
                color: textColor, // Added text color based on theme
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: '10',
                hintStyle: TextStyle(
                  color: textColor.withOpacity(0.5),
                ), // Hint color
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

  Widget _ratioDropdown(Color textColor) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.2),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Mortar Ratio',
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
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedRatioX,
                icon: Icon(Icons.arrow_drop_down, color: orangeColor, size: 23),
                isExpanded: true,
                alignment: Alignment.center,
                style: TextStyle(
                  color: orangeColor,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (v) {
                  setState(() {
                    selectedRatioX = v!;
                  });
                },
                items: ratios
                    .map(
                      (x) => DropdownMenuItem(
                        value: x,
                        child: Center(child: Text('1:$x')),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultTable(Color textColor) {
    if (totalBricks == null) return const SizedBox.shrink();

    final rows = <List<String>>[
      ['Bricks', (totalBricks ?? 0).toStringAsFixed(0)],
      ['Cement', (cementBags ?? 0).toStringAsFixed(2), 'Bags'],
      ['Sand', (sandTons ?? 0).toStringAsFixed(3), 'Tons'],
      ['Volume ', (masonryVol ?? 0).toStringAsFixed(3), 'm³'],
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
                        '${r[1]}  ${r.length > 2 ? r[2] : ''}', // safe check
                        style: TextStyle(
                          color: r[0] == 'Volume (Masonry)'
                              ? orangeColor
                              : textColor,
                          fontWeight: r[0] == 'Volume (Masonry)'
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
          "Bricks Calculator",
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
                'assets/icons/brick_icon.svg',
                height: 90,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 18),

            // UNIT DROPDOWN (orange like currency)
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
                    width: 120,
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

            const SizedBox(height: 6),

            // LENGTH & HEIGHT
            if (selectedUnit == 'Meter/CM') ...[
              _metricDual('Length', lenM, lenCM, textColor),
              const SizedBox(height: 12),
              _metricDual('Height', htM, htCM, textColor),
            ] else ...[
              _imperialDual('Length', lenFT, lenIN, textColor),
              const SizedBox(height: 12),
              _imperialDual('Height', htFT, htIN, textColor),
            ],

            const SizedBox(height: 12),

            // THICKNESS (cm or inch depending on unit)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wall Thickness',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                _suffixInput(
                  controller: thick,
                  unit: selectedUnit == 'Meter/CM' ? 'CM' : 'Inches',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // RATIO DROPDOWN (1:X)
            _ratioDropdown(textColor),

            const SizedBox(height: 16),

            // BRICK SIZE (always cm)
            Text(
              'Size of Brick ',
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
                  child: _suffixInput(controller: brickLcm, unit: 'Length'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _suffixInput(controller: brickWcm, unit: 'Width'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _suffixInput(controller: brickHcm, unit: 'Height'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // CUSTOM ORANGE BUTTON (same style as your Result button)
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
