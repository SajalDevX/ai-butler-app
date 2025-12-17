import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import 'providers/capture_provider.dart';
import 'screens/capture/capture_modal.dart';
import 'screens/home/home_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'services/overlay_service.dart';
import 'theme/app_theme.dart';
import 'theme/colors.dart';

class RecallButlerApp extends ConsumerWidget {
  const RecallButlerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Recall Butler',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const AppShell(),
    );
  }
}

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    SearchScreen(),
    SizedBox(), // Placeholder for FAB
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _setupOverlayCallback();
  }

  void _setupOverlayCallback() {
    OverlayService.setCallbackHandler(
      onAction: (action) {
        // Handle overlay actions
        switch (action) {
          case 'screenshot':
            // This is called when permission is needed first
            // After permission, screenshot will be captured directly by native code
            _requestScreenshotPermission();
            break;
          case 'photo':
          case 'voice':
          case 'link':
            // Navigate to home and show capture modal
            setState(() => _currentIndex = 0);
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) showCaptureModal(context);
            });
            break;
        }
      },
      onScreenshotCaptured: (base64Image) {
        // Screenshot was captured by native code - just upload it
        _uploadScreenshot(base64Image);
      },
    );
  }

  Future<void> _requestScreenshotPermission() async {
    // Request permission - after granted, user can tap screenshot again
    // and it will capture directly
    final granted = await OverlayService.requestScreenCapturePermission();
    if (mounted) {
      if (granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Screenshot permission granted! Tap screenshot again to capture.'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Screenshot permission denied'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadScreenshot(String base64Image) async {
    // Show uploading indicator
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 16),
              Text('Processing screenshot with AI...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );
    }

    final bytes = base64Decode(base64Image);
    final capture = await ref.read(capturesProvider.notifier).createImageCapture(
      bytes,
      'screenshot',
      sourceApp: 'Overlay',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (capture != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Screenshot captured and processed!'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
        // Navigate to home to show the new capture
        setState(() => _currentIndex = 0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process screenshot'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCaptureModal(context),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Iconsax.add, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavItem(
                icon: Iconsax.home_2,
                activeIcon: Iconsax.home_25,
                label: 'Home',
                isSelected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),
              _NavItem(
                icon: Iconsax.search_normal,
                activeIcon: Iconsax.search_normal_1,
                label: 'Search',
                isSelected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              const SizedBox(width: 48), // Space for FAB
              _NavItem(
                icon: Iconsax.setting_2,
                activeIcon: Iconsax.setting_25,
                label: 'Settings',
                isSelected: _currentIndex == 3,
                onTap: () => setState(() => _currentIndex = 3),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
