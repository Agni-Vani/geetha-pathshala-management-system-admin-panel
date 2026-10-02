import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../pathshala/domain/entities/pathshala.dart';
import '../../domain/entities/communication_enums.dart';
import '../../domain/entities/notice.dart';
import '../controller/notices_controller.dart';

class AddEditNoticeDialog extends StatefulWidget {
  final NoticesController controller;
  final Notice? notice;

  const AddEditNoticeDialog({
    super.key,
    required this.controller,
    this.notice,
  });

  static Future<bool?> show(
    BuildContext context, {
    required NoticesController controller,
    Notice? notice,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AddEditNoticeDialog(
        controller: controller,
        notice: notice,
      ),
    );
  }

  @override
  State<AddEditNoticeDialog> createState() => _AddEditNoticeDialogState();
}

class _AddEditNoticeDialogState extends State<AddEditNoticeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late NoticeStatus _status;
  String? _selectedPathshalaId;
  bool _isSubmitting = false;

  bool get isEditMode => widget.notice != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.notice?.title ?? '');
    _contentController = TextEditingController(text: widget.notice?.content ?? '');
    _status = widget.notice?.status ?? NoticeStatus.published;
    _selectedPathshalaId = widget.notice?.pathshalaId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final snackbar = SnackbarNotifier(context: context);

    bool success;
    if (isEditMode) {
      success = await widget.controller.updateExistingNotice(
        id: widget.notice!.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        status: _status,
        pathshalaId: _selectedPathshalaId,
        snackbarNotifier: snackbar,
      );
    } else {
      success = await widget.controller.createNewNotice(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        status: _status,
        pathshalaId: _selectedPathshalaId,
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
              isEditMode ? Icons.edit_outlined : Icons.campaign_outlined,
              color: colors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEditMode
                  ? 'নোটিশ সম্পাদনা (Edit Notice)'
                  : 'নতুন নোটিশ (New Notice)',
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
                    'শিরোনাম (Title) *',
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
                      hintText: 'যেমন: বার্ষিক পরীক্ষার সময়সূচী সংক্রান্ত নোটিশ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'শিরোনাম প্রদান করুন (Title is required)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'লক্ষ্য পাঠশালা (Target Pathshala)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String?>(
                    initialValue: _selectedPathshalaId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('সকল পাঠশালা (All Pathshalas)'),
                      ),
                      for (final Pathshala p in widget.controller.pathshalas)
                        DropdownMenuItem<String?>(
                          value: p.id,
                          child: Text(
                            '${p.name} (${p.code})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedPathshalaId = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'অবস্থা (Status)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<NoticeStatus>(
                    initialValue: _status,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: NoticeStatus.published,
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                            SizedBox(width: 8),
                            Text('প্রকাশিত (Published)'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: NoticeStatus.draft,
                        child: Row(
                          children: [
                            Icon(Icons.drafts_outlined, size: 16, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('খসড়া (Draft)'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: NoticeStatus.archived,
                        child: Row(
                          children: [
                            Icon(Icons.archive_outlined, size: 16, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('সংরক্ষিত (Archived)'),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _status = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'বিবরণ (Content) *',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _contentController,
                    minLines: 4,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'নোটিশের বিস্তারিত বিবরণ এখানে লিখুন...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(14),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'বিবরণ প্রদান করুন (Content is required)';
                      }
                      return null;
                    },
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
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
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
