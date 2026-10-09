import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/custom_empty_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_field_decoration.dart';
import '../../../../di/service_locator.dart';
import '../../domain/entities/entities.dart';
import '../controller/academic_programs_controller.dart';
import 'add_level_dialog.dart';
import 'add_program_dialog.dart';

class AcademicProgramsManagementWidget extends StatefulWidget {
  final AcademicProgramsController? controller;

  const AcademicProgramsManagementWidget({super.key, this.controller});

  @override
  State<AcademicProgramsManagementWidget> createState() =>
      _AcademicProgramsManagementWidgetState();
}

class _AcademicProgramsManagementWidgetState
    extends State<AcademicProgramsManagementWidget> {
  late final AcademicProgramsController _controller;
  late final SnackbarNotifier _snackbarNotifier;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _snackbarNotifier = SnackbarNotifier(context: context);
    _controller = widget.controller ?? sl<AcademicProgramsController>();
    _controller.load(snackbarNotifier: _snackbarNotifier);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddProgramDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AddProgramDialog(
        onSave: (params) async {
          await _controller.addProgram(params, snackbarNotifier: _snackbarNotifier);
        },
      ),
    );
    if (result == true) {
      _snackbarNotifier.notifySuccess(message: 'একাডেমিক প্রোগ্রাম সফলভাবে তৈরি হয়েছে');
    }
  }

  Future<void> _openAddLevelDialog(AcademicProgram program) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AddLevelDialog(
        program: program,
        onSave: (params) async {
          await _controller.addLevel(params, snackbarNotifier: _snackbarNotifier);
        },
      ),
    );
    if (result == true) {
      _snackbarNotifier.notifySuccess(
        message: '${program.levelTermLabel} সফলভাবে যোগ করা হয়েছে',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final programs = _controller.filteredPrograms;
        final isLoading =
            _controller.processStatusNotifier.status is ProcessLoading;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 680;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(colors, isNarrow),
                const SizedBox(height: 16),
                _buildSearchBar(colors),
                const SizedBox(height: 20),
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(48.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (programs.isEmpty)
                  const CustomEmptyState(
                    icon: Icons.school_outlined,
                    title: 'কোনো একাডেমি প্রোগ্রাম পাওয়া যায়নি',
                    message:
                        'নতুন শিক্ষাক্রম ও স্তর তৈরির জন্য উপরের বোতামটি ব্যবহার করুন।',
                  )
                else
                  _buildProgramsList(colors, programs, isNarrow),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(AppColors colors, bool isNarrow) {
    final titleColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'একাডেমিক প্রোগ্রাম ও স্তর পরিচালনা',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'স্কুল (শ্রেণি ১–১০), পাঠশালা (লেভেল ১–৩), বা বিশ্ববিদ্যালয় (সেমিস্টার) অনুযায়ী যেকোনো শিক্ষাক্রম গতিশীলভাবে সাজান।',
          style: TextStyle(fontSize: 13, color: colors.hintColor),
        ),
      ],
    );

    final addButton = InkWell(
      onTap: _openAddProgramDialog,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: colors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 18, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'নতুন প্রোগ্রাম যোগ করুন',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleColumn,
          const SizedBox(height: 14),
          addButton,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: titleColumn),
        const SizedBox(width: 16),
        addButton,
      ],
    );
  }

  Widget _buildSearchBar(AppColors colors) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 480),
      child: TextField(
        controller: _searchController,
        onChanged: (val) => _controller.setSearchQuery(val),
        style: TextStyle(fontSize: 13, color: colors.textColor),
        decoration: AppFieldDecoration.build(
          context,
          hint: 'প্রোগ্রামের নাম বা কোড দিয়ে খুঁজুন...',
          prefix: Icons.search,
          suffix: _searchController.text.isNotEmpty
              ? Icons.clear
              : null,
        ),
      ),
    );
  }

  Widget _buildProgramsList(
    AppColors colors,
    List<AcademicProgram> programs,
    bool isNarrow,
  ) {
    return Column(
      children: programs.map((program) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.dividerColor),
            boxShadow: [
              BoxShadow(
                color: colors.shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.tileColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                      child: Icon(Icons.school, color: colors.primaryColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Text(
                                program.name,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textColor,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: colors.primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  program.code,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: colors.primaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'স্তর একক: ${program.levelTermLabel}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (program.description != null && program.description!.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              program.description!,
                              style: TextStyle(fontSize: 13, color: colors.hintColor),
                            ),
                          ],
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _openAddLevelDialog(program),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: colors.primaryColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, size: 16, color: colors.primaryColor),
                            const SizedBox(width: 6),
                            Text(
                              '+ ${program.levelTermLabel} যোগ',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.layers_outlined, size: 16, color: colors.hintColor),
                        const SizedBox(width: 6),
                        Text(
                          'নির্ধারিত ${program.levelTermLabel}-সমূহ (${program.levels.length} টি):',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.textColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (program.levels.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.tileColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 16, color: colors.hintColor),
                            const SizedBox(width: 8),
                            Text(
                              'এখনো কোনো ${program.levelTermLabel} যুক্ত করা হয়নি।',
                              style: TextStyle(fontSize: 12, color: colors.hintColor),
                            ),
                          ],
                        ),
                      )
                    else
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: program.levels.map((level) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: colors.tileColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: colors.dividerColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 11,
                                  backgroundColor: colors.primaryColor.withValues(alpha: 0.15),
                                  child: Text(
                                    '${level.sequence}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: colors.primaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  level.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: colors.textColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
