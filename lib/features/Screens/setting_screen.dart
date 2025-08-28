import 'package:construction_calculator/Core/theme/app_fonts.dart';
import 'package:construction_calculator/riverpode_providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'App Settings',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
            color: isDark ? Colors.grey[850] : Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Theme',
                    style: AppTheme.headingMedium.copyWith(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSmall),
                  Row(
                    children: [
                      Radio<ThemeMode>(
                        value: ThemeMode.light,
                        groupValue: appState.themeMode,
                        onChanged: (_) => appNotifier.setTheme(ThemeMode.light),
                        activeColor: AppTheme.primaryColor,
                      ),
                      Text(
                        'Light Mode',
                        style: AppTheme.bodyRegular.copyWith(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Radio<ThemeMode>(
                        value: ThemeMode.dark,
                        groupValue: appState.themeMode,
                        onChanged: (_) => appNotifier.setTheme(ThemeMode.dark),
                        activeColor: AppTheme.primaryColor,
                      ),
                      Text(
                        'Dark Mode',
                        style: AppTheme.bodyRegular.copyWith(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingSmall),

          _buildSettingsTile(
            title: 'Share App',
            subtitle: 'Share app with your friends & members',
            onTap: () {},
            isDark: isDark,
          ),
          _buildSettingsTile(
            title: 'More Apps',
            subtitle: 'Checkout more apps developed by us',
            onTap: () {},
            isDark: isDark,
          ),
          _buildSettingsTile(
            title: 'Rate Us',
            subtitle: 'Give us your valuable feedback',
            onTap: () {},
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: AppTheme.bodyRegular.copyWith(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.caption.copyWith(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
