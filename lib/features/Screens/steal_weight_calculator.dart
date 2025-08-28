// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/steal_we_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StealWeightCalculator extends ConsumerStatefulWidget {
  const StealWeightCalculator({super.key});

  @override
  ConsumerState<StealWeightCalculator> createState() =>
      _StealWeightCalculatorState();
}

class _StealWeightCalculatorState extends ConsumerState<StealWeightCalculator> {
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

  final TextEditingController diamterController = TextEditingController();
  // Depth controllers
  final TextEditingController quantityController = TextEditingController();

  // RESULT VALUES
  double? volume;
  void _calculate() {
    // Diameter ka value parse karo
    double diameter = double.tryParse(diamterController.text) ?? 0;

    // Length ka value convert karo depending on unit
    double length = 0;
    if (selectedUnit == "Meter/CM") {
      final m = double.tryParse(lenM.text) ?? 0;
      final cm = double.tryParse(lenCM.text) ?? 0;
      length = m + (cm / 100); // cm ko meters mein convert karo
    } else {
      final ft = double.tryParse(lenFT.text) ?? 0;
      final inch = double.tryParse(lenIN.text) ?? 0;
      length =
          (ft + inch / 12) * 0.3048; // feet/inch ko meters mein convert karo
    }

    // Quantity parse karo
    int quantity = int.tryParse(quantityController.text) ?? 1;

    // Steel weight calculate karo (kg)
    // Formula: Weight = (Diameter^2 * Length * Quantity) / 162
    double weight = (diameter * diameter * length * quantity) / 162;

    // Result ko state mein save karo taki UI update ho
    setState(() {
      volume = weight;
    });
    _saveHistory();
  }

  void _saveHistory() {
    if (volume == null) return;

    double diameter = double.tryParse(diamterController.text) ?? 0;

    double length = 0;
    if (selectedUnit == "Meter/CM") {
      final m = double.tryParse(lenM.text) ?? 0;
      final cm = double.tryParse(lenCM.text) ?? 0;
      length = m + (cm / 100);
    } else {
      final ft = double.tryParse(lenFT.text) ?? 0;
      final inch = double.tryParse(lenIN.text) ?? 0;
      length = (ft + inch / 12) * 0.3048;
    }

    int quantity = int.tryParse(quantityController.text) ?? 1;

    final item = StealHistoryItem(
      diameter: diameter,
      length: length,
      quantity: quantity,
      volume: volume!,
      savedAt: DateTime.now(),
    );

    ref.read(unifiedHistoryProvider.notifier).addSteelWeight(item);

    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(const SnackBar(content: Text("History saved!")));
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
    String? textarea, // Optional text at the start
    String? unit, // Optional unit at the end
    TextInputType type = const TextInputType.numberWithOptions(decimal: true),
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white30,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.4),
      ),
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: [
          // Optional Start Text
          if (textarea != null && textarea.isNotEmpty) ...[
            Text(
              textarea,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],

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
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(100),
                right: Radius.circular(100),
              ),
              border: Border.all(color: orangeColor, width: 1),
            ),
            child: Center(
              child: unit?.trim().isNotEmpty == true
                  ? Text(
                      unit!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: orangeColor,
                      ),
                    )
                  : SizedBox.shrink(), // just empty space if unit is null/empty
            ),
          ),

          // Optional End Unit
          // if (unit != null && unit.trim().isNotEmpty) ...[
          //   const SizedBox(width: 8),
          //   Text(
          //     unit,
          //     style: TextStyle(
          //       fontFamily: 'Poppins',
          //       fontSize: 14,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.orange,
          //     ),
          //   ),
          // ],
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
      ['Volume', '${volume!.toStringAsFixed(0)} m³'],
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
                      'Unit',
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
          "Steal-Weight Calculator",
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
                'assets/icons/steal_weight_icon.svg',
                height: 85,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 8),

            // UNIT DROPDOWN
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                  width: 0.4,
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
                        fontWeight: FontWeight.w600,
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
                      border: Border.all(color: orangeColor, width: 1),
                    ),
                    child: _buildUnitDropdown(textColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // LENGTH & WIDTH
            if (selectedUnit == 'Meter/CM') ...[
              _metricDual('Length', lenM, lenCM, textColor),
              const SizedBox(height: 8),
            ] else ...[
              _imperialDual('Length', lenFT, lenIN, textColor),
            ],

            const SizedBox(height: 8),
            _suffixInput(
              textarea: "Diameter",
              controller: diamterController,
              unit: "MM",
            ),
            const SizedBox(height: 8),

            const SizedBox(height: 8),
            _suffixInput(
              textarea: "Quantity",
              controller: quantityController,
              unit: "pcs",
            ),
            const SizedBox(height: 8),

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

            const SizedBox(height: 8),

            // RESULTS
            _resultTable(textColor),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
