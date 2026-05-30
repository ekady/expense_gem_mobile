import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Display',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _buildSettingsItem(
                    context,
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.light,
                            );
                      },
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context,
                    icon: Icons.text_format,
                    title: 'Text Size',
                    subtitle: 'Medium',
                    onTap: () {
                      // Show text size options
                    },
                  ).animate().fadeIn(delay: 150.ms),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Transactions',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _buildSettingsItem(
                    context,
                    icon: Icons.calendar_today_outlined,
                    title: 'First Day of Week',
                    subtitle: 'Monday',
                    onTap: () {
                      // Show week start options
                    },
                  ).animate().fadeIn(delay: 200.ms),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context,
                    icon: Icons.backup_outlined,
                    title: 'Backup & Restore',
                    onTap: () {
                      // Navigate to backup options
                    },
                  ).animate().fadeIn(delay: 250.ms),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context,
                    icon: Icons.delete_outline,
                    title: 'Clear All Data',
                    textColor: Theme.of(context).colorScheme.error,
                    iconColor: Theme.of(context).colorScheme.error,
                    onTap: () {
                      // Show clear data confirmation
                      _showClearDataDialog(context);
                    },
                  ).animate().fadeIn(delay: 300.ms),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'About',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _buildSettingsItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'App Version',
                    subtitle: '1.0.0',
                    onTap: null, // No action for version
                    trailing: const SizedBox.shrink(),
                  ).animate().fadeIn(delay: 350.ms),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context,
                    icon: Icons.star_outline,
                    title: 'Rate the App',
                    onTap: () {
                      // Open app store rating
                    },
                  ).animate().fadeIn(delay: 400.ms),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      // Open privacy policy
                    },
                  ).animate().fadeIn(delay: 450.ms),
                  const Divider(height: 1),
                  _buildSettingsItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    onTap: () {
                      // Open terms of service
                    },
                  ).animate().fadeIn(delay: 500.ms),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: textColor),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
          trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear All Data'),
            content: const Text(
              'This will permanently delete all your transactions, accounts, and categories. This action cannot be undone. Are you sure you want to continue?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  // Clear all data
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All data has been cleared')),
                  );
                },
                child: Text(
                  'CLEAR DATA',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
    );
  }
}
