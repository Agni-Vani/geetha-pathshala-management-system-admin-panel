import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_header.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../pathshala/domain/entities/pathshala.dart';
import '../../../person/domain/entities/teacher.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';

class AddPathshalaClassDialog extends StatefulWidget {
  final Pathshala pathshala;
  final List<Teacher> pathshalaTeachers;
  final List<AcademicProgram> programs;
  final Future<void> Function(CreateEducationalGroupParams params) onSave;

  const AddPathshalaClassDialog({
    super.key,
    required this.pathshala,
    required this.pathshalaTeachers,
    required this.programs,
    required this.onSave,
  });

  @override
  State<AddPathshalaClassDialog> createState() =>
      _AddPathshalaClassDialogState();
}

class _AddPathshalaClassDialogState extends State<AddPathshalaClassDialog> {
  final _nameController = TextEditingController(text: 'ক শাখা');
  final _roomController = TextEditingController(text: 'কক্ষ ১০১');
  final _capacityController = TextEditingController(text: '30');

  final _processNotifier = ProcessStatusNotifier(initialStatus: ProcessEnabled());

  AcademicProgram? _selectedProgram;
  AcademicLevel? _selectedLevel;
  Teacher? _selectedTeacher;

  @override
  void initState() {
    super.initState();
    if (widget.programs.isNotEmpty) {
      _selectedProgram = widget.programs.first;
      if (_selectedProgram!.levels.isNotEmpty) {
        _selectedLevel = _selectedProgram!.levels.first;
      }
    }
    if (widget.pathshalaTeachers.isNotEmpty) {
      _selectedTeacher = widget.pathshalaTeachers.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('শাখা বা ব্যাচের নাম দিন')),
      );
      return;
    }
    if (_selectedProgram == null || _selectedLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অনুগ্রহ করে প্রোগ্রাম এবং স্তর নির্বাচন করুন')),
      );
      return;
    }

    final capacity = int.tryParse(_capacityController.text.trim()) ?? 30;

    final params = CreateEducationalGroupParams(
      pathshalaId: widget.pathshala.id,
      academicYearId: 'ay-2026',
      programId: _selectedProgram!.id,
      levelId: _selectedLevel!.id,
      name: name,
      gradeLevel: _selectedLevel!.name,
      classTeacherId: _selectedTeacher?.id,
      classTeacherName: _selectedTeacher?.name,
      room: _roomController.text.trim().isEmpty ? null : _roomController.text.trim(),
      maxCapacity: capacity,
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
    final availableLevels = _selectedProgram?.levels ?? [];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: colors.backgroundColor,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
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
                      icon: Icons.meeting_room_outlined,
                      title: 'নতুন ক্লাস ও ব্যাচ খুলুন',
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
                'পাঠশালা: ${widget.pathshala.name}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: colors.dividerColor),
              const SizedBox(height: 16),

              // Program Selector
              Text(
                'একাডেমিক প্রোগ্রাম (Program) *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textColor,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.tileColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.dividerColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AcademicProgram>(
                    value: _selectedProgram,
                    isExpanded: true,
                    dropdownColor: colors.backgroundColor,
                    items: widget.programs.map((prog) {
                      return DropdownMenuItem(
                        value: prog,
                        child: Text(
                          '${prog.name} (${prog.levelTermLabel})',
                          style: TextStyle(fontSize: 13, color: colors.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedProgram = val;
                          _selectedLevel = val.levels.isNotEmpty ? val.levels.first : null;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Level Selector
              Text(
                '${_selectedProgram?.levelTermLabel ?? "স্তর"} (Level / Class) *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textColor,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.tileColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.dividerColor),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<AcademicLevel>(
                    value: _selectedLevel,
                    isExpanded: true,
                    dropdownColor: colors.backgroundColor,
                    items: availableLevels.map((lvl) {
                      return DropdownMenuItem(
                        value: lvl,
                        child: Text(
                          '${lvl.name} (${lvl.code})',
                          style: TextStyle(fontSize: 13, color: colors.textColor),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedLevel = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Section / Batch Name
              CustomFormField(
                label: 'শাখা / ব্যাচের নাম (Section / Batch)',
                hint: 'উদাঃ ক শাখা / মর্নিং ব্যাচ / Section A',
                controller: _nameController,
                isRequired: true,
              ),
              const SizedBox(height: 16),

              // Class Teacher Dropdown (RESTRICTED TO THIS PATHSHALA'S TEACHERS)
              Row(
                children: [
                  Text(
                    'শ্রেণি শিক্ষক (Class Teacher)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Tooltip(
                    message: 'কেবল এই পাঠশালায় বরাদ্দকৃত শিক্ষকদের মধ্য থেকে নির্বাচন করুন',
                    child: Icon(Icons.info_outline, size: 14, color: colors.hintColor),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              if (widget.pathshalaTeachers.isEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFD54F)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 18, color: Color(0xFFB8860B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'এই পাঠশালায় এখনো কোনো শিক্ষক বরাদ্দ করা হয়নি। ব্যক্তি রেজিস্ট্রি থেকে আগে শিক্ষক বরাদ্দ করুন।',
                          style: TextStyle(fontSize: 12, color: Colors.brown[800]),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colors.tileColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.dividerColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Teacher?>(
                      value: _selectedTeacher,
                      isExpanded: true,
                      dropdownColor: colors.backgroundColor,
                      items: [
                        DropdownMenuItem<Teacher?>(
                          value: null,
                          child: Text(
                            '— এখনো শিক্ষক বরাদ্দ নেই —',
                            style: TextStyle(fontSize: 13, color: colors.hintColor),
                          ),
                        ),
                        ...widget.pathshalaTeachers.map((teacher) {
                          return DropdownMenuItem<Teacher?>(
                            value: teacher,
                            child: Text(
                              '${teacher.name} (${teacher.subject.isNotEmpty ? teacher.subject : "সাধারণ"})',
                              style: TextStyle(fontSize: 13, color: colors.textColor),
                            ),
                          );
                        }),
                      ],
                      onChanged: (val) {
                        setState(() => _selectedTeacher = val);
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Room & Capacity
              Row(
                children: [
                  Expanded(
                    child: CustomFormField(
                      label: 'কক্ষ (Room)',
                      hint: 'উদাঃ কক্ষ ১০১',
                      controller: _roomController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomFormField(
                      label: 'ধারণক্ষমতা (Capacity)',
                      hint: 'উদাঃ 30',
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(color: colors.dividerColor),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'বাতিল',
                      style: TextStyle(color: colors.hintColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ListenableBuilder(
                    listenable: _processNotifier,
                    builder: (context, _) {
                      final isLoading =
                          _processNotifier.status is ProcessLoading;

                      return ElevatedButton(
                        onPressed: isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppSizes.rectangleButtonRadius,
                          ),
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
                                'ক্লাস খুলুন',
                                style: TextStyle(fontWeight: FontWeight.w600),
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
