import 'dart:io';
import 'package:construction_calculator/features/Bubble_Level/Application/bubbel_level_provider.dart';
import 'package:construction_calculator/features/Bubble_Level/Widget/bubbel_level_pointer.dart';
import 'package:construction_calculator/features/Bubble_Level/Widget/bubble_level_angle_box.dart';
import 'package:construction_calculator/features/Screens/bubblelevel_setting.dart';
import 'package:construction_calculator/features/Screens/ruler_screen.dart';
import 'package:construction_calculator/riverpode_providers/bubble_setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BubbleLevelScreen extends ConsumerStatefulWidget {
  const BubbleLevelScreen({super.key});

  @override
  ConsumerState<BubbleLevelScreen> createState() => _BubbleLevelScreenState();
}

class _BubbleLevelScreenState extends ConsumerState<BubbleLevelScreen> {
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> _applyOrientationLock(bool allow) async {
    if (allow) {
      final orientation = MediaQuery.of(context).orientation;
      if (orientation == Orientation.portrait) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    } else {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bubbleProvider);
    final settings = state.settings;
    final bubble = state.bubble;

    final notifier = ref.read(bubbleProvider.notifier);

    // Safe listen inside build
    ref.listen<BubbleState>(bubbleProvider, (previous, next) {
      if (previous?.settings.allowOrientationLock !=
          next.settings.allowOrientationLock) {
        _applyOrientationLock(next.settings.allowOrientationLock);
      }
    });

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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/calibar.svg',
                  width: 20,
                  height: 18,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => buildCalibrateDialog(
                      context: context,
                      onCalibrate: () {
                        notifier.calibrate(bubble.pitch, bubble.roll);
                        Navigator.pop(context);
                      },
                      onReset: () {
                        notifier.resetCalibration();
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/ruler.svg',
                  width: 22,
                  height: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const RulerScreen(), // ye tumhari nayi ruler screen hogi
                    ),
                  );
                },
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
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 270,
              height: 270,
              child: CustomPaint(
                painter: BubblePainter(bubble, viscosity: settings.viscosity),
              ),
            ),
          ),
          if (settings.showNumericAngle)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0, right: 5, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AngleBox(
                      settings.displayType == "Angle"
                          ? bubble.roll
                          : bubble.rollPercent,
                      showLeftArrow: true,
                      displayType: settings.displayType,
                      showNumeric: true,
                    ),
                    const SizedBox(width: 5),
                    AngleBox(
                      settings.displayType == "Angle"
                          ? bubble.pitch
                          : bubble.pitchPercent,
                      showUpArrow: true,
                      displayType: settings.displayType,
                      showNumeric: true,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget buildCalibrateDialog({
  required BuildContext context,
  required VoidCallback onCalibrate,
  required VoidCallback onReset,
}) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: SizedBox(
      width: 320,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20), // Space for top-right close icon
                SvgPicture.asset(
                  'assets/icons/calibrate_phone.svg',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Calibrate your phone ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Put any side (including the back) of your device on a flat horizontal surface and press the Calibrate button. Or reset the calibration for all phone sides.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12,
                      height: 1.5,
                    ),
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 20),
                // Buttons full width
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: onCalibrate,
                        child: const Text(
                          'Calibrate',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onReset,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Top-right Close button
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.close, size: 24, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
