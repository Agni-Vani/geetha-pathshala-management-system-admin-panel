import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/params/params.dart';

class AddProgramDialog extends StatefulWidget {
  final Future<void> Function(CreateAcademicProgramParams params) onSave;

  const AddProgramDialog({super.key, required this.onSave});

  @override
  State<AddProgramDialog> createState() => _AddProgramDialogState();
}

class _AddProgramDialogState extends State<AddProgramDialog> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _levelTermLabelController = TextEditingController(text: 'লেভেল');
  final _descController = TextEditingController();

  final _processNotifier = ProcessStatusNotifier(initialStatus: ProcessEnabled());

  static const List<String> _suggestedTermLabels = [
    'লেভেল',
    'শ্রেণি',
    'সেমিস্টার',
    'পর্ব',
    'পর্যায়',
    'গ্রেড',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _levelTermLabelController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();
    if (name.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অনুগ্রহ করে নাম এবং কোড পূরণ করুন')),
      );
      return;
    }

    final params = CreateAcademicProgramParams(
      name: name,
      code: code,
      levelTermLabel: _levelTermLabelController.text.trim().isEmpty
          ? 'লেভেল'
          : _levelTermLabelController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
    );

    _processNotifier.setLoading();
    try {
      await widget.onSave(params);
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) _processNotifier.setError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: colors.backgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomSectionHeader(
                      icon: Icons.school_outlined,
                      title: 'নতুন একাডেমি প্রোগ্রাম যোগ করুন',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colors.hintColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'প্রোগ্রামটির নাম এবং স্তর বিভাজনের একক (শ্রেণি, লেভেল, সেমিস্টার ইত্যাদি) নির্ধারণ করুন।',
                style: TextStyle(fontSize: 13, color: colors.hintColor),
              ),
              const SizedBox(height: 20),
              Divider(color: colors.dividerColor),
              const SizedBox(height: 16),

              CustomFormField(
                label: 'প্রোগ্রামের নাম (Program Name)',
                hint: 'উদাঃ গীতা পাঠশালা মৌলিক শিক্ষা / বিদ্যালয় পাঠ্যক্রম',
                controller: _nameController,
                isRequired: true,
              ),
              const SizedBox(height: 16),

              CustomFormField(
                label: 'প্রোগ্রাম কোড (Program Code)',
                hint: 'উদাঃ GITA-BASIC / SCH-GEN',
                controller: _codeController,
                isRequired: true,
              ),
              const SizedBox(height: 16),

              CustomFormField(
                label: 'স্তর বিভাজনের নাম (Division / Level Term)',
                hint: 'উদাঃ শ্রেণি / লেভেল / সেমিস্টার / পর্ব',
                controller: _levelTermLabelController,
                isRequired: true,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _suggestedTermLabels.map((term) {
                  final isSelected =
                      _levelTermLabelController.text.trim() == term;
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        _levelTermLabelController.text = term;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primaryColor.withValues(alpha: 0.15)
                            : colors.tileColor,
                        border: Border.all(
                          color: isSelected
                              ? colors.primaryColor
                              : colors.dividerColor,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        term,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? colors.primaryColor
                              : colors.textColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              CustomFormField(
                label: 'বিবরণ (Description)',
                hint: 'প্রোগ্রামের সংক্ষিপ্ত বিবরণ ও উদ্দেশ্য',
                controller: _descController,
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              Divider(color: colors.dividerColor),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    borderRadius: AppSizes.bigRectangleTileRadius,
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text(
                        'বাতিল',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.hintColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ListenableBuilder(
                    listenable: _processNotifier,
                    builder: (context, _) {
                      final isLoading =
                          _processNotifier.status is ProcessLoading;

                      return InkWell(
                        borderRadius: AppSizes.bigRectangleTileRadius,
                        onTap: isLoading ? null : _handleSubmit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                          decoration: BoxDecoration(
                            color: isLoading
                                ? colors.primaryColor.withValues(alpha: 0.6)
                                : colors.primaryColor,
                            borderRadius: AppSizes.bigRectangleTileRadius,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'প্রোগ্রাম সংরক্ষণ করুন',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
