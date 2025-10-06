import 'dart:io';
import 'package:construction_calculator/features/Bubble_Level/Application/ruler_provider.dart';
import 'package:construction_calculator/features/Bubble_Level/Widget/ruler_widget_panter.dart';
import 'package:construction_calculator/features/Screens/bubblelevel_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class RulerScreen extends ConsumerWidget {
  const RulerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rulerProvider);
    final notifier = ref.read(rulerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Bubble Level",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/calib.svg',
              width: 22,
              height: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => notifier.toggleCalibration(),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/ruler.svg',
              width: 22,
              height: 20,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BubbleLevelSettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Left ruler
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 12,
                    ),
                    child: SizedBox(
                      width: 60,
                      child: RulerWidget(
                        maxInches: state.leftMaxInches,
                        isLeft: true,
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 12,
                    ),
                    child: SizedBox(
                      width: 60,
                      child: RulerWidget(
                        maxInches: state.rightMaxInches,
                        isLeft: false,
                      ),
                    ),
                  ),
                ),

                // Center lines with draggable handles (only in calibration mode)
                if (state.showCalibration)
                  SizedBox(
                    width: 140,
                    child: Stack(
                      children: [
                        _buildLine(
                          state.leftLineY,
                          (y) => notifier.move(true, y),
                          left: 30,
                          maxInches: 11,
                        ),
                        _buildLine(
                          state.rightLineY,
                          (y) => notifier.move(false, y),
                          right: 30,
                          maxInches: 4,
                        ),
                      ],
                    ),
                  ),
                // Refresh button bottom center (only in calibration mode)
                if (state.showCalibration)
                  Positioned(
                    bottom: 50,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => notifier.reset(),
                          child: Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Refresh",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine(
    double y,
    Function(double) onMove, {
    double? left,
    double? right,
    required int maxInches,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) {
            double newY = y + details.delta.dy;

            // Clamp between top (0) and bottom (maxHeight - 36)
            if (newY < 0) newY = 0;
            if (newY > constraints.maxHeight - 36) {
              newY = constraints.maxHeight - 36;
            }

            // 🔄 Reverse mapping: bottom = 0, top = maxInches
            double progress = newY / (constraints.maxHeight - 36);
            ((1 - progress) * maxInches).clamp(0, maxInches.toDouble());

            onMove(newY);
          },
          child: Stack(
            children: [
              // Black line above circle
              Positioned(
                top: 0,
                height: y,
                left: left,
                right: right,
                child: Container(width: 2, color: Colors.black),
              ),
              // Orange line below circle
              Positioned(
                top: y + 36,
                bottom: 0,
                left: left,
                right: right,
                child: Container(width: 2, color: Colors.orange),
              ),
              // Circle handle
              Positioned(
                top: y,
                left: left != null ? left - 18 : null,
                right: right != null ? right - 18 : null,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 2),
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.unfold_more,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
