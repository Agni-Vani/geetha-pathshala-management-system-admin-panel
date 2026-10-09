import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';

class AddLevelDialog extends StatefulWidget {
  final AcademicProgram program;
  final Future<void> Function(CreateAcademicLevelParams params) onSave;

  const AddLevelDialog({
    super.key,
    required this.program,
    required this.onSave,
  });

  @override
  State<AddLevelDialog> createState() => _AddLevelDialogState();
}

class _AddLevelDialogState extends State<AddLevelDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _codeController;
  late final TextEditingController _sequenceController;
  final _descController = TextEditingController();

  final _processNotifier = ProcessStatusNotifier(initialStatus: ProcessEnabled());

  @override
  void initState() {
    super.initState();
    final nextSeq = widget.program.levels.length + 1;
    _nameController = TextEditingController(
      text: '${widget.program.levelTermLabel} $nextSeq',
    );
    _codeController = TextEditingController(
      text: '${widget.program.code}-L$nextSeq',
    );
    _sequenceController = TextEditingController(text: nextSeq.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _sequenceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();
    final seqText = _sequenceController.text.trim();

    if (name.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অনুগ্রহ করে নাম এবং কোড পূরণ করুন')),
      );
      return;
    }

    final seq = int.tryParse(seqText) ?? (widget.program.levels.length + 1);

    final params = CreateAcademicLevelParams(
      programId: widget.program.id,
      name: name,
      code: code,
      sequence: seq,
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
        constraints: const BoxConstraints(maxWidth: 520),
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
                      icon: Icons.layers_outlined,
                      title: 'নতুন ${widget.program.levelTermLabel} যোগ করুন',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colors.hintColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'প্রোগ্রাম: ${widget.program.name}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Divider(color: colors.dividerColor),
              const SizedBox(height: 16),

              CustomFormField(
                label: '${widget.program.levelTermLabel}-এর নাম',
                hint: 'উদাঃ ${widget.program.levelTermLabel} ১ / ১ম শ্রেণি',
                controller: _nameController,
                isRequired: true,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      label: 'কোড (Code)',
                      hint: 'উদাঃ L-01',
                      controller: _codeController,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomFormField(
                      label: 'ক্রম (Order / Sequence)',
                      hint: 'উদাঃ 1, 2, 3',
                      controller: _sequenceController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomFormField(
                label: 'বিবরণ (Description)',
                hint: 'এই স্তরে পাঠ্য বিষয় বা শিখনফল',
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
                              : Text(
                                  '${widget.program.levelTermLabel} সংরক্ষণ করুন',
                                  style: const TextStyle(
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
