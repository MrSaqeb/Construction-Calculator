// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:construction_calculator/Domain/entities/air_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class AirConditionCalculatorScreen extends ConsumerStatefulWidget {
  const AirConditionCalculatorScreen({super.key});

  @override
  ConsumerState<AirConditionCalculatorScreen> createState() =>
      _AirConditionCalculatorScreenState();
}

class _AirConditionCalculatorScreenState
    extends ConsumerState<AirConditionCalculatorScreen> {
  final Color orangeColor = const Color(0xFFFF9C00);

  // Room Dimensions
  final TextEditingController roomLenFT = TextEditingController();
  final TextEditingController roomLenIN = TextEditingController();

  final TextEditingController roomBrFT = TextEditingController();
  final TextEditingController roomBrIN = TextEditingController();

  final TextEditingController roomHtFT = TextEditingController();
  final TextEditingController roomHtIN = TextEditingController();

  // Extra Inputs
  final TextEditingController numPersons = TextEditingController();
  final TextEditingController maxTempC = TextEditingController();

  double? _acTonsResult;

  // ---- Helpers ----
  double _ftInToFeet(String ft, String inch) {
    final f = double.tryParse(ft) ?? 0;
    final i = double.tryParse(inch) ?? 0;
    return f + (i / 12.0);
  }

  // ignore: non_constant_identifier_names
  double _baseTons(double Lft, double Bft) {
    return (Lft * Bft * 20.0) / 12000.0;
  }

  double _peopleFactor(int persons) {
    if (persons <= 0) return 0.0; // if user enters 0
    final extra = (persons - 3).clamp(0, 1000);
    return 0.3 + 0.07 * extra;
  }

  double _tempFactorC(double c) {
    if (c > 45) return 0.5;
    if (c >= 41) return 0.4;
    if (c >= 36) return 0.3;
    return 0.2; // <= 35 (matches their example)
  }

  double _heightFactorFeet(double hFeet) {
    final over = hFeet - 8.0;
    return over > 0 ? 0.1 * over : 0.0;
  }

  void _calculate() {
    try {
      // Room dimensions -> feet
      final L = _ftInToFeet(roomLenFT.text, roomLenIN.text);
      final B = _ftInToFeet(roomBrFT.text, roomBrIN.text);
      final H = _ftInToFeet(roomHtFT.text, roomHtIN.text);

      // Raw inputs
      final persons = int.tryParse(numPersons.text.trim()) ?? 0;
      final tempC = double.tryParse(maxTempC.text.trim()) ?? 0;

      // Factors per website
      final base = _baseTons(L, B);
      final pFact = _peopleFactor(persons);
      final tFact = _tempFactorC(tempC);
      final hFact = _heightFactorFeet(H);

      final tons = base + pFact + tFact + hFact;
      final result = double.parse(tons.toStringAsFixed(2));

      setState(() => _acTonsResult = result);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error in calculation: $e")));
    }

    saveAcHistory(ref);
  }

  Future<void> saveAcHistory(WidgetRef ref) async {
    final historyItem = AirHistoryItem(
      lengthFt: double.tryParse(roomLenFT.text) ?? 0.0,
      lengthIn: double.tryParse(roomLenIN.text) ?? 0.0,
      breadthFt: double.tryParse(roomBrFT.text) ?? 0.0,
      breadthIn: double.tryParse(roomBrIN.text) ?? 0.0,
      heightFt: double.tryParse(roomHtFT.text) ?? 0.0,
      heightIn: double.tryParse(roomHtIN.text) ?? 0.0,
      persons: int.tryParse(numPersons.text) ?? 0,
      maxTempC: double.tryParse(maxTempC.text) ?? 0.0,
      tons: _acTonsResult ?? 0.0, // ✅ only calculated AC size
      savedAt: DateTime.now(),
    );

    ref.read(unifiedHistoryProvider.notifier).addAc(historyItem);
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(SnackBar(content: Text("History saved successfully")));
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
          "Air Condition Tonnage ",
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
                'assets/icons/air_conditioner_icon.svg',
                height: 90,

                color: orangeColor,
              ),
            ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Length of Room
                _imperialDual(
                  "Length of Room",
                  roomLenFT,
                  roomLenIN,
                  textColor,
                ),
                const SizedBox(height: 8),

                // Breadth of Room
                _imperialDual("Breadth of Room", roomBrFT, roomBrIN, textColor),
                const SizedBox(height: 8),

                // Height of Room
                _imperialDual("Height of Room", roomHtFT, roomHtIN, textColor),
                const SizedBox(height: 8),

                // Number of Persons
                Text(
                  "Number of Persons",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                _suffixInput(
                  controller: numPersons,
                  unit: "Persons",
                  type: TextInputType.number,
                ),
                const SizedBox(height: 8),

                // Max Temperature
                Text(
                  "Max Temperature",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                _suffixInput(
                  controller: maxTempC,
                  unit: "°C",
                  type: TextInputType.number,
                ),
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
    if (_acTonsResult == null) return const SizedBox.shrink();

    final rows = <List<String>>[
      ['Size Of Air Conditioner', (_acTonsResult ?? 0).toStringAsFixed(3)],
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
