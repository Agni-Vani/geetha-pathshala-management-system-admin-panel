import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_field_decoration.dart';
import '../../../pathshala/domain/pathshala_domain.dart';
import '../../../../core/shared/widget/custom_widgets/custom_date_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_divider.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_header.dart';
import '../../../../core/shared/widget/custom_widgets/custom_time_field.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../teachers/presentation/view/add_teacher_view.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/constants/app_sizes.dart';

// TODO: no list-teachers usecase is wired into the presentation layer yet
// (education domain only exposes createTeacherProfile/assignTeacher) — this
// stays local, design-stage data until that's connected.
const _baseTeachers = [
  TeacherOption(name: 'অনির্বাণ সেন', subject: 'শ্রীমদ্ভগবদ্গীতা'),
  TeacherOption(name: 'ইশিতা পাল', subject: 'সংস্কৃত'),
  TeacherOption(name: 'রমেশ শাস্ত্রী', subject: 'সংস্কৃত'),
  TeacherOption(name: 'সরস্বতী দেবী', subject: 'ভগবদ্গীতা'),
  TeacherOption(name: 'মহেশ শর্মা', subject: 'হিন্দি'),
];

class AddClassView extends StatefulWidget {
  final Pathshala pathshala;

  const AddClassView({super.key, required this.pathshala});

  @override
  State<AddClassView> createState() => _AddClassViewState();
}

class _AddClassViewState extends State<AddClassView> {
  final int _selectedIndex = 1;
  late final SnackbarNotifier snackbarNotifier;

  final _subjectController = TextEditingController();
  final _roomController = TextEditingController();

  final _formScrollController = ScrollController();

  final List<TeacherOption> _teacherOptions = List.of(_baseTeachers);

  DateTime? _classDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedTeacher;

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
  }

  @override
  void dispose() {
    _formScrollController.dispose();
    _subjectController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  bool get _isValid =>
      _subjectController.text.trim().isNotEmpty &&
      _classDate != null &&
      _startTime != null &&
      _selectedTeacher != null;

  // TODO: no class-schedule entity/usecase exists yet in the domain layer —
  // this just confirms the input and returns; wire it up to a real create
  // usecase once one is added.
  void _handleSave() {
    if (!_isValid) {
      snackbarNotifier.notifyError(message: 'Please fill in all required fields.');
      return;
    }

    snackbarNotifier.notifySuccess(message: 'Class added.');
    Navigator.of(context).pop();
  }

  Future<void> _addNewTeacher(StateSetter setSheetState) async {
    final teacher = await Navigator.of(context).push<TeacherOption>(
      MaterialPageRoute(builder: (_) => const AddTeacherView()),
    );
    if (teacher == null) return;

    setSheetState(() => _teacherOptions.add(teacher));
  }

  Future<void> _openTeacherPicker() async {
    final searchController = TextEditingController();

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        var query = '';

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final colors = AppColors.context(context);
            final filtered = _teacherOptions
                .where((teacher) => teacher.name.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
                decoration: BoxDecoration(
                  color: colors.backgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Select Teacher',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.textColor),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: colors.hintColor),
                            onPressed: () => Navigator.of(sheetContext).pop(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        onChanged: (value) => setSheetState(() => query = value),
                        style: TextStyle(fontSize: 13, color: colors.textColor),
                        decoration: AppFieldDecoration.build(context, hint: 'Search teacher...', prefix: Icons.search),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: filtered.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text('No teacher found', style: TextStyle(color: colors.hintColor)),
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              itemCount: filtered.length,
                              separatorBuilder: (_, _) => Divider(height: 1, color: colors.dividerColor),
                              itemBuilder: (context, index) {
                                final teacher = filtered[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                                    child: Icon(Icons.badge_outlined, size: 16, color: colors.primaryColor),
                                  ),
                                  title: Text(teacher.name, style: TextStyle(color: colors.textColor)),
                                  subtitle: teacher.subject == null
                                      ? null
                                      : Text(teacher.subject!, style: TextStyle(fontSize: 12, color: colors.hintColor)),
                                  onTap: () => Navigator.of(sheetContext).pop(teacher.name),
                                );
                              },
                            ),
                    ),
                    Divider(height: 1, color: colors.dividerColor),
                    InkWell(
                      onTap: () => _addNewTeacher(setSheetState),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            Icon(Icons.add_circle_outline, size: 18, color: colors.primaryColor),
                            const SizedBox(width: 10),
                            Text(
                              'Add New Teacher',
                              style: TextStyle(fontWeight: FontWeight.w600, color: colors.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    searchController.dispose();
    if (selected != null) setState(() => _selectedTeacher = selected);
  }

  Widget _buildTeacherField(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Teacher',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textColor),
            children: [TextSpan(text: ' *', style: TextStyle(color: colors.errorColor))],
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _openTeacherPicker,
          child: InputDecorator(
            decoration: AppFieldDecoration.build(
              context,
              hint: 'Select Teacher',
              prefix: Icons.badge_outlined,
              suffix: Icons.expand_more,
            ),
            child: Text(_selectedTeacher ?? '', style: TextStyle(fontSize: 13, color: colors.textColor)),
          ),
        ),
      ],
    );
  }

  Widget _fieldRow(List<Widget> fields) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 480) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < fields.length; i++) ...[
                fields[i],
                if (i != fields.length - 1) const SizedBox(height: 20),
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < fields.length; i++) ...[
              Expanded(child: fields[i]),
              if (i != fields.length - 1) const SizedBox(width: 24),
            ],
          ],
        );
      },
    );
  }

  Widget _buildFormActions() {
    final colors = AppColors.context(context);

    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 15,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          IntrinsicWidth(
            child: InkWell(
              borderRadius: AppSizes.rectangleButtonRadius,
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: AppSizes.rectangleButtonRadius,
                  border: Border.all(color: colors.primaryColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.primaryColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IntrinsicWidth(
            child: InkWell(
              borderRadius: AppSizes.rectangleButtonRadius,
              onTap: _handleSave,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: colors.primaryColor,
                  borderRadius: AppSizes.rectangleButtonRadius,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Center(
                    child: Text(
                      'Save Class',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return ResponsiveAppShell(
      selectedIndex: _selectedIndex,
      onItemSelected: _onSidebarItemSelected,
      onLogout: () => Navigator.of(context).maybePop(),
      topBarTitle: 'Overview',
      onTopBarBack: () => Navigator.of(context).maybePop(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: colors.tileColor,
              child: Scrollbar(
                controller: _formScrollController,
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(3),
                child: SingleChildScrollView(
                  controller: _formScrollController,
                  padding: AppSizes.pagePadding(context).copyWith(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Pathshalas', style: TextStyle(fontSize: 12, color: colors.hintColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.chevron_right, size: 14, color: colors.hintColor),
                          ),
                          Flexible(
                            child: Text(
                              widget.pathshala.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: colors.hintColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.chevron_right, size: 14, color: colors.hintColor),
                          ),
                          Expanded(
                            child: Text(
                              'Add Class',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: colors.hintColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Add Class',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: colors.primaryColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Schedule a new class for ${widget.pathshala.name}.',
                        style: TextStyle(color: colors.hintColor),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: colors.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomSectionHeader(icon: Icons.menu_book_outlined, title: 'Class Information'),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField(
                                  label: 'Subject',
                                  hint: 'e.g. শ্রীমদ্ভগবদ্গীতা',
                                  isRequired: true,
                                  controller: _subjectController,
                                  onTextChanged: (_) => setState(() {}),
                                ),
                                CustomFormField(
                                  label: 'Room',
                                  hint: 'e.g. Room 2',
                                  controller: _roomController,
                                ),
                              ]),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),
                              const CustomSectionHeader(icon: Icons.event_outlined, title: 'Schedule'),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomDateField(
                                  label: 'Class Date',
                                  isRequired: true,
                                  value: _classDate,
                                  onChanged: (value) => setState(() => _classDate = value),
                                ),
                                CustomTimeField(
                                  label: 'Start Time',
                                  isRequired: true,
                                  value: _startTime,
                                  onChanged: (value) => setState(() => _startTime = value),
                                ),
                                CustomTimeField(
                                  label: 'End Time',
                                  value: _endTime,
                                  onChanged: (value) => setState(() => _endTime = value),
                                ),
                              ]),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),
                              const CustomSectionHeader(icon: Icons.person_outline, title: 'Teacher'),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([_buildTeacherField(colors)]),
                              const SizedBox(height: 28),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 18),
                              _buildFormActions(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (MediaQuery.sizeOf(context).height >= 520)
            Container(
              color: colors.tileColor,
              height: 40,
              child: Center(
                child: Text(
                  '© 2024 Geetha Pathshala Management. All rights reserved.',
                  style: TextStyle(fontSize: 12, color: colors.hintColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
