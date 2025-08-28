// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';
import 'package:construction_calculator/Domain/entities/concrete_tube_history_item.dart';
import 'package:construction_calculator/features/History/Application/unified_history_provider.dart';
import 'package:construction_calculator/features/Screens/History_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConcreteTubeCalculatorScreen extends ConsumerStatefulWidget {
  const ConcreteTubeCalculatorScreen({super.key});

  @override
  ConsumerState<ConcreteTubeCalculatorScreen> createState() =>
      _ConcreteTubeCalculatorScreenState();
}

class _ConcreteTubeCalculatorScreenState
    extends ConsumerState<ConcreteTubeCalculatorScreen> {
  // THEME ACCENTS
  final Color orangeColor = const Color(0xFFFF9C00);

  // UNIT SELECTION
  final List<String> unitOptions = const ["Meter/CM", "Feet/Inch"];
  String selectedUnit = "Meter/CM";

  // GRADE OPTIONS
  final List<String> gradeOptions = const [
    "M5 (1:5:10)",
    "M7.5 (1:4:8)",
    "M10 (1:3:6)",
    "M15 (1:2:4)",
    "M20 (1:1.5:3)",
    "M25 (1:1:2)",
  ];
  String selectedGrade = "M15 (1:2:4)";

  // INPUT CONTROLLERS
  final TextEditingController innerDiamM = TextEditingController();
  final TextEditingController innerDiamCM = TextEditingController();
  final TextEditingController outerDiamM = TextEditingController();
  final TextEditingController outerDiamCM = TextEditingController();

  final TextEditingController innerDiamFT = TextEditingController();
  final TextEditingController innerDiamIN = TextEditingController();
  final TextEditingController outerDiamFT = TextEditingController();
  final TextEditingController outerDiamIN = TextEditingController();

  // Metric
  final TextEditingController heightMController = TextEditingController();
  final TextEditingController heightCMController = TextEditingController();

  // Imperial
  final TextEditingController heightFTController = TextEditingController();
  final TextEditingController heightINController = TextEditingController();

  // No. of Tubes
  final TextEditingController noOfTubesController = TextEditingController();

  // RESULT VALUES
  double? concretetube;
  double? cementBags;
  double? sandCft;
  double? aggregateCft;
  List<double> _getRatiosForGrade(String grade) {
    switch (grade) {
      case "M5 (1:5:10)":
        return [1, 5, 10];
      case "M7.5 (1:4:8)":
        return [1, 4, 8];
      case "M10 (1:3:6)":
        return [1, 3, 6];
      case "M15 (1:2:4)":
        return [1, 2, 4];
      case "M20 (1:1.5:3)":
        return [1, 1.5, 3];
      case "M25 (1:1:2)":
        return [1, 1, 2];
      default:
        return [1, 2, 4];
    }
  }

  void _calculate() {
    try {
      // Number of tubes
      int noOfTubes = int.tryParse(noOfTubesController.text) ?? 1;

      double innerDiam;
      double outerDiam;
      double height;

      // Convert inputs to meters
      if (selectedUnit == "Meter/CM") {
        double innerM = double.tryParse(innerDiamM.text) ?? 0;
        double innerCM = double.tryParse(innerDiamCM.text) ?? 0;
        double outerM = double.tryParse(outerDiamM.text) ?? 0;
        double outerCM = double.tryParse(outerDiamCM.text) ?? 0;

        innerDiam = innerM + (innerCM / 100);
        outerDiam = outerM + (outerCM / 100);

        double hM = double.tryParse(heightMController.text) ?? 0;
        double hCM = double.tryParse(heightCMController.text) ?? 0;
        height = hM + hCM / 100; // meters
      } else {
        double innerFT = double.tryParse(innerDiamFT.text) ?? 0;
        double innerIN = double.tryParse(innerDiamIN.text) ?? 0;
        double outerFT = double.tryParse(outerDiamFT.text) ?? 0;
        double outerIN = double.tryParse(outerDiamIN.text) ?? 0;

        innerDiam = innerFT * 0.3048 + innerIN * 0.0254;
        outerDiam = outerFT * 0.3048 + outerIN * 0.0254;

        double hFT = double.tryParse(heightFTController.text) ?? 0;
        double hIN = double.tryParse(heightINController.text) ?? 0;
        height = hFT * 0.3048 + hIN * 0.0254;
      }

      // Minimum input check (example: 0.04m = 4cm)
      if (innerDiam < 0.04 || outerDiam < 0.04 || height < 0.04) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All inputs must be at least 4 cm (or 4 inches).'),
          ),
        );
        return;
      }

      // Inner cannot exceed outer
      if (innerDiam >= outerDiam) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Inner diameter cannot exceed or equal outer diameter.',
            ),
          ),
        );
        return;
      }

      // Volume of one tube
      double tubeVolume =
          pi * (pow(outerDiam, 2) - pow(innerDiam, 2)) * height / 4;
      double totalVolume = tubeVolume * noOfTubes;

      // Get material ratios
      List<double> ratio = _getRatiosForGrade(selectedGrade);
      double sumRatio = ratio.reduce((a, b) => a + b);

      // Material quantities
      double cementVol = totalVolume * ratio[0] / sumRatio;
      double sandVol = totalVolume * ratio[1] / sumRatio;
      double aggregateVol = totalVolume * ratio[2] / sumRatio;

      double cementBagCount = cementVol / 0.035;
      double sandTons = sandVol * 1550 / 1000;
      double aggregateTons = aggregateVol * 1350 / 1000;

      // Assign results
      setState(() {
        concretetube = totalVolume;
        cementBags = cementBagCount;
        sandCft = sandTons;
        aggregateCft = aggregateTons;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Calculation error: $e')));
    }
    saveConcreteTubeHistory(ref);
  }

  Future<void> saveConcreteTubeHistory(WidgetRef ref) async {
    final historyItem = ConcreteTubeHistoryItem(
      innerM: innerDiamM.text,
      innerCM: innerDiamCM.text,
      innerFT: innerDiamFT.text,
      innerIN: innerDiamIN.text,
      outerM: outerDiamM.text,
      outerCM: outerDiamCM.text,
      outerFT: outerDiamFT.text,
      outerIN: outerDiamIN.text,
      heightM: heightMController.text,
      heightCM: heightCMController.text,
      heightFT: heightFTController.text,
      heightIN: heightINController.text,
      noOfTubes: noOfTubesController.text,
      grade: selectedGrade,
      unit: selectedUnit,
      concreteVolume: concretetube ?? 0.0,
      cementBags: cementBags ?? 0.0,
      sandCft: sandCft ?? 0.0,
      aggregateCft: aggregateCft ?? 0.0,
    );

    // Save to Hive/history provider
    ref
        .read(unifiedHistoryProvider.notifier)
        .addConcreteTubeHistory(historyItem);

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Concrete Tube history saved successfully!'),
    //     ),
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text('Error saving history: $e')));
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

  Widget _buildGradeDropdown(Color textColor) {
    return DropdownButton<String>(
      value: selectedGrade,
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
        selectedGrade = v!;
      }),
      selectedItemBuilder: (context) {
        return gradeOptions.map((v) => Center(child: Text(v))).toList();
      },
      items: gradeOptions
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
    final rows = <List<String>>[
      [
        'Concrete Tube',
        concretetube != null
            ? '${concretetube!.toStringAsFixed(3)} m³'
            : '0.000 m³',
      ],
      [
        'Cement',
        cementBags != null
            ? '${cementBags!.toStringAsFixed(2)} Bags'
            : '0.00 Bags',
      ],
      [
        'Sand',
        sandCft != null ? '${sandCft!.toStringAsFixed(2)} Ton' : '0.00 Ton',
      ],
      [
        'Aggregate',
        aggregateCft != null
            ? '${aggregateCft!.toStringAsFixed(2)} Ton'
            : '0.00 Ton',
      ],
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
          "Concrete Tube Calculator",
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
            Center(
              child: SvgPicture.asset(
                'assets/icons/cement_concrete_icon.svg',
                height: 85,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 10),

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

            const SizedBox(height: 8),

            // GRADE DROPDOWN
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
                      'Grade of Concrete',
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
                    child: _buildGradeDropdown(textColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            if (selectedUnit == 'Meter/CM') ...[
              _metricDual('Inner Diameter', innerDiamM, innerDiamCM, textColor),
              const SizedBox(height: 8),
              _metricDual('Outer Diameter', outerDiamM, outerDiamCM, textColor),
              const SizedBox(height: 8),
              _metricDual(
                'Height',
                heightMController,
                heightCMController,
                textColor,
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No. of Tubes',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _suffixInput(
                    controller: noOfTubesController,
                    unit: 'pcs',
                    type: TextInputType.number,
                  ),
                ],
              ),
            ] else ...[
              _imperialDual(
                'Inner Diameter',
                innerDiamFT,
                innerDiamIN,
                textColor,
              ),
              const SizedBox(height: 8),
              _imperialDual(
                'Outer Diameter',
                outerDiamFT,
                outerDiamIN,
                textColor,
              ),
              const SizedBox(height: 8),
              _imperialDual(
                'Height',
                heightFTController,
                heightINController,
                textColor,
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No. of Tubes',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _suffixInput(
                    controller: noOfTubesController,
                    unit: 'pcs',
                    type: TextInputType.number,
                  ),
                ],
              ),
            ],

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
}
