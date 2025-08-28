// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Core/Hive/hive_box.dart';
import 'package:construction_calculator/Domain/entities/solor_waterheater_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

class SolorwaterheaterCalculatorScreen extends ConsumerStatefulWidget {
  const SolorwaterheaterCalculatorScreen({super.key});

  @override
  ConsumerState<SolorwaterheaterCalculatorScreen> createState() =>
      _SolorwaterheaterCalculatorScreenState();
}

class _SolorwaterheaterCalculatorScreenState
    extends ConsumerState<SolorwaterheaterCalculatorScreen> {
  // yaha aapka state logic}
  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // CONSUMPTION INPUT CONTROLLER
  final TextEditingController consController = TextEditingController();

  double? capastiy;

  void _calculate() {
    final int? persons = int.tryParse(consController.text);
    if (persons == null || persons <= 0) return;
    // Total water needed
    double totalWater = persons * 50;

    // Update state
    setState(() {
      capastiy = totalWater;
    });
    saveSolarHistory(ref);
  }

  Future<void> saveSolarHistory(WidgetRef ref) async {
    // Input ko parse karein
    final input = double.tryParse(consController.text) ?? 0;

    // History item create karein
    final historyItem = SolarWaterHistoryItem(
      inputConsumption: input,
      totalCapacity: capastiy ?? 0,
      timestamp: DateTime.now(),
    );

    // Agar Hive box open hai, to Riverpod notifier ko call karein
    if (Hive.isBoxOpen(HiveBoxes.solarHistory)) {
      ref
          .read(unifiedHistoryProvider.notifier)
          .addSolarWaterHeaterHistory(historyItem);
    } else {
      // Box agar open nahi hai, to pehle open karein
      await Hive.openBox<SolarWaterHistoryItem>(HiveBoxes.solarHistory);
      ref
          .read(unifiedHistoryProvider.notifier)
          .addSolarWaterHeaterHistory(historyItem);
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
          "Solar Water Heater Calculator",
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
                'assets/icons/solar_water_heater_icon.svg',
                height: 90,

                color: orangeColor,
              ),
            ),

            const SizedBox(height: 12),
            _suffixInput(
              controller: consController,
              label: "No of Persons",
              unit: "NOS",
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

  Widget _suffixInput({
    required TextEditingController controller,
    required String label, // Left label, e.g., "No of Persons"
    required String unit, // Right unit, e.g., "Nos"
    TextInputType type = const TextInputType.numberWithOptions(decimal: false),
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
          // Left label
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 8),

          // Center input
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

          // Right unit
          Text(
            unit,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultTable(Color textColor) {
    if (capastiy == null) return const SizedBox.shrink();

    final rows = <List<String>>[
      ['Total Capasity', '${capastiy?.toStringAsFixed(1) ?? '0'} Litters'],
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
                          color: r[0] == 'Total Capacity'
                              ? orangeColor
                              : textColor,
                          fontWeight: r[0] == 'Total Capacity'
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
