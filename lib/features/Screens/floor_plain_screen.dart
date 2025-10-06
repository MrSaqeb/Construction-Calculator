// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FloorPlainScreen extends StatefulWidget {
  const FloorPlainScreen({super.key});

  @override
  State<FloorPlainScreen> createState() => _FloorPlainScreenState();
}

class _FloorPlainScreenState extends State<FloorPlainScreen> {
  final Color orangeColor = const Color(0xFFFF9C00);

  /// 🔹 Marla Options
  final List<String> marlaOptions = [
    "04 Marla",
    "05 Marla",
    "06 Marla",
    "07 Marla",
    "08 Marla",
    "10 Marla",
    "15 Marla",
    "20 Marla",
    "2 Kanal",
  ];

  String selectedMarla = "04 Marla";

  /// 🔹 Map of designs by marla
  final Map<String, List<String>> marlaDesigns = {
    "04 Marla": ["assets/icons/d1.png", "assets/icons/d1.png"],
    // "05 Marla": ["assets/icons/design2.svg", "assets/icons/d2.png"],
  };

  Widget _buildMarlaDropdown(Color textColor) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.orange, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/icons/marla_icon.svg',
            height: 28,
            color: orangeColor,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: DropdownButton<String>(
              value: selectedMarla,
              isExpanded: true,
              underline: const SizedBox(),
              icon: Icon(Icons.arrow_drop_down, size: 23, color: orangeColor),
              style: TextStyle(
                color: textColor, // ✅ text color theme ke hisab se
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (val) {
                setState(() {
                  selectedMarla = val!;
                });
              },
              items: marlaOptions
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: TextStyle(
                          color: textColor, // ✅ apply theme color
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    /// 🔹 Jo marla select hai uske designs
    final currentDesigns = marlaDesigns[selectedMarla] ?? [];

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
          "Floor Plan",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white, // ✅ AppBar me hamesha white
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildMarlaDropdown(textColor),
            const SizedBox(height: 20),

            /// 🔹 Designs Grid
            Expanded(
              child: currentDesigns.isEmpty
                  ? Center(
                      child: Text(
                        "No designs available for $selectedMarla",
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                    )
                  : GridView.builder(
                      itemCount: currentDesigns.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemBuilder: (context, index) {
                        final path = currentDesigns[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DesignDetailScreen(designPath: path),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            color: isDark
                                ? Colors.grey[850]
                                : Colors.white, // ✅ background theme
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isDark
                                    ? Colors.white70
                                    : Colors.black, // ✅ border theme
                                width: 0.3,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: path.endsWith(".svg")
                                        ? SvgPicture.asset(
                                            path,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          )
                                        : Image.asset(
                                            path,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 6,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.grey[900]
                                        : Colors.grey[200],
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Design ${index + 1}",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textColor, // ✅ theme color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Detail Screen
class DesignDetailScreen extends StatelessWidget {
  final String designPath;
  const DesignDetailScreen({super.key, required this.designPath});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Design Preview",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white, // ✅ AppBar title always white
          ),
        ),
        backgroundColor: const Color(0xFFFF9C00),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: designPath.endsWith(".svg")
                  ? SvgPicture.asset(
                      designPath,
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.8,
                    )
                  : Image.asset(
                      designPath,
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.8,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              designPath.split('/').last,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor, // ✅ theme color
              ),
            ),
          ),
        ],
      ),
    );
  }
}
