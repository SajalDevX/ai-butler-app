import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recall_butler_client/recall_butler_client.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../theme/colors.dart';

class CaptureCard extends StatelessWidget {
  final Capture capture;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool showTags;

  const CaptureCard({
    super.key,
    required this.capture,
    this.onTap,
    this.onLongPress,
    this.showTags = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image/Thumbnail
            if (_hasImage)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: capture.thumbnailUrl ?? capture.originalUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.surfaceLight,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.surfaceLight,
                        child: const Icon(Iconsax.image, size: 40),
                      ),
                    ),
                    // Type badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _TypeBadge(type: capture.type),
                    ),
                    // Processing indicator
                    if (capture.processingStatus != 'completed')
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _ProcessingBadge(
                          status: capture.processingStatus,
                        ),
                      ),
                    // Reminder indicator
                    if (capture.isReminder)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Iconsax.alarm, size: 14, color: Colors.black),
                              SizedBox(width: 4),
                              Text(
                                'Reminder',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else
              Container(
                height: 80,
                color: AppColors.surfaceLight,
                child: Center(
                  child: Icon(
                    _getTypeIcon(),
                    size: 32,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  _CategoryChip(category: capture.category),
                  const SizedBox(height: 8),

                  // Summary
                  if (capture.aiSummary != null)
                    Text(
                      capture.aiSummary!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  else if (capture.extractedText != null)
                    Text(
                      capture.extractedText!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 8),

                  // Tags
                  if (showTags && capture.tags != null)
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: _parseTags().take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '#$tag',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 8),

                  // Timestamp and source
                  Row(
                    children: [
                      Icon(
                        Iconsax.clock,
                        size: 12,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeago.format(capture.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      if (capture.sourceApp != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '• ${capture.sourceApp}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  bool get _hasImage =>
      (capture.type == 'screenshot' || capture.type == 'photo') &&
      (capture.thumbnailUrl != null || capture.originalUrl != null);

  IconData _getTypeIcon() {
    switch (capture.type) {
      case 'screenshot':
        return Iconsax.mobile;
      case 'photo':
        return Iconsax.camera;
      case 'voice':
        return Iconsax.microphone;
      case 'link':
        return Iconsax.link;
      default:
        return Iconsax.document;
    }
  }

  List<String> _parseTags() {
    try {
      return List<String>.from(jsonDecode(capture.tags!));
    } catch (e) {
      return [];
    }
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            _getLabel(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case 'screenshot':
        return Iconsax.mobile;
      case 'photo':
        return Iconsax.camera;
      case 'voice':
        return Iconsax.microphone;
      case 'link':
        return Iconsax.link;
      default:
        return Iconsax.document;
    }
  }

  String _getLabel() {
    switch (type) {
      case 'screenshot':
        return 'Screenshot';
      case 'photo':
        return 'Photo';
      case 'voice':
        return 'Voice';
      case 'link':
        return 'Link';
      default:
        return type;
    }
  }
}

class _ProcessingBadge extends StatelessWidget {
  final String status;

  const _ProcessingBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'failed' ? AppColors.error : AppColors.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == 'processing')
            const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            )
          else
            Icon(
              status == 'failed' ? Iconsax.close_circle : Iconsax.tick_circle,
              size: 12,
              color: Colors.black,
            ),
          const SizedBox(width: 4),
          Text(
            status == 'processing' ? 'Processing' : 'Failed',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.categoryColors[category] ?? AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
