import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:recall_butler_client/recall_butler_client.dart';
import 'package:share_plus/share_plus.dart';

import '../../theme/colors.dart';

class CaptureDetailScreen extends ConsumerWidget {
  final Capture capture;

  const CaptureDetailScreen({super.key, required this.capture});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with image
          SliverAppBar(
            expandedHeight: _hasImage ? 300 : 0,
            pinned: true,
            flexibleSpace: _hasImage
                ? FlexibleSpaceBar(
                    background: Hero(
                      tag: 'capture_${capture.id}',
                      child: CachedNetworkImage(
                        imageUrl: capture.originalUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : null,
            actions: [
              IconButton(
                icon: const Icon(Iconsax.share),
                onPressed: () => _share(context),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'copy',
                    child: Row(
                      children: [
                        Icon(Iconsax.copy),
                        SizedBox(width: 12),
                        Text('Copy Text'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'collection',
                    child: Row(
                      children: [
                        Icon(Iconsax.folder_add),
                        SizedBox(width: 12),
                        Text('Add to Collection'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'copy') {
                    _copyText(context);
                  }
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type and Category
                  Row(
                    children: [
                      _TypeBadge(type: capture.type),
                      const SizedBox(width: 8),
                      _CategoryChip(category: capture.category),
                      const Spacer(),
                      if (capture.isReminder)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.alarm,
                                size: 14,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Reminder',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // AI Summary
                  if (capture.aiSummary != null) ...[
                    _SectionHeader(
                      icon: Iconsax.magic_star,
                      title: 'AI Summary',
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.secondary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        capture.aiSummary!,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Extracted Text
                  if (capture.extractedText != null &&
                      capture.extractedText!.isNotEmpty) ...[
                    _SectionHeader(
                      icon: Iconsax.document_text,
                      title: 'Extracted Text',
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SelectableText(
                        capture.extractedText!,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Tags
                  if (capture.tags != null) ...[
                    _SectionHeader(icon: Iconsax.tag, title: 'Tags'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _parseTags().map((tag) {
                        return Chip(
                          label: Text('#$tag'),
                          backgroundColor:
                              AppColors.primary.withOpacity(0.15),
                          labelStyle: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                          side: BorderSide.none,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Metadata
                  _SectionHeader(icon: Iconsax.info_circle, title: 'Details'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Iconsax.calendar,
                          label: 'Captured',
                          value: DateFormat('MMM d, yyyy • h:mm a')
                              .format(capture.createdAt),
                        ),
                        if (capture.sourceApp != null) ...[
                          const Divider(height: 24),
                          _DetailRow(
                            icon: Iconsax.mobile,
                            label: 'Source',
                            value: capture.sourceApp!,
                          ),
                        ],
                        const Divider(height: 24),
                        _DetailRow(
                          icon: Iconsax.status,
                          label: 'Status',
                          value: capture.processingStatus == 'completed'
                              ? 'Processed'
                              : capture.processingStatus,
                          valueColor: capture.processingStatus == 'completed'
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _hasImage =>
      (capture.type == 'screenshot' || capture.type == 'photo') &&
      capture.originalUrl != null;

  List<String> _parseTags() {
    try {
      return List<String>.from(jsonDecode(capture.tags!));
    } catch (e) {
      return [];
    }
  }

  void _share(BuildContext context) {
    final text = StringBuffer();
    if (capture.aiSummary != null) {
      text.writeln(capture.aiSummary);
    }
    if (capture.extractedText != null) {
      text.writeln('\n${capture.extractedText}');
    }
    text.writeln('\nCaptured with Recall Butler');

    Share.share(text.toString());
  }

  void _copyText(BuildContext context) {
    final text = capture.extractedText ?? capture.aiSummary ?? '';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard')),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            _getLabel(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
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
        return 'Voice Note';
      case 'link':
        return 'Link';
      default:
        return type;
    }
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.categoryColors[category] ?? AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
