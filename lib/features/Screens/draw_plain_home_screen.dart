import 'package:construction_calculator/Domain/entities/draw_plain_model.dart';
import 'package:construction_calculator/features/Draw_plain/Widgets/drawplain_canves.dart';
import 'package:construction_calculator/features/Draw_plain/draw_plain_provider.dart';
import 'package:construction_calculator/riverpode_providers/draw_plain_notifer.dart'
    hide drawModeProvider, drawNotifierProvider;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawPlanScreen extends ConsumerStatefulWidget {
  const DrawPlanScreen({super.key});

  @override
  ConsumerState<DrawPlanScreen> createState() => _DrawPlanScreenState();
}

class _DrawPlanScreenState extends ConsumerState<DrawPlanScreen> {
  final Color orangeColor = const Color(0xFFFF9C00);
  final TransformationController _transformationController =
      TransformationController();

  final categoryOptions = [
    {"label": "Door/Windows", "icon": "assets/icons/door.svg"},
    {"label": "Living Room", "icon": "assets/icons/living.svg"},
    {"label": "Bathroom Assets", "icon": "assets/icons/bath.svg"},
    {"label": "Kitchen Assets", "icon": "assets/icons/kitchen.svg"},
    {"label": "Car Collection", "icon": "assets/icons/car.svg"},
  ];

  late String selectedCategory;
  late String selectedCategoryIcon;

  @override
  void initState() {
    super.initState();
    selectedCategory = categoryOptions.first["label"]!;
    selectedCategoryIcon = categoryOptions.first["icon"]!;

    // Default category items load karo
    Future.microtask(() {
      ref.read(categoryItemsProvider.notifier).loadItems(selectedCategory);
    });
  }

  /// Category Dropdown
  Widget _buildCategoryDropdown(Color textColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width * 0.58,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Colors.orange, width: 1),
      ),
      child: Center(
        child: DropdownButton<String>(
          value: selectedCategory,
          isExpanded: true,
          underline: const SizedBox(),
          dropdownColor: isDark ? Colors.grey[850] : Colors.white,
          icon: Icon(Icons.arrow_drop_down, size: 25, color: orangeColor),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),

          // Selected item ke liye custom UI
          selectedItemBuilder: (context) {
            return categoryOptions.map((item) {
              return Row(
                children: [
                  const SizedBox(width: 10),
                  SvgPicture.asset(
                    item["icon"]!,
                    height: 22,
                    color: orangeColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item["label"]!,
                    style: TextStyle(
                      color: textColor,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }).toList();
          },

          onChanged: (val) {
            setState(() {
              selectedCategory = val!;
              selectedCategoryIcon = categoryOptions.firstWhere(
                (e) => e["label"] == val,
              )["icon"]!;
              ref
                  .read(categoryItemsProvider.notifier)
                  .loadItems(selectedCategory);
            });
          },

          items: categoryOptions.map((item) {
            return DropdownMenuItem<String>(
              value: item["label"],
              child: Row(
                children: [
                  SvgPicture.asset(
                    item["icon"]!,
                    height: 18,
                    color: orangeColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item["label"]!,
                    style: TextStyle(
                      color: textColor,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Exit confirm dialog
  Future<void> _confirmClose() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Confirm Exit",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            "Are you sure you want to close this screen?",
            style: TextStyle(
              fontFamily: "Poppins",
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                "Cancel",
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                "OK",
                style: TextStyle(
                  fontWeight: FontWeight
                      .bold, // optional, text aur prominent banane ke liye
                  color: Colors.white, // Orange ke saath full white best hai
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldClose == true) {
      ref.invalidate(drawNotifierProvider);
      if (mounted) Navigator.pop(context);
    }
  }

  //add dimension alert box

  Future<void> showAddLineDimensionDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final TextEditingController dimensionController = TextEditingController();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBackground = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white54 : Colors.black54;
    final cancelButtonColor = isDark ? Colors.white : Colors.black;

    final enteredValue = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dialogBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Add Line Dimension",
            style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
          ),
          content: TextField(
            controller: dimensionController,
            decoration: InputDecoration(
              hintText: "e.g. 12*24",
              hintStyle: TextStyle(color: hintColor),
              border: const OutlineInputBorder(),
            ),
            style: TextStyle(color: textColor),
            keyboardType: TextInputType.text,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: cancelButtonColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                Navigator.pop(context, dimensionController.text.trim());
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
    if (enteredValue != null && enteredValue.isNotEmpty) {
      final notifier = ref.read(drawNotifierProvider.notifier);

      // Canvas ke center me position
      final Size canvasSize = MediaQuery.of(context).size;
      final Offset canvasCenter = Offset(
        canvasSize.width / 2,
        canvasSize.height / 2,
      );

      notifier.addDimensionLine(enteredValue, canvasCenter);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(drawNotifierProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final canvasSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // Screen pe kahin bhi tap karo to selection hat jayega
        ref.read(drawModeProvider.notifier).state = '';
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: orangeColor,
          title: const Text(
            "Draw Plan",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: _confirmClose,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.undo, color: Colors.white),
              onPressed: notifier.undo,
            ),
            IconButton(
              icon: const Icon(Icons.redo, color: Colors.white),
              onPressed: notifier.redo,
            ),
            IconButton(
              icon: const Icon(Icons.download, color: Colors.white),
              onPressed: () {
                // Export/save functionality yahan implement karo
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 15),
            _buildCategoryDropdown(textColor),
            const SizedBox(height: 10),

            Consumer(
              builder: (context, ref, _) {
                return buildCircleRow(context, ref, orangeColor);
              },
            ),

            const SizedBox(height: 2),
            // ✅ SIRF CONSUMER RAKHO
            Expanded(
              child: DrawPlanCanvas(canvasSize: MediaQuery.of(context).size),
            ),

            _buildBottomToolbar(
              context,
              orangeColor,
              _transformationController,
              ref,
              canvasSize, // ✅ Canvas size pass karna zaruri hai
            ),
          ],
        ),
      ),
    );
  }
  // ---------------- buildCircleRow ----------------

  Widget buildCircleRow(
    BuildContext context,
    WidgetRef ref,
    Color orangeColor,
  ) {
    final items = ref.watch(categoryItemsProvider);
    final notifier = ref.read(drawNotifierProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    // Take only first 3 items for display
    final limitedItems = List<Map<String, String>>.from(items.take(3));
    while (limitedItems.length < 3) {
      limitedItems.add({"label": "", "icon": ""});
    }

    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Label Circle
          GestureDetector(
            onTap: () async {
              final controller = TextEditingController();

              final enteredText = await showDialog<String>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    title: const Text(
                      "Enter Label",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Enter a text",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        onPressed: () {
                          Navigator.pop(context, controller.text.trim());
                        },
                        child: const Text(
                          "OK",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );

              if (enteredText != null && enteredText.isNotEmpty) {
                notifier.addAction(
                  DrawAction(
                    id: UniqueKey().toString(),
                    type: "label",
                    text: enteredText,
                    color: textColor,
                    position: const Offset(150, 150),
                    size: const Size(100, 40),
                  ),
                );
              }
            },
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      "assets/icons/TT.svg",
                      height: 18,
                      width: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Label",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Category Circles
          ...limitedItems.map((item) {
            final hasData = item["icon"]!.isNotEmpty;

            return GestureDetector(
              onTap: hasData
                  ? () {
                      notifier.addAction(
                        DrawAction(
                          id: UniqueKey().toString(),
                          type: "object",
                          assetPath: item["icon"], // selected icon
                          position: const Offset(150, 150),
                          size: const Size(100, 100),
                          text: item["label"] ?? "",
                          color: textColor,
                        ),
                      );
                    }
                  : null,
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: orangeColor, width: 1),
                      color: isDark ? Colors.grey[800] : Colors.white,
                    ),
                    child: hasData
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: item["icon"]!.endsWith(".svg")
                                ? SvgPicture.asset(
                                    item["icon"]!,
                                    height: 32,
                                    width: 32,
                                  )
                                : Image.asset(
                                    item["icon"]!,
                                    height: 22,
                                    width: 22,
                                    fit: BoxFit.contain,
                                  ),
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["label"] ?? "",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBottomToolbar(
    BuildContext context,
    Color orangeColor,
    TransformationController
    transformationController, // agar future me use karna ho
    WidgetRef ref,
    Size
    canvasSize, // ✅ Canvas size bhi pass karo taake square center me add ho sake
  ) {
    final drawMode = ref.watch(drawModeProvider);
    final theme = Theme.of(context);
    final defaultColor = theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    final tabs = [
      {"mode": "draw", "icon": "assets/icons/draw.svg", "label": "Draw"},
      {
        "mode": "square",
        "icon": "assets/icons/bottombar.svg",
        "label": "Draw Square",
      },
      {
        "mode": "object",
        "icon": "assets/icons/selcet.svg",
        "label": "Select Object",
      },
      {
        "mode": "drawline",
        "icon": "assets/icons/line.svg",
        "label": "Separate Line",
      },
      {
        "mode": "dimensions",
        "icon": "assets/icons/add_dimensions_icon.svg",
        "label": "Add Dimensions",
      },
      {
        "mode": "background",
        "icon": "assets/icons/floor_background_icon.svg",
        "label": "Background",
      },
      {
        "mode": "drawmode",
        "icon": "assets/icons/draw_mode_icon.svg",
        "label": "Draw Mode",
      },
      {
        "mode": "color",
        "icon": "assets/icons/color_icon.svg",
        "label": "Color",
      },
    ];

    return Container(
      height: 70,
      color: theme.brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.grey[200],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((tab) {
            final isSelected = drawMode == tab["mode"];
            return SizedBox(
              width: 90,
              child: GestureDetector(
                onTap: () {
                  print("Tab tapped: ${tab['mode']}"); // ✅ Konsa tab click hua

                  if (tab["mode"] == "square") {
                    // // ✅ Reset line selection for new square
                    ref
                        .read(drawNotifierProvider.notifier)
                        .addFreehandRectangle(canvasSize);
                  }

                  // ✅ Agar object mode select karein
                  if (tab["mode"] == "object") {
                    final lineModel = ref.read(lineSelectionProvider);
                    if (lineModel.hasSelection) {}
                  }
                  // agar mode add dimensions select karein
                  if (tab["mode"] == "dimensions") {
                    // reset selection of CanvasItemWidgets
                    ref.read(drawNotifierProvider.notifier).selectAction(null);
                    showAddLineDimensionDialog(context, ref);
                  }

                  if (tab["mode"] == "background") {
                    final drawState = ref.read(drawNotifierProvider);

                    if (drawState.squareSelectedId == null &&
                        drawState.actions.isNotEmpty) {
                      final firstSquare = drawState.actions.firstWhere(
                        (a) => a.type == 'square',
                      );
                      ref.read(drawNotifierProvider.notifier).squareSelectedId =
                          firstSquare.id;
                    }

                    final selectedId = ref
                        .read(drawNotifierProvider)
                        .squareSelectedId;
                    if (selectedId != null) {
                      final pickedColor = ref.read(
                        backgroundColorProvider,
                      ); // ✅ ye color fill hoga
                      ref
                          .read(drawNotifierProvider.notifier)
                          .updateFillColor(selectedId, pickedColor);
                    }

                    ref.read(drawModeProvider.notifier).state = "background";
                  }

                  if (tab["mode"] == "drawmode") {
                    // Draw gestures + picker sirf Draw Mode tab ke liye
                    ref.read(drawModeProvider.notifier).state = "drawmode";
                    ref.read(isColorLayerVisibleProvider.notifier).state = true;
                    print("Draw Mode activated");
                  }

                  if (tab["mode"] == "color") {
                    // Draw gestures + color picker
                    ref.read(drawModeProvider.notifier).state =
                        "draw"; // freehand drawing
                    ref.read(isColorLayerVisibleProvider.notifier).state = true;
                    print("Color tab activated");
                  }

                  ref.read(drawModeProvider.notifier).state = tab["mode"]!;
                },

                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected ? orangeColor : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        tab["icon"]!,
                        height: 23,
                        width: 23,
                        color: isSelected ? Colors.white : defaultColor,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        tab["label"]!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : defaultColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
