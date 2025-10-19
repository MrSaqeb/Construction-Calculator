// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ColorAndStrokePicker extends StatelessWidget {
  final List<Color> availableColors;
  final Color selectedColor;
  final double strokeWidth;
  final double minStroke;
  final double maxStroke;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<double> onStrokeWidthChanged;
  final VoidCallback onClose; // ✅ new callback

  const ColorAndStrokePicker({
    super.key,
    required this.availableColors,
    required this.selectedColor,
    required this.strokeWidth,
    required this.onColorChanged,
    required this.onStrokeWidthChanged,
    required this.onClose, // ✅ required
    this.minStroke = 1,
    this.maxStroke = 15,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Top bar with title + close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Color",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down, size: 28),
                  color: Colors.orange,
                  onPressed: onClose,
                ),
              ],
            ),
          ),

          // Scrollable Colors
          SizedBox(
            height: 55,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: availableColors.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final c = availableColors[index];
                final isSelected = selectedColor == c;

                return GestureDetector(
                  onTap: () => onColorChanged(c),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.blueAccent : Colors.grey,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 3),
          // Stroke Width
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "Line Size",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),

          // Line Size + Left Icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.line_weight, color: Colors.orange), // Icon left side
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.orange,
                      inactiveTrackColor: Colors.white,
                      thumbColor: Colors.orange,
                      overlayColor: Colors.orange.withOpacity(0.2),
                      trackHeight: 4,
                      valueIndicatorColor: Colors.orange,
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Slider(
                      value: strokeWidth,
                      min: minStroke,
                      max: maxStroke,
                      divisions: (maxStroke - minStroke).toInt(),
                      label: strokeWidth.toStringAsFixed(0),
                      onChanged: onStrokeWidthChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
