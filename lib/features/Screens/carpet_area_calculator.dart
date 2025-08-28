// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CarpetAreaCalculator extends ConsumerStatefulWidget {
  const CarpetAreaCalculator({super.key});

  @override
  ConsumerState<CarpetAreaCalculator> createState() =>
      _CarpetAreaCalculatorState();
}

// Room Entry Model
class RoomEntry {
  String roomType;
  double length;
  double breadth;

  RoomEntry({
    required this.roomType,
    required this.length,
    required this.breadth,
  });
}

class _CarpetAreaCalculatorState extends ConsumerState<CarpetAreaCalculator> {
  final Color orangeColor = const Color(0xFFFF9C00);

  // Room Dimensions
  final TextEditingController roomLenFT = TextEditingController();
  final TextEditingController roomLenIN = TextEditingController();
  final TextEditingController roomBreadtFT = TextEditingController();
  final TextEditingController roomBreadtIN = TextEditingController();

  double? _carpertArea;
  double? _buildUpArea;
  double? _superBuildUpArea;

  // Store all room entries
  List<RoomEntry> roomEntries = [];

  // ---- Helpers ----
  double _ftInToFeet(String ft, String inch) {
    final f = double.tryParse(ft) ?? 0;
    final i = double.tryParse(inch) ?? 0;
    return f + (i / 12.0);
  }

  void _calculate() {
    // Convert inch inputs into numbers
    final lenInch = int.tryParse(roomLenIN.text) ?? 0;
    final breInch = int.tryParse(roomBreadtIN.text) ?? 0;

    // Check inch is valid (0–11 only)
    if (lenInch < 0 || lenInch > 11 || breInch < 0 || breInch > 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Inch must be between 0 and 11 only"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Convert everything to feet
    double length = _ftInToFeet(roomLenFT.text, roomLenIN.text);
    double breadth = _ftInToFeet(roomBreadtFT.text, roomBreadtIN.text);

    // Carpet / Built-Up / Super Built-Up calculation
    _carpertArea = length * breadth;
    _buildUpArea = _carpertArea! * 1.2;
    _superBuildUpArea = _buildUpArea! * 1.3;

    // Add to room entries list
    roomEntries.add(
      RoomEntry(roomType: selectedRoom, length: length, breadth: breadth),
    );

    setState(() {});
  }

  // ROOM/PASSAGE OPTIONS
  final List<String> roomOptions = const [
    "Bedroom",
    "Living",
    "Balcony",
    "Dining",
    "Kitchen",
    "Passage",
    "Duct",
    "Garden",
    "Bathroom",
    "Lobby",
    "Lift",
    "Gym",
    "Swimming Pool",
    "Terrace",
    "Staircase",
  ];

  // Default selected room
  String selectedRoom = "Bedroom";

  Widget _buildRoomDropdown(Color textColor) {
    return DropdownButton<String>(
      value: selectedRoom,
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
        selectedRoom = v!;
      }),
      selectedItemBuilder: (context) {
        return roomOptions.map((v) => Center(child: Text(v))).toList();
      },
      items: roomOptions
          .map((v) => DropdownMenuItem(value: v, child: Text(v)))
          .toList(),
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
          "Carpet Area Calculator",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/icons/carpet_area_icon.svg',
                height: 90,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          'Room/Passage',
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
                        child: _buildRoomDropdown(textColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _imperialDual(
                  "Length of Room",
                  roomLenFT,
                  roomLenIN,
                  textColor,
                ),
                const SizedBox(height: 8),
                _imperialDual(
                  "Breadth of Room",
                  roomBreadtFT,
                  roomBreadtIN,
                  textColor,
                ),
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
                _inputTable(),
                const SizedBox(height: 15),
                _resultTable(textColor),
              ],
            ),
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

  Widget _inputTable() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Area Of Room /Passage',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),

          // Har entry ko card bana ke show karo
          ...roomEntries.map((entry) {
            double area = entry.length * entry.breadth;

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text (Room type + area)
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14, color: textColor),
                        children: [
                          TextSpan(
                            text: '${entry.roomType}: ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                '${entry.length.toStringAsFixed(2)} × ${entry.breadth.toStringAsFixed(2)} = ${area.toStringAsFixed(2)} ft²',
                          ),
                        ],
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),

                  // Delete icon
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        roomEntries.remove(entry);
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _resultTable(Color textColor) {
    if (_carpertArea == null) return const SizedBox.shrink();
    final rows = <List<String>>[
      ['Carpet Area', _carpertArea?.toStringAsFixed(3) ?? '0'],
      ['Built-Up Area', _buildUpArea?.toStringAsFixed(3) ?? '0'],
      ['Super Built-Up Area', _superBuildUpArea?.toStringAsFixed(3) ?? '0'],
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
                      child: Text(r[1], style: TextStyle(color: textColor)),
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
