import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    final isDark = themeNotifier.isDark;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: const Text(
          'Settings',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Preferences',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? AppColors.white : AppColors.darkGray,
            ),
          ),
          const SizedBox(height: 12),

          // Theme toggle
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: theme.cardColor,
            child: ListTile(
              leading: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.vibrantOrange,
              ),
              title: Text(
                'Dark Mode',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Switch(
                value: isDark,
                activeThumbColor: AppColors.vibrantOrange,
                onChanged: (_) => ref.read(themeProvider).toggleTheme(),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Notification settings
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: theme.cardColor,
            child: ListTile(
              leading: const Icon(
                Icons.notifications,
                color: AppColors.vibrantOrange,
              ),
              title: Text(
                'Notification Preferences',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to notifications settings
              },
            ),
          ),
          const SizedBox(height: 12),

          // Help & FAQ
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: theme.cardColor,
            child: ListTile(
              leading: const Icon(
                Icons.help_outline,
                color: AppColors.vibrantOrange,
              ),
              title: Text(
                'Help & FAQ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to FAQ
              },
            ),
          ),
        ],
      ),
    );
  }
}
