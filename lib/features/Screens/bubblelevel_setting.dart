import 'dart:io';
import 'package:construction_calculator/riverpode_providers/bubble_setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BubbleLevelSettingsScreen extends ConsumerWidget {
  const BubbleLevelSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bubbleProvider);
    final notifier = ref.read(bubbleProvider.notifier);
    final settings = state.settings;

    final Color orangeColor = const Color(0xFFFF9C00);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColor,
        leading: IconButton(
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 19,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Show Numeric Angle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Show Numeric Angle',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Display Angle Value on Screen',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: settings.showNumericAngle,
                    onChanged: notifier.toggleShowNumericAngle,
                    activeTrackColor: orangeColor,
                    inactiveTrackColor: Colors.grey,
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ✅ Display Type (Angle / Inclination %)
            const Text(
              'Display Type',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Radio<String>(
                  value: 'Angle',
                  groupValue: settings.displayType,
                  activeColor: orangeColor,
                  onChanged: (val) => notifier.changeDisplayType(val!),
                ),
                const Text('Angle', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 20),
                Radio<String>(
                  value: 'Inclination',
                  groupValue: settings.displayType,
                  activeColor: orangeColor,
                  onChanged: (val) => notifier.changeDisplayType(val!),
                ),
                const Text(
                  'Inclination in percent',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ✅ Orientation Lock
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Allow Level Orientation Locking',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: settings.allowOrientationLock,
                    onChanged: notifier.toggleOrientationLock,
                    activeTrackColor: orangeColor,
                    inactiveTrackColor: Colors.grey,
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ✅ Viscosity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Viscosity',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: Color(0xFFFF9C00),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Bubble move faster',
                      style: TextStyle(fontSize: 14, color: Color(0xFFFF9C00)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Low', 'Medium', 'High'].map((level) {
                return Row(
                  children: [
                    Radio<String>(
                      value: level,
                      groupValue: settings.viscosity,
                      activeColor: orangeColor,
                      onChanged: (val) => notifier.changeViscosity(val!),
                    ),
                    Text(level, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 10),
                  ],
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // ✅ Sound Effect
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sound Effects',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Play Sound When level',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: settings.soundEffect,
                    onChanged: notifier.toggleSoundEffect,
                    activeTrackColor: orangeColor,
                    inactiveTrackColor: Colors.grey,
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
