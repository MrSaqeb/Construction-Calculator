// draw_plain_model.dart (updated with freehand path)

import 'package:flutter/material.dart';

class DrawAction {
  final String id;
  final String type; // 'object', 'label', 'draw'
  final Offset position;
  final Offset? resizeHandle;
  final String? text;
  final String? assetPath;
  final Size size;
  final List<Offset> corners;

  // 👇 freehand drawing points
  final List<Offset> pathPoints;

  // ✅ New fields
  final Color color;
  final double strokeWidth;
  final List<Color> lineColors;
  final List<double> lineStrokes;
  final Color? fillColor; // nullable

  DrawAction({
    this.color = Colors.black, // default
    this.strokeWidth = 2.0, // default
    this.lineColors = const [
      Colors.black,
      Colors.black,
      Colors.black,
      Colors.black,
    ],
    this.lineStrokes = const [3.0, 3.0, 3.0, 3.0],
    required this.id,
    required this.type,
    required this.position,
    this.text,
    this.resizeHandle,
    this.assetPath,
    this.size = const Size(50, 50),
    this.corners = const [],
    this.pathPoints = const [],
    this.fillColor, // default transparent
  });

  DrawAction copyWith({
    String? id,
    String? type,
    Offset? position,
    String? text,
    String? assetPath,
    Size? size,
    List<Offset>? corners,
    List<Offset>? pathPoints, // 👈 new field
    Color? color,
    double? strokeWidth,

    List<Color>? lineColors,
    List<double>? lineStrokes,
    Color? fillColor,
  }) {
    return DrawAction(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      text: text ?? this.text,
      assetPath: assetPath ?? this.assetPath,
      size: size ?? this.size,
      corners: corners ?? this.corners,
      pathPoints: pathPoints ?? this.pathPoints, // 👈 copy

      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      lineColors: lineColors ?? this.lineColors,
      lineStrokes: lineStrokes ?? this.lineStrokes,
      fillColor: fillColor ?? this.fillColor,
    );
  }

  /// ✅ HitTest for selection
  bool hitTest(Offset point) {
    if (type == "square") {
      final rect = Rect.fromLTWH(
        position.dx,
        position.dy,
        size.width,
        size.height,
      );
      return rect.contains(point);
    }
    return false; // baaki types ke liye abhi false
  }
}

class DrawState {
  final List<DrawAction> actions;
  final String? selectedId;
  final Offset? resizeHandle;
  final Offset? dragStartOffset;
  final Size canvasSize; // ✅ final

  final List<List<Offset>> drawStrokes;
  final String? squareSelectedId; // square selection ke liye

  const DrawState({
    this.drawStrokes = const [],
    this.actions = const [],
    this.selectedId,
    this.resizeHandle,
    this.dragStartOffset,
    this.canvasSize = const Size(1000, 1500),
    this.squareSelectedId,
  });

  DrawState copyWith({
    List<DrawAction>? actions,
    String? selectedId,
    Offset? resizeHandle,
    Offset? dragStartOffset,
    Size? canvasSize,
    List<List<Offset>>? drawStrokes,
    String? squareSelectedId,
  }) {
    return DrawState(
      actions: actions ?? this.actions,
      selectedId: selectedId,
      resizeHandle: resizeHandle,
      drawStrokes: drawStrokes ?? this.drawStrokes,
      dragStartOffset: dragStartOffset,
      canvasSize: canvasSize ?? this.canvasSize,

      squareSelectedId: squareSelectedId ?? this.squareSelectedId,
    );
  }
}
