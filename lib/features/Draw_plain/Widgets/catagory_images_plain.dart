// ignore_for_file: constant_identifier_names

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:construction_calculator/riverpode_providers/draw_plain_notifer.dart';

enum CanvasItemType { image, label, dimension_line }

class CanvasItemWidget extends StatefulWidget {
  final String id;
  final CanvasItemType type;
  final String? assetPath;
  final String? text;
  final Offset initialPosition;
  final Size initialSize;
  final void Function(String id)? onSelected;
  final void Function(Offset newPosition)? onMove;
  final void Function(Size newSize)? onResize;
  final void Function(String id)? onDelete;
  final DrawNotifier notifier;

  const CanvasItemWidget({
    super.key,
    required this.id,
    required this.type,
    this.assetPath,
    this.text,
    required this.initialPosition,
    required this.initialSize,
    this.onSelected,
    this.onMove,
    this.onResize,
    this.onDelete,
    required this.notifier,
  });

  @override
  State<CanvasItemWidget> createState() => _CanvasItemWidgetState();
}

class _CanvasItemWidgetState extends State<CanvasItemWidget> {
  late Offset position;
  late Size size;
  double rotationAngle = 0.0;
  bool isSelected = false;
  bool isLocked = false;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
    size = widget.initialSize;
  }

  void select() {
    setState(() => isSelected = true);
    widget.onSelected?.call(widget.id);
  }

  void deselect() {
    setState(() => isSelected = false);
  }

  void toggleLock() {
    setState(() => isLocked = !isLocked);
  }

  void _rotateDimension() {
    setState(() {
      rotationAngle = (rotationAngle + 20) % 360; // 20 degrees per tap
    });
  }

  void _handleResize(DragUpdateDetails details) {
    if (!isLocked) {
      setState(() {
        size = Size(
          (size.width + details.delta.dx).clamp(30.0, 300.0),
          (size.height + details.delta.dy).clamp(30.0, 300.0),
        );
      });
      widget.onResize?.call(size);
    }
  }

  void _handleDelete() {
    widget.onDelete?.call(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget content;
    if (widget.type == CanvasItemType.image) {
      content = Container(
        width: size.width,
        height: size.height + 14, // height ko thoda barhaya
        decoration: BoxDecoration(
          image: widget.assetPath != null
              ? DecorationImage(
                  image: AssetImage(widget.assetPath!),
                  fit: BoxFit.cover,
                )
              : null,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 1,
          ),
        ),
      );
    } else if (widget.type == CanvasItemType.label) {
      content = Container(
        width: size.width,
        height: size.height + 14, // label ke liye height adjust ki
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 4), // optional thodi padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((size.height + 10) / 2),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 2,
          ),
        ),
        child: Text(
          widget.text ?? "",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: (size.height + 10) * 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      // dimension line
      content = Transform.rotate(
        angle: rotationAngle * pi / 180,
        child: Container(
          width: size.width,
          height: size.height + 14, // line ke liye height adjust
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey,
              width: 2,
            ),
          ),
          child: CustomPaint(
            size: Size(size.width, size.height + 14),
            painter: _DimensionLinePainter(widget.text ?? ""),
          ),
        ),
      );
    }
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: select,
        onPanUpdate: (details) {
          if (!isLocked) setState(() => position += details.delta);
          widget.onMove?.call(position);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            content,
            if (isSelected) ...[
              // Selection border bahar icons, fast response
              if (isSelected) ...[
                // Delete
                Positioned(
                  top: -28,
                  left: -28,
                  child: RepaintBoundary(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _handleDelete,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: const Icon(
                          Icons.close,
                          color: Colors.orange,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),

                // Lock
                Positioned(
                  bottom: -28,
                  left: -28,
                  child: RepaintBoundary(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: toggleLock,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Icon(
                          isLocked ? Icons.lock : Icons.lock_open,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                // Resize
                Positioned(
                  bottom: -28,
                  right: -28,
                  child: RepaintBoundary(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanUpdate: _handleResize,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Transform.rotate(
                          angle: -0.785398,
                          child: const Icon(
                            Icons.arrow_downward,
                            color: Colors.orange,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Rotate (dimension line only)
                if (widget.type == CanvasItemType.dimension_line)
                  Positioned(
                    top: -28,
                    right: -28,
                    child: RepaintBoundary(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _rotateDimension,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: const Icon(
                            Icons.rotate_right,
                            color: Colors.orange,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _DimensionLinePainter extends CustomPainter {
  final String text;
  _DimensionLinePainter(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final start = Offset(0, size.height / 2);
    final end = Offset(size.width, size.height / 2);
    canvas.drawLine(start, end, paint);

    void drawArrow(Offset pos, bool isStart) {
      const arrowSize = 6.0;
      final path = Path();
      if (isStart) {
        path.moveTo(pos.dx, pos.dy);
        path.lineTo(pos.dx + arrowSize, pos.dy - arrowSize);
        path.lineTo(pos.dx + arrowSize, pos.dy + arrowSize);
      } else {
        path.moveTo(pos.dx, pos.dy);
        path.lineTo(pos.dx - arrowSize, pos.dy - arrowSize);
        path.lineTo(pos.dx - arrowSize, pos.dy + arrowSize);
      }
      path.close();
      canvas.drawPath(path, paint);
    }

    drawArrow(start, true);
    drawArrow(end, false);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      size.width / 2 - textPainter.width / 2,
      size.height / 2 + 5,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
