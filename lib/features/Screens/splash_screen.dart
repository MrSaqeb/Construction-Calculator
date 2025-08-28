// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:construction_calculator/features/Screens/home_sacreen.dart';
import 'package:construction_calculator/riverpode_providers/app_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay navigation safely
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      ref.read(appProvider.notifier).setStatus(AppStatus.loaded);
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Image.asset(
                    'assets/images/bg.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),

                // 🔸 Solid orange background instead of bottom part of image
                Expanded(
                  flex: 0,
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFFF9C00),
                  ),
                ),
              ],
            ),
          ),
          // 🔸 Responsive Layout
          LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = constraints.maxHeight;
              final screenWidth = constraints.maxWidth;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.08),

                  // 🔸 Title Image
                  Image.asset(
                    'assets/images/name.jpg',
                    width: screenWidth * 0.8,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // 🔸 Man Image
                  Image.asset(
                    'assets/images/man.png',
                    height: screenHeight * 0.61,
                    fit: BoxFit.contain,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
