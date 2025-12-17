import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/preferences_provider.dart';
import '../../services/overlay_service.dart';
import '../../theme/colors.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Floating Overlay Section (Android Only)
          if (OverlayService.isSupported) ...[
            _SectionHeader(
              icon: Iconsax.mobile,
              title: 'Floating Overlay',
              subtitle: 'Capture from any app',
            ),
            const SizedBox(height: 12),
            _SettingsCard(
              children: [
                _SwitchTile(
                  icon: Iconsax.maximize_circle,
                  title: 'Enable Floating Button',
                  subtitle: 'Show capture button over other apps',
                  value: preferences?.overlayEnabled ?? false,
                  onChanged: (value) async {
                    if (value) {
                      final granted = await OverlayService.requestPermission();
                      if (granted) {
                        await OverlayService.showOverlay();
                        ref
                            .read(preferencesProvider.notifier)
                            .updatePreferences(overlayEnabled: true);
                        // Also request screen capture permission upfront
                        // so screenshots are instant
                        await OverlayService.requestScreenCapturePermission();
                      }
                    } else {
                      await OverlayService.hideOverlay();
                      ref
                          .read(preferencesProvider.notifier)
                          .updatePreferences(overlayEnabled: false);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // Notifications Section
          _SectionHeader(
            icon: Iconsax.notification,
            title: 'Notifications',
            subtitle: 'Stay informed about your captures',
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              _SwitchTile(
                icon: Iconsax.calendar,
                title: 'Weekly Digest',
                subtitle: 'Get a summary of your captures each week',
                value: preferences?.weeklyDigestEnabled ?? true,
                onChanged: (value) {
                  ref
                      .read(preferencesProvider.notifier)
                      .updatePreferences(weeklyDigestEnabled: value);
                },
              ),
              const Divider(height: 1),
              _SwitchTile(
                icon: Iconsax.alarm,
                title: 'Proactive Reminders',
                subtitle: 'Get reminded about stale captures',
                value: preferences?.proactiveRemindersEnabled ?? true,
                onChanged: (value) {
                  ref
                      .read(preferencesProvider.notifier)
                      .updatePreferences(proactiveRemindersEnabled: value);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Appearance Section
          _SectionHeader(
            icon: Iconsax.paintbucket,
            title: 'Appearance',
            subtitle: 'Customize your experience',
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              _NavigationTile(
                icon: Iconsax.moon,
                title: 'Theme',
                value: _getThemeLabel(preferences?.theme ?? 'dark'),
                onTap: () => _showThemeSelector(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // About Section
          _SectionHeader(
            icon: Iconsax.info_circle,
            title: 'About',
          ),
          const SizedBox(height: 12),
          _SettingsCard(
            children: [
              _NavigationTile(
                icon: Iconsax.document_text,
                title: 'Privacy Policy',
                onTap: () => _openUrl('https://recallbutler.app/privacy'),
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Iconsax.document,
                title: 'Terms of Service',
                onTap: () => _openUrl('https://recallbutler.app/terms'),
              ),
              const Divider(height: 1),
              _NavigationTile(
                icon: Iconsax.code,
                title: 'Version',
                value: '1.0.0',
                showArrow: false,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Built with love
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Iconsax.cpu, size: 32),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Recall Butler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your AI-Powered Second Brain',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Built with Flutter + Serverpod + Gemini AI',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _getThemeLabel(String theme) {
    switch (theme) {
      case 'dark':
        return 'Dark';
      case 'light':
        return 'Light';
      case 'system':
        return 'System';
      default:
        return 'Dark';
    }
  }

  void _showThemeSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Select Theme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Iconsax.moon),
              title: const Text('Dark'),
              onTap: () {
                ref
                    .read(preferencesProvider.notifier)
                    .updatePreferences(theme: 'dark');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.sun_1),
              title: const Text('Light'),
              onTap: () {
                ref
                    .read(preferencesProvider.notifier)
                    .updatePreferences(theme: 'light');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.mobile),
              title: const Text('System'),
              onTap: () {
                ref
                    .read(preferencesProvider.notifier)
                    .updatePreferences(theme: 'system');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback? onTap;
  final bool showArrow;

  const _NavigationTile({
    required this.icon,
    required this.title,
    this.value,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AppColors.textSecondary),
      ),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value!,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          if (showArrow) ...[
            const SizedBox(width: 4),
            const Icon(
              Iconsax.arrow_right_3,
              size: 16,
              color: AppColors.textTertiary,
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}
