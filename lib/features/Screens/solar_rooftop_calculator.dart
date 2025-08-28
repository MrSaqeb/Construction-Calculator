// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/solar_roofttop_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

class SolorCalculatorScreen extends ConsumerStatefulWidget {
  const SolorCalculatorScreen({super.key});

  @override
  ConsumerState<SolorCalculatorScreen> createState() =>
      _SolorCalculatorScreenState();
}

class _SolorCalculatorScreenState extends ConsumerState<SolorCalculatorScreen> {
  // yaha aapka state logic}
  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // CONSUMPTION TYPE DROPDOWN
  final List<String> consumptionOptions = const ["Monthly Unit", "Yearly Unit"];
  String selectedConsumption = "Monthly Unit";

  // CONSUMPTION INPUT CONTROLLER
  final TextEditingController consumptionController = TextEditingController();

  double? totalcons; // Total Panels
  double? dailyUnit; // Daily Unit Consumption
  double? kwSystem; // KW System Recommended
  double? rooftopAreaSqFt; // Total Area in Sq ft
  double? rooftopAreaSqM; // Total Area in Sq m

  void _calculate() {
    final double? consumption = double.tryParse(consumptionController.text);
    if (consumption == null || consumption <= 0) {
      // Invalid input handling
      return;
    }

    // 1️⃣ Daily Consumption
    double dailyConsumption = selectedConsumption == "Monthly Unit"
        ? consumption / 30
        : consumption / 365;

    // 2️⃣ System Capacity in KW
    double systemCapacityKW = dailyConsumption / 4.5;

    // 3️⃣ Number of Panels
    double panelKW = 0.33; // per panel capacity
    int numberOfPanels = (systemCapacityKW / panelKW).ceil();

    // 4️⃣ Rooftop Area
    double areaPerKW = 95; // Sq ft per KW
    double totalAreaSqFt = systemCapacityKW * areaPerKW;
    double totalAreaSqM = totalAreaSqFt / 10.764;

    // Update the state for UI
    setState(() {
      totalcons = numberOfPanels.toDouble();
      dailyUnit = dailyConsumption;
      kwSystem = systemCapacityKW;
      rooftopAreaSqFt = totalAreaSqFt;
      rooftopAreaSqM = totalAreaSqM;
    });
    saveSolarHistory(ref);
  }

  Future<void> saveSolarHistory(WidgetRef ref) async {
    final input = double.tryParse(consumptionController.text) ?? 0;

    final historyItem = SolarHistoryItem(
      consumptionType: selectedConsumption,
      inputConsumption: input,
      dailyUnit: dailyUnit ?? 0,
      kwSystem: kwSystem ?? 0,
      totalPanels: totalcons ?? 0,
      rooftopAreaSqFt: rooftopAreaSqFt ?? 0,
      rooftopAreaSqM: rooftopAreaSqM ?? 0,
      timestamp: DateTime.now(),
    );

    // 1️⃣ Hive Box (agar use karna ho)
    if (Hive.isBoxOpen(HiveBoxes.solarHistory)) {
      ref.read(unifiedHistoryProvider.notifier).addSolarHistory(historyItem);
    }
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
          "Solar Rooftop Calculator",
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
                'assets/icons/solar_rooftop_icon.svg',
                height: 90,

                color: orangeColor,
              ),
            ),
            const SizedBox(height: 18),

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
                      'Consumption Type',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
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
                    child: _buildConsumptionDropdown(textColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            _suffixInput(
              controller: consumptionController,
              unit: "Units",
              period: selectedConsumption == "Monthly Unit" ? "Month" : "Year",
            ),

            const SizedBox(height: 12),
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

  Widget _buildConsumptionDropdown(Color textColor) {
    return DropdownButton<String>(
      value: selectedConsumption,
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
        selectedConsumption = v!;
      }),
      selectedItemBuilder: (context) {
        return consumptionOptions.map((v) => Center(child: Text(v))).toList();
      },
      items: consumptionOptions
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
    );
  }

  Widget _suffixInput({
    required TextEditingController controller,
    required String unit,
    required String period, // "Month" ya "Year"
    TextInputType type = const TextInputType.numberWithOptions(decimal: true),
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // Left Unit
          Text(
            unit,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 8),

          // Center Input
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
                hintText: '0',
                hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
              ),
            ),
          ),

          // Right Period (dynamic)
          Text(
            period,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultTable(Color textColor) {
    if (totalcons == null) return const SizedBox.shrink();

    final rows = <List<String>>[
      ['Total Plates', '${totalcons?.toStringAsFixed(0) ?? '0'} Plates'],
      [
        'Rooftop Area',
        '${rooftopAreaSqFt?.toStringAsFixed(2) ?? '0'} Sq ft / ${rooftopAreaSqM?.toStringAsFixed(2) ?? '0'} Sq m',
      ],
      ['Daily Unit', '${dailyUnit?.toStringAsFixed(2) ?? '0'} Units/day'],
      ['KW System', '${kwSystem?.toStringAsFixed(2) ?? '0'} kW'],
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
                          color: r[0] == 'Total Plates'
                              ? orangeColor
                              : textColor,
                          fontWeight: r[0] == 'Total Plates'
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
