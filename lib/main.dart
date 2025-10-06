import 'package:construction_calculator/Core/Hive/hive_setup.dart';
import 'package:construction_calculator/Core/theme/app_fonts.dart';
import 'package:construction_calculator/features/Screens/splash_screen.dart';
import 'package:construction_calculator/riverpode_providers/app_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await HiveSetup.init(); // ✅ Hive centralized setup

//   runApp(const ProviderScope(child: MyApp()));
//   final bool isDebug = false;
//   runApp(
//     DevicePreview(
//       enabled: isDebug, // iOS preview enable
//       builder: (context) => const ProviderScope(child: MyApp()),
//     ),
//   );
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveSetup.init();
  final bool isDebug = false;
  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: isDebug, // On in debug, off in release/profile
        builder: (context) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);

    return MaterialApp(
      // ignore: deprecated_member_use
      useInheritedMediaQuery: true, // DevicePreview ke liye zaroori
      builder: DevicePreview.appBuilder, // DevicePreview builder
      locale: DevicePreview.locale(context), // Locale preview
      debugShowCheckedModeBanner: false,
      title: 'Construction Calculator',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: appState.themeMode, // Ye Riverpod se aayega
      home: const SplashScreen(),
    );
  }
}
