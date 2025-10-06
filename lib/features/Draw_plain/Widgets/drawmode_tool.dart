// === Custom Painter ===
import 'package:construction_calculator/features/Draw_plain/draw_plain_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// drawmode tab
class FreehandPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;
  final double strokeWidth;

  FreehandPainter({
    required this.strokes,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant FreehandPainter oldDelegate) => true;
}

class FreehandColorStrokePicker extends StatelessWidget {
  final List<Color> availableColors;
  final Color selectedColor;
  final double strokeWidth;
  final double minStroke;
  final double maxStroke;
  final ValueChanged<Color> onColorChanged;
  final ValueChanged<double> onStrokeWidthChanged;
  final VoidCallback onClose;

  const FreehandColorStrokePicker({
    Key? key,
    required this.availableColors,
    required this.selectedColor,
    required this.strokeWidth,
    required this.onColorChanged,
    required this.onStrokeWidthChanged,
    required this.onClose,
    this.minStroke = 1,
    this.maxStroke = 15,
  }) : super(key: key);

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
          // Top Row: "Select Color" + Close
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Color to apply ",
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

          // Color Picker
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

          const SizedBox(height: 6),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GestureDetector(
                onTap: () {
                  // TODO: Freehand style action
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Background transparent
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange, // Orange border
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon representing freehand line
                      Icon(
                        Icons.show_chart, // Freehand line style icon
                        color: Colors.orange,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Freehand Style",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 2),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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

          const SizedBox(height: 4),

          // Freehand Style Button (icon + label)
        ],
      ),
    );
  }
}

// color tab

class FreehandDrawScreen extends ConsumerStatefulWidget {
  const FreehandDrawScreen({super.key});

  @override
  ConsumerState<FreehandDrawScreen> createState() => _FreehandDrawScreenState();
}

class _FreehandDrawScreenState extends ConsumerState<FreehandDrawScreen> {
  List<List<Offset>> strokes = [];
  List<Color> strokeColors = [];
  List<double> strokeWidths = [];
  List<Offset> currentStroke = [];

  @override
  Widget build(BuildContext context) {
    final drawColor = ref.watch(drawModeStrokeColorProvider);
    final drawWidth = ref.watch(drawModeStrokeWidthProvider);
    final showColorPicker = ref.watch(isColorLayerVisibleProvider);

    return Stack(
      children: [
        // Canvas
        GestureDetector(
          onPanStart: (details) {
            setState(() {
              currentStroke = [details.localPosition];
              strokes.add(currentStroke);
              strokeColors.add(drawColor); // Draw tab color
              strokeWidths.add(drawWidth); // Draw tab width
              ref.read(currentFreehandStrokeProvider.notifier).state =
                  currentStroke;
            });
          },
          onPanUpdate: (details) {
            setState(() {
              currentStroke.add(details.localPosition);
              ref.read(currentFreehandStrokeProvider.notifier).state =
                  currentStroke;
            });
          },
          onPanEnd: (_) {
            currentStroke = [];
            ref.read(currentFreehandStrokeProvider.notifier).state = [];
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: _MultiColorPainter(strokes, strokeColors, strokeWidths),
          ),
        ),

        // Color Picker Layer
        if (showColorPicker)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FreehandColorPicker(
              availableColors: const [
                Colors.black,
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.yellow,
                Colors.purple,
              ],
              selectedColor: drawColor,
              onColorChanged: (color) {
                // Update color for both color tab and draw tab
                ref.read(freehandStrokeColorProvider.notifier).state = color;
                ref.read(drawModeStrokeColorProvider.notifier).state = color;
              },
              onClose: () {
                ref.read(isColorLayerVisibleProvider.notifier).state = false;
              },
            ),
          ),

        // Button to open color picker
        Positioned(
          bottom: showColorPicker ? 80 : 20,
          right: 20,
          child: FloatingActionButton(
            child: const Icon(Icons.color_lens),
            onPressed: () {
              ref.read(isColorLayerVisibleProvider.notifier).state = true;
            },
          ),
        ),
      ],
    );
  }
}

class _MultiColorPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Color> colors;
  final List<double> widths;

  _MultiColorPainter(this.strokes, this.colors, this.widths);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < strokes.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = widths[i]
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final stroke = strokes[i];
      for (int j = 0; j < stroke.length - 1; j++) {
        canvas.drawLine(stroke[j], stroke[j + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MultiColorPainter oldDelegate) => true;
}

class FreehandColorPicker extends StatelessWidget {
  final List<Color> availableColors;
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback onClose;

  const FreehandColorPicker({
    Key? key,
    required this.availableColors,
    required this.selectedColor,
    required this.onColorChanged,
    required this.onClose,
  }) : super(key: key);

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
          // Top Row: "Select Color" + Close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Color to apply",
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

          // Color Picker Row
          SizedBox(
            height: 55,
            width: MediaQuery.of(context).size.width - 40,
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
        ],
      ),
    );
  }
}
