import 'package:construction_calculator/Domain/entities/draw_plain_model.dart';
import 'package:construction_calculator/features/Draw_plain/draw_plain_provider.dart';
import 'package:construction_calculator/features/Draw_plain/selcetion_line_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FreehandRectangleWidget extends StatefulWidget {
  final bool isSheetLocked;
  final DrawAction action;

  const FreehandRectangleWidget({
    required this.action,
    super.key,
    required this.isSheetLocked,
  });

  @override
  State<FreehandRectangleWidget> createState() =>
      _FreehandRectangleWidgetState();
}

class _FreehandRectangleWidgetState extends State<FreehandRectangleWidget> {
  final double initialSize = 60;
  final double handleSize = 10.0;
  final double handleTouchMargin = 20.0;
  final double dragFactor = 20.0;

  // ❗ initialized to zero to avoid LateInitializationError
  Offset topLeft = Offset.zero;
  Offset topRight = Offset.zero;
  Offset bottomLeft = Offset.zero;
  Offset bottomRight = Offset.zero;

  Offset? activeCorner;
  bool isSquareSelected = false;
  bool isLineSelected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        topLeft = Offset(
          (size.width - initialSize) / 2,
          (size.height - initialSize) / 2,
        );
        topRight = topLeft + Offset(initialSize, 0);
        bottomLeft = topLeft + Offset(0, initialSize);
        bottomRight = topLeft + Offset(initialSize, initialSize);
      });
    });
  }

  Offset? _getNearestHandle(Offset touch) {
    for (final handle in [topLeft, topRight, bottomLeft, bottomRight]) {
      final rect = Rect.fromCenter(
        center: handle,
        width: handleSize + handleTouchMargin * 2,
        height: handleSize + handleTouchMargin * 2,
      );
      if (rect.contains(touch)) return handle;
    }
    return null;
  }

  void _updateCorner(Offset delta) {
    if (activeCorner == null) return;
    if (!widget.isSheetLocked && !isSquareSelected) return;

    final amplifiedDelta = delta * dragFactor;
    setState(() {
      if (activeCorner == topLeft) topLeft += amplifiedDelta;
      if (activeCorner == topRight) topRight += amplifiedDelta;
      if (activeCorner == bottomLeft) bottomLeft += amplifiedDelta;
      if (activeCorner == bottomRight) bottomRight += amplifiedDelta;
    });
  }

  int? _hitTestLine(Offset point) {
    const threshold = 10.0;
    final lines = [
      [topLeft, topRight],
      [topRight, bottomRight],
      [bottomRight, bottomLeft],
      [bottomLeft, topLeft],
    ];
    for (int i = 0; i < lines.length; i++) {
      final p1 = lines[i][0];
      final p2 = lines[i][1];
      final distance = _distanceToSegment(point, p1, p2);
      if (distance <= threshold) return i;
    }
    return null;
  }

  double _distanceToSegment(Offset p, Offset v, Offset w) {
    final l2 = (v - w).distanceSquared;
    if (l2 == 0.0) return (p - v).distance;
    final t = ((p - v).dx * (w - v).dx + (p - v).dy * (w - v).dy) / l2;
    if (t < 0.0) return (p - v).distance;
    if (t > 1.0) return (p - w).distance;
    final projection = Offset(
      v.dx + t * (w.dx - v.dx),
      v.dy + t * (w.dy - v.dy),
    );
    return (p - projection).distance;
  }

  @override
  Widget build(BuildContext context) {
    bool canDragSquare = widget.isSheetLocked || isSquareSelected;

    return Consumer(
      builder: (context, ref, _) {
        final lineModel = ref.watch(lineSelectionProvider);

        if (!widget.isSheetLocked) {
          // sheet unlocked → just show rectangle
          return IgnorePointer(
            ignoring: true,
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _RectanglePainter(
                topLeft: topLeft,
                topRight: topRight,
                bottomLeft: bottomLeft,
                bottomRight: bottomRight,
                handleSize: handleSize,
                isSquareSelected: isSquareSelected,
                isLineSelected: isLineSelected,
                lineModel: lineModel,
                fillColor: widget.action.fillColor ?? Colors.transparent,
              ),
            ),
          );
        }

        // sheet locked → allow drag
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (event) {
            ref
                .read(drawNotifierProvider.notifier)
                .selectSquare(widget.action.id);

            final handle = _getNearestHandle(event.localPosition);
            if (handle != null) {
              activeCorner = handle;
              setState(() {
                isSquareSelected = true;
                isLineSelected = false;
              });
              return;
            }

            final lineIndex = _hitTestLine(event.localPosition);
            if (lineIndex != null) {
              ref.read(lineSelectionProvider.notifier).selectLine(lineIndex);
              setState(() {
                isLineSelected = true;
                isSquareSelected = false;
              });
              return;
            }

            setState(() {
              isLineSelected = false;
              isSquareSelected = false;
            });
          },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: canDragSquare
                ? (details) => _updateCorner(details.delta)
                : null,
            onPanEnd: (_) => activeCorner = null,
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: _RectanglePainter(
                topLeft: topLeft,
                topRight: topRight,
                bottomLeft: bottomLeft,
                bottomRight: bottomRight,
                handleSize: handleSize,
                isSquareSelected: isSquareSelected,
                isLineSelected: isLineSelected,
                lineModel: lineModel,
                fillColor: widget.action.fillColor ?? Colors.transparent,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RectanglePainter extends CustomPainter {
  final Offset topLeft, topRight, bottomLeft, bottomRight;
  final double handleSize;
  final bool isSquareSelected;
  final bool isLineSelected;
  final LineSelectionModel lineModel;
  final Color? fillColor; // nullable

  _RectanglePainter({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
    required this.handleSize,
    required this.isSquareSelected,
    required this.isLineSelected,
    required this.lineModel,
    this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ✅ Layer save
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    final rectPath = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topRight.dx, topRight.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(bottomLeft.dx, bottomLeft.dy)
      ..close();

    // fill color → agar null ho to transparent
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = fillColor ?? Colors.transparent;

    canvas.drawPath(rectPath, fillPaint);

    // ✅ Stroke lines
    final lines = [
      [topLeft, topRight],
      [topRight, bottomRight],
      [bottomRight, bottomLeft],
      [bottomLeft, topLeft],
    ];

    final linePaint = Paint()..style = PaintingStyle.stroke;

    for (int i = 0; i < 4; i++) {
      linePaint.color = (isLineSelected && lineModel.selectedLineIndex == i)
          ? Colors.orange
          : lineModel.lineColors[i];
      linePaint.strokeWidth = lineModel.lineStrokes[i];

      Offset start = lines[i][0];
      Offset end = lines[i][1];

      // handle offset
      if (i == 0) {
        start += Offset(handleSize / 2, 0);
        end -= Offset(handleSize / 2, 0);
      } else if (i == 1) {
        start += Offset(0, handleSize / 2);
        end -= Offset(0, handleSize / 2);
      } else if (i == 2) {
        start -= Offset(handleSize / 2, 0);
        end += Offset(handleSize / 2, 0);
      } else if (i == 3) {
        start -= Offset(0, handleSize / 2);
        end += Offset(0, handleSize / 2);
      }

      canvas.drawLine(start, end, linePaint);
    }

    // ✅ Handles → clear inside (BlendMode.clear)
    final clearPaint = Paint()..blendMode = BlendMode.clear;
    for (final handle in [topLeft, topRight, bottomLeft, bottomRight]) {
      final handleRect = Rect.fromCenter(
        center: handle,
        width: handleSize,
        height: handleSize,
      );
      canvas.drawRect(handleRect, clearPaint);
    }

    // handle border
    final handleBorderPaint = Paint()
      ..color = isSquareSelected ? Colors.orange : Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final handle in [topLeft, topRight, bottomLeft, bottomRight]) {
      canvas.drawRect(
        Rect.fromCenter(center: handle, width: handleSize, height: handleSize),
        handleBorderPaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RectanglePainter oldDelegate) => true;
}
