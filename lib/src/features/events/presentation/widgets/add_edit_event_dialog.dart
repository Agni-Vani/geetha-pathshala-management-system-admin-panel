import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../pathshala/domain/entities/pathshala.dart';
import '../../domain/entities/event.dart';
import '../controller/events_controller.dart';

class AddEditEventDialog extends StatefulWidget {
  final EventsController controller;
  final Event? event;

  const AddEditEventDialog({
    super.key,
    required this.controller,
    this.event,
  });

  static Future<bool?> show(
    BuildContext context, {
    required EventsController controller,
    Event? event,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AddEditEventDialog(
        controller: controller,
        event: event,
      ),
    );
  }

  @override
  State<AddEditEventDialog> createState() => _AddEditEventDialogState();
}

class _AddEditEventDialogState extends State<AddEditEventDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _timeController;
  late DateTime _selectedDate;
  late String _selectedScope;
  String? _selectedPathshalaId;
  late String _selectedIconName;
  bool _isSubmitting = false;

  bool get isEditMode => widget.event != null;

  static const List<(String, String, IconData)> _availableIcons = [
    ('celebration_outlined', 'উৎসব (Festival)', Icons.celebration_outlined),
    ('menu_book_outlined', 'পাঠ/পরীক্ষা (Study)', Icons.menu_book_outlined),
    ('auto_awesome_outlined', 'বিশেষ (Special)', Icons.auto_awesome_outlined),
    ('local_florist_outlined', 'পূজা (Puja)', Icons.local_florist_outlined),
    ('event_outlined', 'সাধারণ (General)', Icons.event_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(text: widget.event?.description ?? '');
    _timeController = TextEditingController(text: widget.event?.time ?? 'সকাল ১০:০০');
    _selectedDate = widget.event?.eventDate ?? DateTime.now().add(const Duration(days: 7));
    _selectedScope = widget.event?.scope ?? 'All Pathshalas';
    _selectedIconName = widget.event?.iconName ?? 'celebration_outlined';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = [
      'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
      'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
    ];
    final bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String bn(int num) => num.toString().split('').map((c) => bnDigits[int.parse(c)]).join();
    return '${bn(date.day)} ${months[date.month - 1]}, ${bn(date.year)}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final snackbar = SnackbarNotifier(context: context);

    bool success;
    if (isEditMode) {
      success = await widget.controller.updateExistingEvent(
        id: widget.event!.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        eventDate: _selectedDate,
        time: _timeController.text.trim(),
        scope: _selectedScope,
        pathshalaId: _selectedPathshalaId,
        iconName: _selectedIconName,
        snackbarNotifier: snackbar,
      );
    } else {
      success = await widget.controller.createNewEvent(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        eventDate: _selectedDate,
        time: _timeController.text.trim(),
        scope: _selectedScope,
        pathshalaId: _selectedPathshalaId,
        iconName: _selectedIconName,
        snackbarNotifier: snackbar,
      );
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) {
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final isNarrow = MediaQuery.of(context).size.width < 600;

    return AlertDialog(
      backgroundColor: colors.backgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
            child: Icon(
              isEditMode ? Icons.edit_calendar_outlined : Icons.event_available_outlined,
              color: colors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEditMode
                  ? 'অনুষ্ঠান সম্পাদনা (Edit Event)'
                  : 'নতুন অনুষ্ঠান যুক্ত করুন (Add Event)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.textColor,
              ),
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: SizedBox(
          width: isNarrow ? double.maxFinite : 520,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'অনুষ্ঠানের নাম (Event Title) *',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'যেমন: শ্রীকৃষ্ণ জন্মাষ্টমী উৎসব ২০২৬',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'অনুষ্ঠানের নাম লিখুন (Event title is required)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'বিবরণ (Description)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 2,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'অনুষ্ঠানের কার্যক্রম ও সংক্ষিপ্ত তথ্য...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'অনুষ্ঠানের তারিখ (Date) *',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colors.textColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: _pickDate,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: colors.hintColor.withValues(alpha: 0.3)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today_outlined, size: 16, color: colors.primaryColor),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _formatDate(_selectedDate),
                                        style: TextStyle(fontSize: 13, color: colors.textColor),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'সময় (Time)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colors.textColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _timeController,
                              decoration: InputDecoration(
                                hintText: 'সকাল ১০:০০',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                prefixIcon: Icon(Icons.schedule_outlined, size: 16, color: colors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'আওতা / পাঠশালা (Scope)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedScope,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: 'All Pathshalas',
                        child: Text('সকল পাঠশালা (All Pathshalas)'),
                      ),
                      for (final Pathshala p in widget.controller.pathshalas)
                        DropdownMenuItem(
                          value: p.name,
                          child: Text(
                            '${p.name} (${p.code})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedScope = val;
                          final match = widget.controller.pathshalas.where((p) => p.name == val);
                          _selectedPathshalaId = match.isNotEmpty ? match.first.id : null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'আইকন নির্বাচন করুন (Spiritual Icon)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableIcons.map((item) {
                      final isSelected = _selectedIconName == item.$1;
                      return ChoiceChip(
                        avatar: Icon(
                          item.$3,
                          size: 16,
                          color: isSelected ? Colors.white : colors.primaryColor,
                        ),
                        label: Text(
                          item.$2,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : colors.textColor,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: colors.primaryColor,
                        backgroundColor: colors.tileColor,
                        onSelected: (_) => setState(() => _selectedIconName = item.$1),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: Text(
            'বাতিল (Cancel)',
            style: TextStyle(color: colors.hintColor),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: _isSubmitting ? null : _handleSubmit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  isEditMode ? 'আপডেট করুন' : 'সংরক্ষণ করুন',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
