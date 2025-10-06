import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:construction_calculator/features/Draw_plain/draw_plain_provider.dart';

class FreehandDrawLayer extends ConsumerStatefulWidget {
  final bool isSheetLocked;
  const FreehandDrawLayer({super.key, required this.isSheetLocked});

  @override
  ConsumerState<FreehandDrawLayer> createState() => _FreehandDrawLayerState();
}

class _FreehandDrawLayerState extends ConsumerState<FreehandDrawLayer> {
  List<Offset> currentStroke = [];

  @override
  Widget build(BuildContext context) {
    final drawMode = ref.watch(drawModeProvider);
    final strokes = ref.watch(
      drawNotifierProvider.select((s) => s.drawStrokes),
    );

    // By default draw color & stroke width
    final drawColor = ref.watch(drawModeStrokeColorProvider);
    final drawWidth = ref.watch(drawModeStrokeWidthProvider);

    Widget painter = CustomPaint(
      size: Size.infinite,
      painter: _FreehandPainter(
        strokes: [...strokes, if (currentStroke.isNotEmpty) currentStroke],
        color: drawColor,
        strokeWidth: drawWidth,
      ),
    );

    final freehandModes = ["draw", "drawline"];

    if (freehandModes.contains(drawMode)) {
      painter = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: (details) {
          currentStroke = [details.localPosition];
          setState(() {});
        },
        onPanUpdate: (details) {
          currentStroke.add(details.localPosition);
          setState(() {});
        },
        onPanEnd: (_) {
          if (currentStroke.isNotEmpty) {
            ref.read(drawNotifierProvider.notifier).addStroke(currentStroke);
          }
          currentStroke = [];
        },
        child: painter,
      );
    }

    return IgnorePointer(
      ignoring: !widget.isSheetLocked && drawMode != "draw",
      child: painter,
    );
  }
}

class _FreehandPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;
  final double strokeWidth;

  _FreehandPainter({
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
  bool shouldRepaint(covariant _FreehandPainter oldDelegate) => true;
}
