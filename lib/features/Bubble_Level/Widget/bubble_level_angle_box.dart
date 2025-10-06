import 'package:flutter/material.dart';

class AngleBox extends StatelessWidget {
  final double value;
  final bool showLeftArrow;
  final bool showUpArrow;
  final String displayType; // 👈 Angle ya Inclination
  final bool showNumeric; // 👈 Toggle se control

  const AngleBox(
    this.value, {
    super.key,
    required this.displayType,
    required this.showNumeric,
    this.showLeftArrow = false,
    this.showUpArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!showNumeric) return const SizedBox(); // 👈 Agar off ho to blank

    // Value formatting
    String formattedValue;
    String unit;

    if (displayType == "Inclination") {
      // percentage
      formattedValue = (value.abs()).toStringAsFixed(1).padLeft(4, '0');
      unit = "%";
    } else {
      // angle default
      formattedValue = value.abs().toStringAsFixed(1).padLeft(4, '0');
      unit = "°";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLeftArrow)
            const Icon(Icons.arrow_left, size: 28, color: Colors.black),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: formattedValue,
                  style: const TextStyle(
                    fontFamily: 'DSEG14',
                    fontSize: 36,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (showUpArrow)
            const Icon(Icons.arrow_drop_up, size: 30, color: Colors.black),
        ],
      ),
    );
  }
}
