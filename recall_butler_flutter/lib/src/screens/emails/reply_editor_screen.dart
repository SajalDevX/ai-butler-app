import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

import '../../providers/client_provider.dart';
import '../../theme/colors.dart';

class ReplyEditorScreen extends ConsumerStatefulWidget {
  final dynamic email;

  const ReplyEditorScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ReplyEditorScreen> createState() => _ReplyEditorScreenState();
}

class _ReplyEditorScreenState extends ConsumerState<ReplyEditorScreen> with TickerProviderStateMixin {
  late TextEditingController _replyController;
  late AnimationController _successController;
  late AnimationController _loadingController;
  bool _isLoading = false;
  bool _useAIDraft = true;
  String _selectedTone = 'professional'; // professional, casual, formal, friendly
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController(
      text: widget.email.draftReply ?? '',
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _replyController.dispose();
    _successController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reply'),
        actions: [
          if (_useAIDraft)
            IconButton(
              icon: const Icon(Iconsax.refresh),
              onPressed: _regenerateDraft,
              tooltip: 'Regenerate AI Draft',
            ),
        ],
      ),
      body: Column(
        children: [
          // Email context header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.surfaceLight,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // From
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _getInitial(widget.email.fromName ?? widget.email.fromEmail),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.email.fromName ?? widget.email.fromEmail,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.email.fromEmail,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Importance badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getImportanceColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${widget.email.importanceScore}/10',
                        style: TextStyle(
                          color: _getImportanceColor(),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Subject
                Text(
                  'Re: ${widget.email.subject}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Received time
                Row(
                  children: [
                    Icon(
                      Iconsax.clock,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Received ${timeago.format(widget.email.receivedAt)}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // AI Draft toggle & tone selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.surfaceLight,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.cpu,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _useAIDraft ? 'AI-Generated Draft' : 'Custom Reply',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Switch(
                      value: _useAIDraft,
                      onChanged: (value) {
                        setState(() {
                          _useAIDraft = value;
                          if (!value) {
                            _replyController.clear();
                          } else {
                            _replyController.text = widget.email.draftReply ?? '';
                          }
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),

                // Tone selector (only when AI draft is enabled)
                if (_useAIDraft) ...[
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _ToneChip(
                          label: 'Professional',
                          icon: Iconsax.briefcase,
                          isSelected: _selectedTone == 'professional',
                          onTap: () => setState(() => _selectedTone = 'professional'),
                        ),
                        _ToneChip(
                          label: 'Casual',
                          icon: Iconsax.message,
                          isSelected: _selectedTone == 'casual',
                          onTap: () => setState(() => _selectedTone = 'casual'),
                        ),
                        _ToneChip(
                          label: 'Formal',
                          icon: Iconsax.document_text,
                          isSelected: _selectedTone == 'formal',
                          onTap: () => setState(() => _selectedTone = 'formal'),
                        ),
                        _ToneChip(
                          label: 'Friendly',
                          icon: Iconsax.emoji_happy,
                          isSelected: _selectedTone == 'friendly',
                          onTap: () => setState(() => _selectedTone = 'friendly'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Editor
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _replyController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Type your reply here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.surfaceLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                ),
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(
                  color: AppColors.surfaceLight,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Word count
                Row(
                  children: [
                    Icon(
                      Iconsax.document_text,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_replyController.text.split(' ').where((w) => w.isNotEmpty).length} words',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _showOriginalEmail,
                      icon: const Icon(Iconsax.eye, size: 16),
                      label: const Text('View Original'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action buttons row
                Row(
                  children: [
                    // Schedule send
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _scheduleSend,
                        icon: const Icon(Iconsax.clock, size: 18),
                        label: const Text('Schedule'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Send now
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _sendNow,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Iconsax.send_1, size: 18),
                        label: Text(_isLoading ? 'Sending...' : 'Send Now'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitial(String text) {
    if (text.isEmpty) return '?';
    return text[0].toUpperCase();
  }

  Color _getImportanceColor() {
    if (widget.email.importanceScore >= 9) return AppColors.error;
    if (widget.email.importanceScore >= 7) return AppColors.warning;
    return AppColors.primary;
  }

  Future<void> _regenerateDraft() async {
    setState(() => _isLoading = true);

    try {
      final client = ref.read(clientProvider);

      // Call backend to regenerate draft with selected tone
      // This would be a new endpoint that takes the email and tone
      final result = await client.integration.generateEmailDraft(
        widget.email.gmailId,
        _selectedTone,
      );

      if (result.success && result.draftReply != null) {
        setState(() {
          _replyController.text = result.draftReply!;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Draft regenerated successfully!')),
          );
        }
      } else {
        throw Exception(result.error ?? 'Failed to regenerate draft');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendNow() async {
    if (_replyController.text.trim().isEmpty) {
      HapticFeedback.lightImpact();
      _showAnimatedSnackbar('Please write a reply first', isError: true);
      return;
    }

    HapticFeedback.mediumImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Iconsax.send_1, color: Colors.white, size: 32),
              ).animate().scale(duration: 200.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 20),
              const Text(
                'Send Email Now?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'This will send the email immediately',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context, false);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Send Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.8, 0.8)),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      final client = ref.read(clientProvider);

      final result = await client.integration.sendEmailReply(
        widget.email.gmailId,
        _replyController.text,
      );

      if (result.success) {
        HapticFeedback.heavyImpact();
        await _showSuccessAnimation('Email sent successfully!');
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        throw Exception(result.error ?? 'Failed to send email');
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        _showAnimatedSnackbar('Failed to send: $e', isError: true);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _scheduleSend() async {
    if (_replyController.text.trim().isEmpty) {
      HapticFeedback.lightImpact();
      _showAnimatedSnackbar('Please write a reply first', isError: true);
      return;
    }

    HapticFeedback.mediumImpact();
    final scheduledDateTime = await _showSchedulePicker();

    if (scheduledDateTime == null) return;

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      final client = ref.read(clientProvider);

      final result = await client.integration.scheduleEmailReply(
        widget.email.gmailId,
        _replyController.text,
        scheduledDateTime,
      );

      if (result.success) {
        HapticFeedback.heavyImpact();
        await _showSuccessAnimation('Email scheduled successfully!');
        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        throw Exception(result.error ?? 'Failed to schedule email');
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
      if (mounted) {
        _showAnimatedSnackbar('Failed to schedule: $e', isError: true);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<DateTime?> _showSchedulePicker() async {
    return await showModalBottomSheet<DateTime?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AnimatedSchedulePicker(),
    );
  }

  void _showAnimatedSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Iconsax.danger : Iconsax.tick_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _showSuccessAnimation(String message) async {
    setState(() => _showSuccess = true);
    _successController.forward();

    HapticFeedback.heavyImpact();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.tick_circle,
                  size: 48,
                  color: AppColors.success,
                ),
              ).animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              ).scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 500.ms,
              ),
              const SizedBox(height: 24),
              Text(
                'Success!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
    setState(() => _showSuccess = false);
    _successController.reset();
  }

  void _showOriginalEmail() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(Iconsax.sms, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Original Email',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.close_circle),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        widget.email.subject,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (widget.email.bodyText != null)
                        Text(
                          widget.email.bodyText!,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        )
                      else if (widget.email.snippet != null)
                        Text(
                          widget.email.snippet!,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedSchedulePicker extends StatefulWidget {
  const _AnimatedSchedulePicker();

  @override
  State<_AnimatedSchedulePicker> createState() => _AnimatedSchedulePickerState();
}

class _AnimatedSchedulePickerState extends State<_AnimatedSchedulePicker> {
  DateTime? _selectedDateTime;

  final List<Map<String, dynamic>> _quickOptions = [
    {
      'label': 'In 1 hour',
      'icon': Iconsax.clock,
      'offset': const Duration(hours: 1),
    },
    {
      'label': 'In 2 hours',
      'icon': Iconsax.clock,
      'offset': const Duration(hours: 2),
    },
    {
      'label': 'Tomorrow 9 AM',
      'icon': Iconsax.sun_1,
      'isCustom': true,
    },
    {
      'label': 'Tomorrow 2 PM',
      'icon': Iconsax.sun,
      'isCustom': true,
    },
    {
      'label': 'Next Monday 9 AM',
      'icon': Iconsax.calendar,
      'isCustom': true,
    },
    {
      'label': 'Custom time',
      'icon': Iconsax.calendar_edit,
      'isCustom': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Iconsax.clock, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Schedule Send',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose when to send this email',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 200.ms).slideX(begin: -0.2, end: 0),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _quickOptions.length,
              itemBuilder: (context, index) {
                final option = _quickOptions[index];
                return _ScheduleOptionCard(
                  label: option['label'],
                  icon: option['icon'],
                  onTap: () => _handleOptionTap(option),
                ).animate(delay: (index * 50).ms).fadeIn(duration: 200.ms).slideX(begin: -0.1, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleOptionTap(Map<String, dynamic> option) async {
    DateTime? dateTime;

    if (option['offset'] != null) {
      dateTime = DateTime.now().add(option['offset'] as Duration);
    } else if (option['label'] == 'Tomorrow 9 AM') {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      dateTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0);
    } else if (option['label'] == 'Tomorrow 2 PM') {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      dateTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 14, 0);
    } else if (option['label'] == 'Next Monday 9 AM') {
      var date = DateTime.now();
      while (date.weekday != DateTime.monday) {
        date = date.add(const Duration(days: 1));
      }
      dateTime = DateTime(date.year, date.month, date.day, 9, 0);
    } else if (option['label'] == 'Custom time') {
      final selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(hours: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );

      if (selectedDate != null && mounted) {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1))),
        );

        if (selectedTime != null) {
          dateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        }
      }
    }

    if (dateTime != null && mounted) {
      HapticFeedback.mediumImpact();
      Navigator.pop(context, dateTime);
    }
  }
}

class _ScheduleOptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ScheduleOptionCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.surfaceLight),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToneChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToneChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 12,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.surfaceLight,
        ),
      ),
    );
  }
}
