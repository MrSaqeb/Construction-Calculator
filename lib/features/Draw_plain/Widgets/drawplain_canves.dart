import 'package:construction_calculator/features/Draw_plain/Widgets/catagory_images_plain.dart';
import 'package:construction_calculator/features/Draw_plain/Widgets/drawfreehandrectangl.dart';
import 'package:construction_calculator/features/Draw_plain/Widgets/drawmode_tool.dart';

import 'package:construction_calculator/features/Draw_plain/Widgets/drawtool_frehanddraw.dart';
import 'package:construction_calculator/features/Draw_plain/Widgets/floor_background_color.dart';
import 'package:construction_calculator/features/Draw_plain/Widgets/selcet_object_widget.dart';
import 'package:construction_calculator/features/Draw_plain/draw_plain_provider.dart';
import 'package:flutter/material.dart';
import 'package:construction_calculator/Domain/entities/draw_plain_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawPlanCanvas extends StatefulWidget {
  final Size canvasSize;
  const DrawPlanCanvas({super.key, required this.canvasSize});

  @override
  State<DrawPlanCanvas> createState() => _DrawPlanCanvasState();
}

class _DrawPlanCanvasState extends State<DrawPlanCanvas> {
  final TransformationController _transformationController =
      TransformationController();

  late DrawState _drawState;

  bool _initialized = false;
  bool isSheetLocked = true; // default locked

  // Canvas par chipkaye gaye items
  List<Map<String, dynamic>> selectedCanvasItems = [];

  @override
  void initState() {
    super.initState();
    _drawState = DrawState(canvasSize: widget.canvasSize);
  }

  // ---------------- Shape Actions ----------------

  void closeLayer(WidgetRef ref) {
    ref.read(drawModeProvider.notifier).state = "none";
  }

  void addLabel(String text) {
    const itemSize = Size(100, 40);
    final center = _getCenteredPosition(widget.canvasSize, itemSize);

    final action = DrawAction(
      id: UniqueKey().toString(),
      type: "label",
      text: text,
      position: center,
      size: itemSize,
    );

    setState(() {
      _drawState = _drawState.copyWith(
        actions: [..._drawState.actions, action],
      );
    });
  }

  // center main dhkne kay lay
  Offset _getCenteredPosition(Size canvasSize, Size itemSize) {
    return Offset(
      (canvasSize.width - itemSize.width) / 2,
      (canvasSize.height - itemSize.height) / 2,
    );
  }

  Widget _gridLayer(Size size) =>
      CustomPaint(painter: GridPainter(isDark: false), size: size);

  //  scrol indacator
  Widget _buildIndicators(Size viewportSize, Size canvasSize) {
    final matrix = _transformationController.value;
    final scale = matrix[0];
    final dx = matrix[12];
    final dy = matrix[13];

    final visibleWidth = viewportSize.width / scale;
    final visibleHeight = viewportSize.height / scale;

    final currentX = -dx / scale;
    final currentY = -dy / scale;

    final horizontalRatio = currentX / canvasSize.width;
    final verticalRatio = currentY / canvasSize.height;

    final horizontalSizeRatio = visibleWidth / canvasSize.width;
    final verticalSizeRatio = visibleHeight / canvasSize.height;

    return Stack(
      children: [
        Positioned(
          left: horizontalRatio * viewportSize.width,
          bottom: 4,
          width: viewportSize.width * horizontalSizeRatio,
          height: 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.6),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        Positioned(
          top: verticalRatio * viewportSize.height,
          right: 4,
          width: 4,
          height: viewportSize.height * verticalSizeRatio,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.6),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ],
    );
  }

  // images label sqaure
  Widget buildCanvasImagesLayer(WidgetRef ref) {
    final actions = ref.watch(drawNotifierProvider).actions;

    return Stack(
      children: actions.map((action) {
        if (action.type == "square") {
          // Freehand rectangle / square
          return Positioned(
            left: 0,
            top: 0,
            child: FreehandRectangleWidget(
              action: action,
              isSheetLocked: isSheetLocked,
              key: ValueKey(action.id),
            ),
          );
        } else {
          // Image, label, or dimension line
          CanvasItemType itemType;
          if (action.type == "label") {
            itemType = CanvasItemType.label;
          } else if (action.type == "object") {
            itemType = CanvasItemType.image;
          } else {
            itemType = CanvasItemType.dimension_line;
          }

          return CanvasItemWidget(
            key: ValueKey(action.id),
            id: action.id,
            type: itemType,
            assetPath: action.type == "object" ? action.assetPath : null,
            text: action.text,
            initialPosition: action.position,
            initialSize: action.size,
            notifier: ref.read(drawNotifierProvider.notifier),
            onMove: (newPos) => ref
                .read(drawNotifierProvider.notifier)
                .updateActionPosition(action.id, newPos),
            onResize: (newSize) => ref
                .read(drawNotifierProvider.notifier)
                .updateActionSize(action.id, newSize),
            onDelete: (id) =>
                ref.read(drawNotifierProvider.notifier).removeAction(id),
          );
        }
      }).toList(),
    );
  }

  //************************** */
  // selcet obeject tool kay color

  Widget _buildColorStrokeControls(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(drawModeProvider);
    final lineModel = ref.watch(lineSelectionProvider);

    // ✅ Sirf tab show karo jab mode "select_object" ho aur selection bhi ho
    if (currentMode != "object" || !lineModel.hasSelection) {
      return const SizedBox.shrink();
    }

    final selectedIndex = lineModel.selectedLineIndex!;
    final currentColor = lineModel.lineColors[selectedIndex];
    final currentStroke = lineModel.lineStrokes[selectedIndex];

    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        color: Colors.transparent,
        margin: const EdgeInsets.all(8),
        child: ColorAndStrokePicker(
          availableColors: [
            Colors.black,
            Colors.white,
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.purple,
            Colors.brown,
            Colors.grey,
          ],
          selectedColor: currentColor,
          strokeWidth: currentStroke,
          onColorChanged: (c) {
            ref.read(lineSelectionProvider).updateColor(c);
          },
          onStrokeWidthChanged: (w) {
            ref.read(lineSelectionProvider).updateStroke(w);
          },
          onClose: () => closeLayer(ref), // ✅ ye ab mode "none" karega
        ),
      ),
    );
  }

  //************************************* */

  /// Square ke liye color picker (gradient fill)
  Widget buildSquareColorPicker(BuildContext context, WidgetRef ref) {
    final currentMode = ref.watch(drawModeProvider);

    // ✅ Sirf tab show karo jab mode = background
    if (currentMode != "background") {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: ColorPickerWidget(
        availableColors: [
          Colors.black,
          Colors.white,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.orange,
          Colors.purple,
          Colors.yellow,
          Colors.cyan,
        ],

        selectedColor: Colors.white, // default
        onColorChanged: (color) {
          final drawState = ref.read(drawNotifierProvider);

          if (drawState.squareSelectedId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Please select a shape first",
                  style: TextStyle(
                    color: Colors.white, // ✅ hamesha white text
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                backgroundColor: Colors.orange, // ✅ orange background
                duration: Duration(milliseconds: 400), // ⏳ kam time ke liye
              ),
            );
            return;
          }

          // pehle provider update karo
          ref.read(backgroundColorProvider.notifier).state = color;

          // fir square ka fill color update karo
          ref
              .read(drawNotifierProvider.notifier)
              .updateFillColor(drawState.squareSelectedId!, color);
        },
      ),
    );
  }

  //************************************************ */
  //Draw mode
  Widget buildFreehandDrawLayer(WidgetRef ref, bool isSheetLocked) {
    final drawMode = ref.watch(drawModeProvider);
    if (drawMode != "drawmode") return const SizedBox.shrink();

    final strokes = ref.watch(
      drawNotifierProvider.select((s) => s.drawStrokes),
    );
    final color = ref.watch(drawModeStrokeColorProvider); // ✅ drawmode color
    final strokeWidth = ref.watch(
      drawModeStrokeWidthProvider,
    ); // ✅ drawmode stroke
    final currentStroke = ref.watch(drawModeCurrentStrokeProvider);

    Widget painter = CustomPaint(
      size: Size.infinite,
      painter: FreehandPainter(
        strokes: [...strokes, if (currentStroke.isNotEmpty) currentStroke],
        color: color,
        strokeWidth: strokeWidth,
      ),
    );

    painter = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) {
        ref.read(drawModeCurrentStrokeProvider.notifier).state = [
          details.localPosition,
        ];
      },
      onPanUpdate: (details) {
        final stroke = ref.read(drawModeCurrentStrokeProvider);
        ref.read(drawModeCurrentStrokeProvider.notifier).state = [
          ...stroke,
          details.localPosition,
        ];
      },
      onPanEnd: (_) {
        final stroke = ref.read(drawModeCurrentStrokeProvider);
        if (stroke.isNotEmpty) {
          ref.read(drawNotifierProvider.notifier).addStroke(stroke);
          ref.read(drawModeCurrentStrokeProvider.notifier).state = [];
        }
      },
      child: painter,
    );

    return IgnorePointer(ignoring: !isSheetLocked, child: painter);
  }

  Widget buildFreehandControlsLayer(WidgetRef ref) {
    final drawMode = ref.watch(drawModeProvider);
    final isPickerVisible = ref.watch(isColorLayerVisibleProvider);

    if (drawMode != "drawmode" || !isPickerVisible)
      return const SizedBox.shrink();

    final color = ref.watch(drawModeStrokeColorProvider);
    final stroke = ref.watch(drawModeStrokeWidthProvider);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        color: Colors.transparent,
        margin: const EdgeInsets.all(8),
        child: FreehandColorStrokePicker(
          availableColors: [
            Colors.black,
            Colors.white,
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.purple,
            Colors.brown,
            Colors.grey,
          ],
          selectedColor: color,
          strokeWidth: stroke,
          onColorChanged: (c) =>
              ref.read(drawModeStrokeColorProvider.notifier).state = c,
          onStrokeWidthChanged: (w) =>
              ref.read(drawModeStrokeWidthProvider.notifier).state = w,
          onClose: () =>
              ref.read(isColorLayerVisibleProvider.notifier).state = false,
        ),
      ),
    );
  }

  //color tab
  Widget buildFreehandDrawingLayer(WidgetRef ref) {
    final drawMode = ref.watch(drawModeProvider); // "draw" me gestures enable

    // return IgnorePointer(
    //   ignoring: drawMode != "draw", // gestures sirf "draw" tab me
    //   child: const FreehandDrawScreen(),
    // );
    return IgnorePointer(
      ignoring:
          !(drawMode == "draw" ||
              drawMode == "drawline"), // gestures sirf draw ya drawline tab me
      child: const FreehandDrawScreen(),
    );
  }

  // === Color Tab Layer Function ===

  Widget buildCanvasColorLayer(BuildContext context, WidgetRef ref) {
    final drawMode = ref.watch(drawModeProvider); // check current mode
    final isPickerVisible = ref.watch(isColorLayerVisibleProvider);

    // Show only when mode is 'color' and picker is visible
    if (!isPickerVisible || drawMode != "color") return const SizedBox.shrink();

    ref.watch(freehandStrokeColorProvider);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        color: Colors.transparent,
        margin: const EdgeInsets.all(8),
        child: FreehandColorPicker(
          availableColors: const [
            Colors.black,
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.orange,
            Colors.purple,
          ],
          selectedColor: ref.watch(freehandStrokeColorProvider),
          onColorChanged: (color) {
            // Update color tab
            ref.read(freehandStrokeColorProvider.notifier).state = color;
            // Update draw tab
            ref.read(drawModeStrokeColorProvider.notifier).state = color;
          },
          onClose: () {
            ref.read(isColorLayerVisibleProvider.notifier).state = false;
          },
        ),
      ),
    );
  }

  Widget _buildCanvas(WidgetRef ref) {
    // final mode = ref.watch(drawModeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
        final canvasSize = Size(
          viewportSize.width * 2,
          viewportSize.height * 4,
        );
        final freehandModes = ["draw", "drawline"];
        if (!_initialized) {
          const initialScale = 2.01;
          _transformationController.value = Matrix4.identity()
            ..scale(initialScale)
            ..translate(
              -(canvasSize.width - viewportSize.width) / 2 / initialScale,
              -(canvasSize.height - viewportSize.height) / 2 / initialScale,
            );
          _initialized = true;
        }

        final boundary = EdgeInsets.only(
          left: viewportSize.width / 50,
          right: viewportSize.width / 50,
          top: viewportSize.height / 100,
          bottom: viewportSize.height / 100,
        );

        return Stack(
          children: [
            InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: boundary,
              constrained: false,
              minScale: 0.01,
              maxScale: 5.0,
              panEnabled: !isSheetLocked,
              scaleEnabled: !isSheetLocked,
              child: SizedBox(
                width: canvasSize.width,
                height: canvasSize.height,
                child: Stack(
                  children: [
                    _gridLayer(canvasSize),
                    buildCanvasImagesLayer(ref),
                    buildFreehandDrawLayer(ref, isSheetLocked),

                    IgnorePointer(
                      ignoring: !freehandModes.contains(
                        ref.watch(drawModeProvider),
                      ),
                      child: FreehandDrawLayer(isSheetLocked: isSheetLocked),
                    ),

                    // Only render color picker if drawMode active
                    if (ref.watch(isColorLayerVisibleProvider) &&
                        ref.watch(drawModeProvider) == "color")
                      buildFreehandDrawingLayer(ref),
                    // buildFreehandDrawingLayer(ref),
                  ],
                ),
              ),
            ),

            buildCanvasColorLayer(context, ref),

            //drawmode
            buildFreehandControlsLayer(ref),
            //👇 Color picker yaha rakho (InteractiveViewer ke bahar)
            _buildColorStrokeControls(context, ref),

            // sqaure bg color
            buildSquareColorPicker(context, ref),

            ValueListenableBuilder<Matrix4>(
              valueListenable: _transformationController,
              builder: (context, matrix, _) {
                return _buildIndicators(viewportSize, canvasSize);
              },
            ),

            // Lock icon on top-right
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    isSheetLocked = !isSheetLocked;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Theme ke hisaab se halka background
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.orange.withOpacity(
                            0.25,
                          ) // Dark mode me halka orange glow
                        : Colors.grey.withOpacity(0.25), // light mode
                  ),
                  child: Icon(
                    isSheetLocked ? Icons.lock : Icons.lock_open,
                    color: Colors.orange, // icon clear highlight hoga
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // main build mathod
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return _buildCanvas(ref); // pass ref here
      },
    );
  }
}

// ---------------- Grid Painter ----------------
class GridPainter extends CustomPainter {
  final bool isDark;
  const GridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    const step = 6.0;
    final bgColor = Colors.white; // hamesha white
    final lineColor = Colors.black26; // hamesha grey lines

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = bgColor,
    );

    final gridPaint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.6;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) => false;
}
