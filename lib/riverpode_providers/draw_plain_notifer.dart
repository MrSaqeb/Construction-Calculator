import 'package:construction_calculator/Domain/entities/draw_plain_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ===== Draw Notifier (shapes + strokes + undo/redo) =====
class DrawNotifier extends StateNotifier<DrawState> {
  // ==== Internal state stacks ====
  final List<DrawAction> _history = []; // Shapes ka history
  final List<DrawAction> _redoStack = []; // Shapes ka redo stack
  final List<List<Offset>> _strokeHistory = []; // Freehand strokes ka history
  final List<List<Offset>> _strokeRedoStack =
      []; // Freehand strokes ka redo stack
  String? squareSelectedId;

  DrawNotifier() : super(const DrawState());

  //***************bg square filller */

  void selectSquare(String id) {
    state = state.copyWith(squareSelectedId: id);
  }

  void updateFillColor(String squareId, Color color) {
    state = state.copyWith(
      actions: state.actions.map((a) {
        if (a.id == squareId && a.type == "square") {
          return a.copyWith(fillColor: color);
        }
        return a;
      }).toList(),
    );
  }

  //***************************** */
  /// ✅ Add a new dimension line to canvas
  // Notifier ke andar
  void addDimensionLine(
    String text,
    Offset position, {
    Size size = const Size(120, 30),
  }) {
    final action = DrawAction(
      id: UniqueKey().toString(),
      type: "dimension_line",
      text: text,
      color: Colors.black,
      position: position,
      size: size,
    );

    addAction(action); // history me bhi add karega
    print(
      "[Notifier] Dimension line added: ${action.id} at $position with text '$text'",
    );
  }

  //-------------------Selcet Obejct---------------------
  void selectActionAt(Offset position) {
    for (final action in state.actions) {
      if (action.hitTest(position)) {
        //     print("✅ Selected action: ${action.id}, type: ${action.type}");
        state = state.copyWith(selectedId: action.id);
        return;
      }
    }

    print("❌ No action found at $position");
    state = state.copyWith(selectedId: null);
  }

  void updateSelectedLineColor(int lineIndex, Color color) {
    final id = state.selectedId;
    if (id == null) return;

    final updated = state.actions.map((a) {
      if (a.id == id && a.type == 'square') {
        final newColors = [...a.lineColors];
        newColors[lineIndex] = color;
        return a.copyWith(lineColors: newColors);
      }
      return a;
    }).toList();

    state = state.copyWith(actions: updated);
  }

  void updateSelectedLineStroke(int lineIndex, double stroke) {
    final id = state.selectedId;
    if (id == null) return;

    final updated = state.actions.map((a) {
      if (a.id == id && a.type == 'square') {
        final newStrokes = [...a.lineStrokes];
        newStrokes[lineIndex] = stroke;
        return a.copyWith(lineStrokes: newStrokes);
      }
      return a;
    }).toList();

    state = state.copyWith(actions: updated);
  }

  // =================== ADD ===================

  void addFreehandRectangle(Size canvasSize) {
    const itemSize = Size(100, 100);
    final center = Offset(
      (canvasSize.width - itemSize.width) / 2,
      (canvasSize.height - itemSize.height) / 2,
    );

    final action = DrawAction(
      id: UniqueKey().toString(),
      type: "square",
      position: center,
      size: itemSize,
      corners: [
        center,
        center + Offset(itemSize.width, 0),
        center + Offset(itemSize.width, itemSize.height),
        center + Offset(0, itemSize.height),
      ],
      color: Colors.black, // ✅ new square default
      strokeWidth: 2.0, // ✅ new square default
    );

    addAction(action);
  }

  void addLabel(String text, Size canvasSize) {
    const itemSize = Size(100, 40);

    final sheetCenter = Offset(canvasSize.width / 2, canvasSize.height / 2);

    final centeredTopLeft = Offset(
      sheetCenter.dx - itemSize.width / 2,
      sheetCenter.dy - itemSize.height / 2,
    );

    final action = DrawAction(
      id: UniqueKey().toString(),
      type: "label",
      text: text,
      position: centeredTopLeft,
      size: itemSize,
    );

    addAction(action);
  }

  void addImage(String assetPath, String label, Size canvasSize) {
    const itemSize = Size(100, 100);

    final sheetCenter = Offset(canvasSize.width / 2, canvasSize.height / 2);

    final centeredTopLeft = Offset(
      sheetCenter.dx - itemSize.width / 2,
      sheetCenter.dy - itemSize.height / 2,
    );

    final action = DrawAction(
      id: UniqueKey().toString(),
      type: "object",
      assetPath: assetPath,
      text: label,
      position: centeredTopLeft,
      size: itemSize,
    );

    addAction(action);
  }
  // ================= SHAPES (Square, Circle, etc) =================

  /// ✅ Add new square in the center of canvas

  void addSquare(Size canvasSize) {
    const itemSize = Size(100, 100);
    final center = Offset(
      (canvasSize.width - itemSize.width) / 2,
      (canvasSize.height - itemSize.height) / 2,
    );

    final rect = Rect.fromLTWH(
      center.dx,
      center.dy,
      itemSize.width,
      itemSize.height,
    );

    final action = DrawAction(
      id: UniqueKey().toString(),
      type: "square",
      position: rect.center,
      size: itemSize,
      corners: [rect.topLeft, rect.topRight, rect.bottomRight, rect.bottomLeft],
      color: Colors.black, // line color
      strokeWidth: 2.0,
      fillColor: null, // ya Colors.transparent
    );

    addAction(action);
  }

  /// ✅ Update shape geometry (position + size + corners)
  void updateActionTransform(String id, Rect rect) {
    final corners = [
      rect.topLeft,
      rect.topRight,
      rect.bottomRight,
      rect.bottomLeft,
    ];

    final updated = state.actions.map((a) {
      if (a.id == id) {
        return a.copyWith(
          position: rect.center,
          size: Size(rect.width, rect.height),
          corners: corners,
        );
      }
      return a;
    }).toList();

    state = state.copyWith(actions: updated);
  }

  /// ✅ Select or deselect shape
  void selectAction(String? id) {
    state = state.copyWith(selectedId: id);
  }

  /// ✅ Add new shape in state
  void addAction(DrawAction action) {
    _history.add(action);
    _redoStack.clear();
    state = state.copyWith(actions: [..._history]);
  }

  /// ✅ Update only position of shape
  void updateActionPosition(String id, Offset newPos) {
    final updated = state.actions.map((a) {
      if (a.id == id) return a.copyWith(position: newPos);
      return a;
    }).toList();
    state = state.copyWith(actions: updated);
  }

  /// ✅ Update only size of shape
  void updateActionSize(String id, Size newSize) {
    final updated = state.actions.map((a) {
      if (a.id == id) return a.copyWith(size: newSize);
      return a;
    }).toList();
    state = state.copyWith(actions: updated);
  }

  /// ✅ Remove shape
  void removeAction(String id) {
    _history.removeWhere((a) => a.id == id);
    state = state.copyWith(actions: [..._history]);
  }

  // ================== FREEHAND STROKES ==================

  /// ✅ Add freehand stroke (list of points)
  void addStroke(List<Offset> stroke) {
    _strokeHistory.add(stroke);
    _strokeRedoStack.clear();
    final updated = [...state.drawStrokes, stroke];
    state = state.copyWith(drawStrokes: updated);
  }

  // ================== UNDO / REDO (Common) ==================

  /// ✅ Undo last stroke OR shape
  void undo() {
    if (state.drawStrokes.isNotEmpty) {
      // undo stroke
      final updated = [...state.drawStrokes];
      final last = updated.removeLast();
      _strokeRedoStack.add(last);
      state = state.copyWith(drawStrokes: updated);
    } else if (_history.isNotEmpty) {
      // undo shape
      final lastAction = _history.removeLast();
      _redoStack.add(lastAction);
      state = state.copyWith(actions: List<DrawAction>.from(_history));
    }
  }

  /// ✅ Redo last undone stroke OR shape
  void redo() {
    if (_strokeRedoStack.isNotEmpty) {
      // redo stroke
      final lastStroke = _strokeRedoStack.removeLast();
      final updated = [...state.drawStrokes, lastStroke];
      state = state.copyWith(drawStrokes: updated);
    } else if (_redoStack.isNotEmpty) {
      // redo shape
      final lastAction = _redoStack.removeLast();
      _history.add(lastAction);
      state = state.copyWith(actions: List<DrawAction>.from(_history));
    }
  }
}

/// ===== Provider for DrawNotifier =====
final drawNotifierProvider = StateNotifierProvider<DrawNotifier, DrawState>(
  (ref) => DrawNotifier(),
);

/// ===== Category Items (toolbar assets) =====
class CategoryItemsNotifier extends StateNotifier<List<Map<String, String>>> {
  CategoryItemsNotifier() : super([]);

  /// ✅ Load items based on category
  void loadItems(String category) {
    switch (category) {
      case "Door/Windows":
        state = [
          {"label": "Door 1", "icon": "assets/icons/door_1.png"},
          {"label": "Door 2", "icon": "assets/icons/door_2.png"},
          {"label": "Door 3", "icon": "assets/icons/door_3.png"},
        ];
        break;
      case "Living Room":
        state = [
          {"label": "TV", "icon": "assets/icons/tv.png"},
          {"label": "Table", "icon": "assets/icons/table.png"},
          {"label": "Cupboard", "icon": "assets/icons/cupboard.png"},
        ];
        break;
      case "Bathroom Assets":
        state = [
          {"label": "Sink 1", "icon": "assets/icons/sink_1.png"},
          {"label": "Toilet", "icon": "assets/icons/b1.png"},
          {"label": "Bath", "icon": "assets/icons/b2.png"},
        ];
        break;
      case "Kitchen Assets":
        state = [
          {"label": "Kitchen Set", "icon": "assets/icons/k3.png"},
          {"label": "Gas Range", "icon": "assets/icons/k1.png"},
          {"label": "Kitchen Set 2", "icon": "assets/icons/k2.png"},
        ];
        break;
      case "Car Collection":
        state = [
          {"label": "Car 1", "icon": "assets/icons/car_1.png"},
          {"label": "Car 2", "icon": "assets/icons/car_2.png"},
          {"label": "Car 3", "icon": "assets/icons/car_3.png"},
        ];
        break;
      default:
        state = [];
    }
  }
}

/// ✅ Provider for drawing mode ("draw", "shape", etc.)
final drawModeProvider = StateProvider<String>((ref) => "draw");

/// ✅ Provider for category items
final categoryItemsProvider =
    StateNotifierProvider<CategoryItemsNotifier, List<Map<String, String>>>(
      (ref) => CategoryItemsNotifier(),
    );
