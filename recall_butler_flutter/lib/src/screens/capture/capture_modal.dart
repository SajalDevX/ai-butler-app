import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../providers/capture_provider.dart';
import '../../theme/colors.dart';

class CaptureModal extends ConsumerStatefulWidget {
  const CaptureModal({super.key});

  @override
  ConsumerState<CaptureModal> createState() => _CaptureModalState();
}

class _CaptureModalState extends ConsumerState<CaptureModal> {
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Iconsax.add, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'New Capture',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Capture options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CaptureOption(
                  icon: Iconsax.mobile,
                  label: 'Screenshot',
                  color: AppColors.info,
                  onTap: () => _captureScreenshot(context),
                ).animate().fadeIn(delay: 0.ms).scale(delay: 0.ms),
                _CaptureOption(
                  icon: Iconsax.camera,
                  label: 'Photo',
                  color: AppColors.success,
                  onTap: () => _capturePhoto(context),
                ).animate().fadeIn(delay: 50.ms).scale(delay: 50.ms),
                _CaptureOption(
                  icon: Iconsax.microphone,
                  label: 'Voice',
                  color: AppColors.warning,
                  onTap: () => _toggleVoiceRecording(context),
                ).animate().fadeIn(delay: 100.ms).scale(delay: 100.ms),
                _CaptureOption(
                  icon: Iconsax.link,
                  label: 'Link',
                  color: AppColors.secondary,
                  onTap: () => _captureLink(context),
                ).animate().fadeIn(delay: 150.ms).scale(delay: 150.ms),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _captureScreenshot(BuildContext context) async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      _showPermissionError(context, 'photos');
      return;
    }

    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image != null) {
      Navigator.pop(context);
      _processingIndicator(context);

      await ref.read(capturesProvider.notifier).createCaptureFromFile(
            File(image.path),
            'screenshot',
          );
    }
  }

  Future<void> _capturePhoto(BuildContext context) async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      _showPermissionError(context, 'camera');
      return;
    }

    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (image != null) {
      Navigator.pop(context);
      _processingIndicator(context);

      await ref.read(capturesProvider.notifier).createCaptureFromFile(
            File(image.path),
            'photo',
          );
    }
  }

  Future<void> _toggleVoiceRecording(BuildContext context) async {
    // Voice recording temporarily disabled - show coming soon message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice recording coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _captureLink(BuildContext context) async {
    final controller = TextEditingController();

    final url = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Link'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'https://',
            prefixIcon: Icon(Iconsax.link),
          ),
          keyboardType: TextInputType.url,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (url != null && url.isNotEmpty) {
      Navigator.pop(context);
      _processingIndicator(context);

      await ref.read(capturesProvider.notifier).createLinkCapture(url);
    }
  }

  void _processingIndicator(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 16),
            const Text('Processing capture...'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showPermissionError(BuildContext context, String permission) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please grant $permission permission'),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () => openAppSettings(),
        ),
      ),
    );
  }

}

class _CaptureOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CaptureOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.3),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Show the capture modal
void showCaptureModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const CaptureModal(),
  );
}
