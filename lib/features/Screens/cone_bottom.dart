// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';
import 'package:construction_calculator/Domain/entities/cone_bottom_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';

class ConeBottom extends ConsumerStatefulWidget {
  const ConeBottom({super.key});

  @override
  ConsumerState<ConeBottom> createState() => _ConeBottomState();
}

class _ConeBottomState extends ConsumerState<ConeBottom> {
  final Color orangeColor = const Color(0xFFFF9C00);

  final TextEditingController topdiameterController = TextEditingController();
  final TextEditingController bottomdiameterController =
      TextEditingController();
  final TextEditingController cylinderheightController =
      TextEditingController();
  final TextEditingController coneheightController = TextEditingController();

  final TextEditingController filledController =
      TextEditingController(); // Filled Height

  final List<String> units = [
    'Meter',
    'Feet',
    'Inch',
    'MiliMeter',
    'CentiMeter',
  ];

  final List<String> volumeUnits = [
    'cm3',
    'dm3',
    'm3',
    'cu in',
    'cu ft',
    'cu yd',
    'ml',
    'l',
    'UK gal',
    'fl oz',
    'qt',
    'pt',
  ];

  final Map<String, double> volumeConversion = {
    'cm3': 1000000, // 1 m³ = 1,000,000 cm³
    'dm3': 1000, // 1 m³ = 1000 dm³
    'm3': 1,
    'cu in': 61023.7441,
    'cu ft': 35.314666721489, // more precise
    'cu yd': 1.307950619314, // more precise
    'ml': 1000000, // same as cm³
    'l': 1000,
    'UK gal': 219.9692483, // approx 1 m³ = 219.969 UK gallons
    'fl oz': 35195.0797, // US fluid ounces per m³ approx
    'qt': 1056.6882094,
    'pt': 2113.3764189,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculate());
  }

  void _calculate() {
    final double? diameterInput = double.tryParse(
      bottomdiameterController.text,
    ); // Bottom diameter
    final double? cylinderHeightInput = double.tryParse(
      cylinderheightController.text,
    );
    final double? coneHeightInput = double.tryParse(coneheightController.text);
    final double? filledInput = double.tryParse(filledController.text);

    if (diameterInput == null ||
        cylinderHeightInput == null ||
        coneHeightInput == null) {
      setState(() {
        totalVolume = 0;
        filledVolume = 0;
        convertedValues = {};
      });
      return;
    }

    final Map<String, double> unitToMeter = {
      'Meter': 1.0,
      'Feet': 0.3048,
      'Inch': 0.0254,
      'MiliMeter': 0.001,
      'CentiMeter': 0.01,
    };

    final double diameterM = diameterInput * (unitToMeter[selectedUnit] ?? 1.0);
    final double radiusM = diameterM / 2.0;
    final double cylinderHeightM =
        cylinderHeightInput * (unitToMeter[selectedUnit] ?? 1.0);
    final double coneHeightM =
        coneHeightInput * (unitToMeter[selectedUnit] ?? 1.0);

    // Total volume = cylinder + cone
    final double totalM3 =
        pi * pow(radiusM, 2) * cylinderHeightM +
        (pi / 3) * pow(radiusM, 2) * coneHeightM;

    // Filled volume calculation
    double filledHeightM =
        (filledInput ?? 0) * (unitToMeter[selectedUnit] ?? 1.0);
    double filledM3 = 0;

    if (filledHeightM <= cylinderHeightM) {
      filledM3 = pi * pow(radiusM, 2) * filledHeightM;
    } else if (filledHeightM <= cylinderHeightM + coneHeightM) {
      // Filled partially in cone
      double coneFilledHeight = filledHeightM - cylinderHeightM;
      filledM3 =
          pi * pow(radiusM, 2) * cylinderHeightM +
          (pi / 3) * pow(radiusM, 2) * coneFilledHeight;
    } else {
      // Filled more than tank height
      filledM3 = totalM3;
    }

    setState(() {
      totalVolume = totalM3;
      filledVolume = filledM3;

      convertedValues = volumeConversion.map((unit, factor) {
        return MapEntry(unit, totalM3 * factor);
      });
    });

    _saveHistory();
  }

  void _saveHistory() {
    final double? topDiameterVal = double.tryParse(topdiameterController.text);
    final double? bottomDiameterVal = double.tryParse(
      bottomdiameterController.text,
    );
    final double? cylinderHeightVal = double.tryParse(
      cylinderheightController.text,
    );
    final double? coneHeightVal = double.tryParse(coneheightController.text);
    final double? filledHeightVal = double.tryParse(filledController.text);

    if (topDiameterVal == null ||
        bottomDiameterVal == null ||
        cylinderHeightVal == null ||
        coneHeightVal == null ||
        filledHeightVal == null) {
      return;
    }

    final item = ConeBottomHistoryItem(
      topDiameter: topDiameterVal,
      bottomDiameter: bottomDiameterVal,
      cylinderHeight: cylinderHeightVal,
      coneHeight: coneHeightVal,
      filledHeight: filledHeightVal,
      unit: selectedUnit,
      totalVolume: totalVolume,
      filledVolume: filledVolume,
      savedAt: DateTime.now(),
    );

    // Save to unified history provider
    ref.read(unifiedHistoryProvider.notifier).addConeBottom(item);
  }

  // Default selected unit
  String selectedUnit = "Meter";
  String selectedVolumeUnit = "cm3";
  String selectedFilledUnit = "cm3";

  // base volumes stored in m³
  double totalVolume = 0;
  double filledVolume = 0;

  // Converted values for the table (total only)
  Map<String, double> convertedValues = {};
  bool _viewOtherUnits = false;

  // DROPDOWN BUILDER (keeps style consistent)
  Widget _buildDropdown({
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: selectedValue,
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
      onChanged: onChanged,
      selectedItemBuilder: (context) {
        return options.map((v) => Center(child: Text(v))).toList();
      },
      items: options
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
    );
  }

  Widget _suffixInputWithDropdown({
    String? hintText,
    TextEditingController? controller,
    List<String>? dropdownOptions,
    String? selectedValue,
    ValueChanged<String?>? onChanged,
    TextInputType type = const TextInputType.numberWithOptions(decimal: true),
    ValueChanged<String>? onChangedInput,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.4),
      ),
      child: Row(
        children: [
          // Input field with hint
          if (controller != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 8),
                child: TextField(
                  controller: controller,
                  keyboardType: type,
                  textAlign: TextAlign.left,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText ?? '0',
                    hintStyle: TextStyle(
                      color: textColor.withOpacity(0.5),
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged:
                      onChangedInput, // <-- important: call _calculate when input changes
                ),
              ),
            ),

          // Dropdown at the end (input units)
          if (dropdownOptions != null && dropdownOptions.isNotEmpty)
            Container(
              height: 55,
              width: 115,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(50),
                  right: Radius.circular(50),
                ),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: _buildDropdown(
                options: dropdownOptions,
                selectedValue: selectedValue ?? dropdownOptions.first,
                onChanged: (v) {
                  if (onChanged != null) onChanged(v);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _resultTable(Color textColor) {
    if (totalVolume == 0) return const SizedBox.shrink();

    final rows = volumeUnits.map((unit) {
      final factor = volumeConversion[unit] ?? 1;
      final totalValue = totalVolume * factor;
      return [unit, totalValue.toStringAsFixed(2)];
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white38,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Result for ",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "Vertical Cylinder",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: orangeColor,
                  ),
                ),
                TextSpan(
                  text: " :",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Table(
            border: TableBorder.all(color: Colors.grey.withOpacity(0.3)),
            columnWidths: const {
              0: FlexColumnWidth(2), // Unit
              1: FlexColumnWidth(2), // Total Tank Volume
            },
            children: [
              const TableRow(
                decoration: BoxDecoration(color: Colors.white30),
                children: [
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
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Amount',
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
                  children: r.map((c) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        c,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _resultWithDropdown({
    required String label, // e.g. "Total Tank Volume" OR "Filled With"
    required double baseValueM3, // 👈 yahan har ek ka apna m³ value pass hoga
    required String selectedUnit,
    required List<String> dropdownOptions,
    required ValueChanged<String?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    // 👇 har ek apne baseValueM3 se convert hoga
    final factor = volumeConversion[selectedUnit] ?? 1;
    final convertedValue = baseValueM3 * factor;

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white30,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: Text(
                "$label : ${convertedValue.toStringAsFixed(2)} $selectedUnit",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            height: 55,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(50),
                right: Radius.circular(50),
              ),
              border: Border.all(color: Colors.orange, width: 1),
            ),
            child: _buildDropdown(
              options: dropdownOptions,
              selectedValue: selectedUnit,
              onChanged: onChanged,
            ),
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
          "Cone Bottom ",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 20,
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
                'assets/icons/cone_bottom_icon.svg',
                height: 100,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Formula:",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "V = π × R² × H_cyl + (1/3) × π × R² × H_cone",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "V_filled = π × R² × min(H_filled, H_cyl) + (1/3) × \n π × R² × max(H_filled - H_cyl, 0)",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: textColor,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Length
            _suffixInputWithDropdown(
              hintText: "Enter Top Diameter :",
              controller: topdiameterController,
              dropdownOptions: units,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate();
              },
              onChangedInput: (s) => _calculate(),
            ),
            const SizedBox(height: 10),

            // Width
            _suffixInputWithDropdown(
              hintText: "Enter Bottom Diameter :",
              controller: bottomdiameterController,
              dropdownOptions: units,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate();
              },
              onChangedInput: (s) => _calculate(),
            ),

            const SizedBox(height: 10),

            // Height
            _suffixInputWithDropdown(
              hintText: "Enter Cylinder Height :",
              controller: cylinderheightController,
              dropdownOptions: units,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate();
              },
              onChangedInput: (s) => _calculate(),
            ),

            const SizedBox(height: 10),

            // Height
            _suffixInputWithDropdown(
              hintText: "Enter Cone Height :",
              controller: coneheightController,
              dropdownOptions: units,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate();
              },
              onChangedInput: (s) => _calculate(),
            ),

            const SizedBox(height: 10),

            // Filled
            _suffixInputWithDropdown(
              hintText: "Enter Filled :",
              controller: filledController,
              dropdownOptions: units,
              selectedValue: selectedUnit,
              onChanged: (v) {
                setState(() => selectedUnit = v!);
                _calculate();
              },
              onChangedInput: (s) => _calculate(),
            ),

            const SizedBox(height: 10),

            Text(
              "Result:",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            _resultWithDropdown(
              label: "Total Tank Volume",
              baseValueM3: totalVolume, // 👈 total ka m³
              selectedUnit: selectedVolumeUnit,
              dropdownOptions: volumeUnits,
              onChanged: (v) {
                setState(() {
                  selectedVolumeUnit = v!;
                  _calculate(); // 👈 yeh add karo
                });
              },
            ),
            const SizedBox(height: 10),
            _resultWithDropdown(
              label: "Filled With",
              baseValueM3: filledVolume, // 👈 filled ka m³
              selectedUnit: selectedFilledUnit,
              dropdownOptions: volumeUnits,
              onChanged: (v) {
                setState(() {
                  selectedFilledUnit = v!;
                  _calculate(); // 👈 yeh add karo
                });
              },
            ),

            const SizedBox(height: 10),

            /// Result Table toggle
            if (_viewOtherUnits) ...[
              _resultTable(textColor),
              const SizedBox(height: 10),
            ],

            // Toggle Button
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _viewOtherUnits = !_viewOtherUnits;
                  });
                },
                child: Text(
                  _viewOtherUnits
                      ? "Hide Results in Other Units"
                      : "View Results in Other Units",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationColor: Color(0xFFFF9C00),
                    color: Color(0xFFFF9C00),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
