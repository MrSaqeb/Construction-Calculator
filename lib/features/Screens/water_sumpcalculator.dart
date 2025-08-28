// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/water_sump_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaterSumpCalculatorScreen extends ConsumerStatefulWidget {
  const WaterSumpCalculatorScreen({super.key});

  @override
  ConsumerState<WaterSumpCalculatorScreen> createState() =>
      _WaterSumpCalculatorScreenState();
}

class _WaterSumpCalculatorScreenState
    extends ConsumerState<WaterSumpCalculatorScreen> {
  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // UNIT SELECTION
  final List<String> unitOptions = const ["Meter/CM", "Feet/Inch"];
  String selectedUnit = "Meter/CM";

  // INPUT CONTROLLERS
  // Length
  final TextEditingController lenM = TextEditingController();
  final TextEditingController lenCM = TextEditingController();
  final TextEditingController lenFT = TextEditingController();
  final TextEditingController lenIN = TextEditingController();

  final TextEditingController widM = TextEditingController();
  final TextEditingController widCM = TextEditingController();
  final TextEditingController widFT = TextEditingController();
  final TextEditingController widIN = TextEditingController();

  final TextEditingController depthM = TextEditingController();
  final TextEditingController depthCM = TextEditingController();
  final TextEditingController depthFT = TextEditingController();
  final TextEditingController depthIN = TextEditingController();

  // RESULT VALUES
  double? volume;
  double? capastyoftank;
  // =============== CALCULATION LOGIC ==================
  void _calculate() {
    // 1. Convert inputs
    final length = _toMetersLength();
    final width = _toMetersWidth();
    final depth = _toMetersDepth();

    // 2. Volume in cubic meters
    volume = length * width * depth;

    // 3. Convert to liters
    capastyoftank = volume! * 1000;

    setState(() {});

    // Save to Hive
    saveWaterSumpHistory(
      length: length,
      width: width,
      depth: depth,
      volume: volume!,
    );
  }

  Future<void> saveWaterSumpHistory({
    required double length,
    required double width,
    required double depth,
    required double volume,
  }) async {
    // Volume ko liters aur cubic feet mein convert karo
    final capacityInLiters = volume * 1000;
    final capacityInCubicFeet = volume * 35.3147;

    // Naya history item create karo
    final newHistoryItem = WaterSumpHistoryItem(
      length: length,
      width: width,
      depth: depth,
      volume: volume,
      capacityInLiters: capacityInLiters,
      capacityInCubicFeet: capacityInCubicFeet,
      savedAt: DateTime.now(),
    );

    // UnifiedHistoryNotifier ko update karo
    ref.read(unifiedHistoryProvider.notifier).addWaterSump(newHistoryItem);

    // // Success message show karo
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Water Sump History saved successfully!')),
    // );
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
      final m = double.tryParse(widM.text) ?? 0;
      final cm = double.tryParse(widCM.text) ?? 0;
      return m + cm / 100.0;
    } else {
      final ft = double.tryParse(widFT.text) ?? 0;
      final inch = double.tryParse(widIN.text) ?? 0;
      return (ft + inch / 12.0) * 0.3048;
    }
  }

  double _toMetersDepth() {
    if (selectedUnit == "Meter/CM") {
      final m = double.tryParse(depthM.text) ?? 0;
      final cm = double.tryParse(depthCM.text) ?? 0;
      return m + cm / 100.0;
    } else {
      final ft = double.tryParse(depthFT.text) ?? 0;
      final inch = double.tryParse(depthIN.text) ?? 0;
      return (ft + inch / 12.0) * 0.3048;
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
    if (volume == null) return const SizedBox.shrink();

    final rows = <List<String>>[
      ['Volume', '${volume!.toStringAsFixed(3)} m³'],
      ['Capacity of Tank', (capastyoftank!.toStringAsFixed(4))],
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
          "Water-Sump Calculator",
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
                'assets/icons/water_sump_icon.svg',
                height: 85,
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
            const SizedBox(height: 12),
            // LENGTH, WIDTH & DEPTH
            if (selectedUnit == 'Meter/CM') ...[
              _metricDual('Length', lenM, lenCM, textColor),
              const SizedBox(height: 12),
              _metricDual('Width', widM, widCM, textColor),
              const SizedBox(height: 12),
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
                  Row(
                    children: [
                      Expanded(
                        child: _suffixInput(controller: depthM, unit: 'Meter'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _suffixInput(controller: depthCM, unit: 'CM'),
                      ),
                    ],
                  ),
                ],
              ),
            ] else ...[
              _imperialDual('Length', lenFT, lenIN, textColor),
              const SizedBox(height: 12),
              _imperialDual('Width', widFT, widIN, textColor),
              const SizedBox(height: 12),
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
                  Row(
                    children: [
                      Expanded(
                        child: _suffixInput(controller: depthFT, unit: 'Feet'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _suffixInput(
                          controller: depthIN,
                          unit: 'Inches',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
}
