// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:construction_calculator/Domain/entities/paint_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaintCalculationScreen extends ConsumerStatefulWidget {
  const PaintCalculationScreen({super.key});

  @override
  ConsumerState<PaintCalculationScreen> createState() =>
      _PaintCalculationScreenState();
}

class _PaintCalculationScreenState
    extends ConsumerState<PaintCalculationScreen> {
  //  bool isMetric = true; // true = meters/cm, false = feet/inch

  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // UNIT SELECTION — like currency dropdown style
  final List<String> unitOptions = const ["Meter", "Feet"];
  String selectedUnit = "Meter";

  // Controllers
  final TextEditingController carpetController = TextEditingController();

  // Door controllers
  final TextEditingController noOfDoorsController = TextEditingController();
  final TextEditingController doorWidthController = TextEditingController();
  final TextEditingController doorHeightController = TextEditingController();

  // Window controllers
  final TextEditingController noOfWindowsController = TextEditingController();
  final TextEditingController windowWidthController = TextEditingController();
  final TextEditingController windowHeightController = TextEditingController();

  // Result variables
  double paintAreaResult = 0.0;
  double paintQuantityResult = 0.0;
  double primerQuantityResult = 0.0;
  double puttyQuantityResult = 0.0;

  void _calculate() {
    FocusScope.of(context).unfocus(); // hide keyboard

    // 1️⃣ Read values from controllers
    double carpetArea = double.tryParse(carpetController.text) ?? 0.0;

    int noOfDoors = int.tryParse(noOfDoorsController.text) ?? 0;
    double doorWidth = double.tryParse(doorWidthController.text) ?? 0.0;
    double doorHeight = double.tryParse(doorHeightController.text) ?? 0.0;

    int noOfWindows = int.tryParse(noOfWindowsController.text) ?? 0;
    double windowWidth = double.tryParse(windowWidthController.text) ?? 0.0;
    double windowHeight = double.tryParse(windowHeightController.text) ?? 0.0;

    // 2️⃣ Convert units if needed
    // If user selected Feet, convert everything to meters for calculation
    if (selectedUnit == "Feet") {
      const double feetToMeter = 0.3048;
      carpetArea = carpetArea * 0.092903; // ft² -> m²
      doorWidth *= feetToMeter;
      doorHeight *= feetToMeter;
      windowWidth *= feetToMeter;
      windowHeight *= feetToMeter;
    }

    // 3️⃣ Wall area (assuming standard wall height)
    double wallHeight = 3.5; // meters
    double wallArea = carpetArea * wallHeight;

    // 4️⃣ Door & window areas
    double totalDoorArea = noOfDoors * doorWidth * doorHeight;
    double totalWindowArea = noOfWindows * windowWidth * windowHeight;

    // 5️⃣ Actual paint area
    double totalPaintArea = wallArea - totalDoorArea - totalWindowArea;
    // if (totalPaintArea < 0) totalPaintArea = 0;

    // 6️⃣ Convert back to Feet if selected
    if (selectedUnit == "Feet") {
      totalPaintArea *= 10.7639; // m² -> ft²
    }

    // 7️⃣ Material quantities
    double paintQty = totalPaintArea / 9.29; // 1 liter covers 9.29 m²
    double primerQty = paintQty;
    double puttyQty = paintQty * 2.5; // 2.5 kg per 9.29 m²

    // 8️⃣ Update state to show results
    setState(() {
      paintAreaResult = totalPaintArea;
      paintQuantityResult = paintQty;
      primerQuantityResult = primerQty;
      puttyQuantityResult = puttyQty;
    });
    savePaintHistory(ref);
  }

  Future<void> savePaintHistory(WidgetRef ref) async {
    // Input aur calculation results
    final paintArea = paintAreaResult;
    final paintQty = paintQuantityResult;
    final primerQty = primerQuantityResult;
    final puttyQty = puttyQuantityResult;
    final unit = selectedUnit;

    // History item create karein
    final historyItem = PaintHistoryItem(
      paintArea: paintArea,
      paintQuantity: paintQty,
      primerQuantity: primerQty,
      puttyQuantity: puttyQty,
      unit: unit,
      date: DateTime.now(),
    );
    // Box agar open nahi hai, to pehle open karein
    ref.read(unifiedHistoryProvider.notifier).addPaintHistory(historyItem);
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
    String? label, // label optional
    TextInputType type = const TextInputType.numberWithOptions(decimal: true),
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.white,
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(50),
              right: Radius.circular(50),
            ),
            border: Border.all(color: Colors.orange, width: 2),
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
                width: 70,
                alignment: Alignment.center,
                child: Text(
                  unit,
                  style: TextStyle(
                    color: Colors.orange,
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget doorSizeSection({
    required String selectedUnit, // 'Meter' or 'Feet'
    required TextEditingController widthController,
    required TextEditingController heightController,
  }) {
    final unitText = selectedUnit;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            'Door Size',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 29),

        // Row containing Width & Height inputs
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Width
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Width',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2), // Minimal gap
                SizedBox(
                  width: 100,
                  child: _suffixInput(
                    controller: widthController,
                    label: null, // Pass null to avoid the label in _suffixInput
                    unit: unitText,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8), // space between Width & Height
            // Height
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Height',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2), // Minimal gap (same as Width)
                SizedBox(
                  width: 100,
                  child: _suffixInput(
                    controller: heightController,
                    label: null, // Pass null to avoid the label in _suffixInput
                    unit: unitText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget windowsSection({
    required String selectedUnit, // 'Meter' or 'Feet'
    required TextEditingController widthController,
    required TextEditingController heightController,
  }) {
    final unitText = selectedUnit;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label for the section
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            'No of Windows',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 10), // horizontal gap to inputs
        // Width & Height inputs
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Width
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Width',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: 100,
                  child: _suffixInput(
                    controller: widthController,
                    label: null,
                    unit: unitText,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8),

            // Height
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Height',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: 100,
                  child: _suffixInput(
                    controller: heightController,
                    label: null,
                    unit: unitText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _resultTable(Color textColor) {
    final rows = <List<String>>[
      [
        'Total Area',
        '${paintAreaResult.toStringAsFixed(2)} ${selectedUnit == "Feet" ? "ft²" : "m²"}',
      ],
      ['Paint', '${paintQuantityResult.toStringAsFixed(2)} ltr'],
      ['Primer', '${primerQuantityResult.toStringAsFixed(2)} ltr'],
      ['Putty', '${puttyQuantityResult.toStringAsFixed(2)} kgs'],
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
          "Paint Calculator",
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
            Center(
              child: SvgPicture.asset(
                'assets/icons/paint_work_icon.svg',
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
                    width: 100,
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
            _suffixInput(
              controller: carpetController,
              label: "Carpet Area",
              unit: "SQ.Meter",
            ),
            const SizedBox(height: 12),
            doorSizeSection(
              selectedUnit: selectedUnit, // 'Meter' or 'Feet'
              widthController: doorWidthController,
              heightController: doorHeightController,
            ),
            const SizedBox(height: 12),

            _suffixInput(
              controller: noOfDoorsController,
              label: "No of Doors",
              unit: "NOS",
            ),
            const SizedBox(height: 12),
            // Windows Section
            windowsSection(
              selectedUnit: selectedUnit, // 'Meter' or 'Feet'
              widthController: windowWidthController,
              heightController: windowHeightController,
            ),
            const SizedBox(height: 12),
            _suffixInput(
              controller: noOfWindowsController,
              label: "No of Windows",
              unit: "NOS",
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
