import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/widget/process_notifier_button.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import '../../domain/person_domain.dart';
import '../controller/create_person_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/widget/custom_widgets/custom_date_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_divider.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_header.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/constants/app_sizes.dart';

class AddPersonRegistryView extends StatefulWidget {
  const AddPersonRegistryView({super.key});

  @override
  State<AddPersonRegistryView> createState() => _AddPersonRegistryViewState();
}

class _AddPersonRegistryViewState extends State<AddPersonRegistryView> {
  static const _genders = ['Male', 'Female', 'Other'];

  final int _selectedIndex = 3;
  CreatePersonController createPersonController =
      sl.get<CreatePersonController>();
  late final SnackbarNotifier snackbarNotifier;

  final _legalNameController = TextEditingController();
  final _preferredNameController = TextEditingController();
  final _primaryPhoneController = TextEditingController();
  final _primaryEmailController = TextEditingController();

  final _formScrollController = ScrollController();

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  @override
  void initState() {
    createPersonController.reset();
    snackbarNotifier = SnackbarNotifier(context: context);
    super.initState();
  }

  @override
  void dispose() {
    _formScrollController.dispose();
    _legalNameController.dispose();
    _preferredNameController.dispose();
    _primaryPhoneController.dispose();
    _primaryEmailController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!createPersonController.isValid) {
      snackbarNotifier.notifyError(
        message: 'Please fill in all required fields (Legal Name is required).',
      );
      return;
    }

    createPersonController.create(snackbarNotifier: snackbarNotifier);
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

  Widget _sectionHeaderWithAction({
    required IconData icon,
    required String title,
    required String buttonLabel,
    required VoidCallback onAdd,
    required AppColors colors,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 560;
        final header = CustomSectionHeader(icon: icon, title: title);
        final button = InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onAdd,
          child: Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: colors.primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 16, color: colors.primaryColor),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    buttonLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header,
              const SizedBox(height: 12),
              button,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: header),
            const SizedBox(width: 12),
            button,
          ],
        );
      },
    );
  }

  void _showAddEducationDialog() {
    final formKey = GlobalKey<FormState>();
    final colors = AppColors.context(context);
    final academicLevels = [
      'Primary (Class 1-5)',
      'Junior Secondary (Class 6-8)',
      'Secondary (SSC / Class 9-10)',
      'Higher Secondary (HSC)',
      'Diploma',
      'Bachelor / Honours / B.Sc / B.A',
      'Master / M.Sc / M.A',
      'Gita Shastri / Adhyayan',
      'Doctorate / Ph.D',
      'Other',
    ];

    String selectedLevel = academicLevels[2];
    final institutionCtrl = TextEditingController();
    final disciplineCtrl = TextEditingController();
    final boardCtrl = TextEditingController();
    final startYearCtrl = TextEditingController();
    final passingYearCtrl = TextEditingController();
    final resultCtrl = TextEditingController();
    final remarksCtrl = TextEditingController();
    bool isOngoing = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: colors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.school, color: colors.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Add Educational Qualification',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: colors.textColor,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: selectedLevel,
                          decoration: InputDecoration(
                            labelText: 'Academic Level *',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: academicLevels
                              .map(
                                (lvl) => DropdownMenuItem(
                                  value: lvl,
                                  child: Text(lvl),
                                ),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() => selectedLevel = val);
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: institutionCtrl,
                          decoration: InputDecoration(
                            labelText: 'Institution Name *',
                            hintText:
                                'e.g. Dhaka High School, University of Dhaka',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Institution name is required'
                                  : null,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: disciplineCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Discipline / Group',
                                  hintText: 'e.g. Science, Arts, General',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: boardCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Board / University',
                                  hintText:
                                      'e.g. Dhaka Board, National University',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: startYearCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Start Year',
                                  hintText: 'e.g. 2018',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: passingYearCtrl,
                                enabled: !isOngoing,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Passing Year',
                                  hintText: isOngoing ? 'Ongoing' : 'e.g. 2022',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Currently Studying Here (অধ্যয়নরত)',
                          ),
                          value: isOngoing,
                          activeColor: colors.primaryColor,
                          onChanged: (val) {
                            setDialogState(() {
                              isOngoing = val ?? false;
                              if (isOngoing) passingYearCtrl.clear();
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: resultCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Result / Grade / GPA',
                                  hintText: 'e.g. GPA 5.0, 1st Div',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: remarksCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Remarks',
                                  hintText: 'Optional notes',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: colors.hintColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      createPersonController.addEducation(
                        CreatePersonEducationParams(
                          personId: '',
                          academicLevel: selectedLevel,
                          institutionName: institutionCtrl.text.trim(),
                          disciplineOrGroup:
                              disciplineCtrl.text.trim().isEmpty
                                  ? null
                                  : disciplineCtrl.text.trim(),
                          governingBoard:
                              boardCtrl.text.trim().isEmpty
                                  ? null
                                  : boardCtrl.text.trim(),
                          startYear: int.tryParse(startYearCtrl.text.trim()),
                          passingYear:
                              isOngoing
                                  ? null
                                  : int.tryParse(passingYearCtrl.text.trim()),
                          isOngoing: isOngoing,
                          resultOrScore:
                              resultCtrl.text.trim().isEmpty
                                  ? null
                                  : resultCtrl.text.trim(),
                          remarks:
                              remarksCtrl.text.trim().isEmpty
                                  ? null
                                  : remarksCtrl.text.trim(),
                          createdByRoleAtTime: 'Registrar',
                          createdByNameSnapshot: 'Admin',
                        ),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text(
                    'Add Qualification',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddWorkExperienceDialog() {
    final formKey = GlobalKey<FormState>();
    final colors = AppColors.context(context);
    final engagementTypes = [
      'full_time',
      'part_time',
      'volunteer',
      'contract',
    ];
    final engagementLabels = {
      'full_time': 'Full-time (পূর্ণকালীন)',
      'part_time': 'Part-time (খণ্ডকালীন)',
      'volunteer': 'Volunteer (স্বেচ্ছাসেবী)',
      'contract': 'Contract (চুক্তিভিত্তিক)',
    };

    String selectedType = 'full_time';
    final orgCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    final deptCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final respCtrl = TextEditingController();
    DateTime startDate = DateTime.now();
    DateTime? endDate;
    bool isOngoing = true;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: colors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.work, color: colors.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Add Work / Volunteer Experience',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: colors.textColor,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 520,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: orgCtrl,
                          decoration: InputDecoration(
                            labelText: 'Organization / Institution Name *',
                            hintText:
                                'e.g. Geetha Pathshala Trust, Govt High School',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Organization name is required'
                                  : null,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: roleCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Role / Designation *',
                                  hintText: 'e.g. Teacher, Volunteer, Officer',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Role is required'
                                        : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: selectedType,
                                decoration: InputDecoration(
                                  labelText: 'Engagement Type',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: engagementTypes
                                    .map(
                                      (type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(
                                          engagementLabels[type] ?? type,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setDialogState(() => selectedType = val);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: deptCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Department / Unit',
                                  hintText: 'e.g. Academic, Youth, Admin',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: locationCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Location / City',
                                  hintText: 'e.g. Dhaka, Rangpur',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: startDate,
                                    firstDate: DateTime(1970),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                                  );
                                  if (picked != null) {
                                    setDialogState(() => startDate = picked);
                                  }
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Start Date *',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: InkWell(
                                onTap: isOngoing
                                    ? null
                                    : () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              endDate ?? DateTime.now(),
                                          firstDate: startDate,
                                          lastDate: DateTime.now().add(
                                            const Duration(days: 365),
                                          ),
                                        );
                                        if (picked != null) {
                                          setDialogState(() => endDate = picked);
                                        }
                                      },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'End Date',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    isOngoing
                                        ? 'Present / Ongoing (বর্তমান)'
                                        : (endDate != null
                                            ? '${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}'
                                            : 'Select End Date'),
                                    style: TextStyle(
                                      color: isOngoing
                                          ? colors.hintColor
                                          : colors.textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Currently Working Here (বর্তমানে কর্মরত)',
                          ),
                          value: isOngoing,
                          activeColor: colors.primaryColor,
                          onChanged: (val) {
                            setDialogState(() {
                              isOngoing = val ?? false;
                              if (isOngoing) endDate = null;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: respCtrl,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: 'Responsibilities / Notes',
                            hintText: 'Brief summary of key duties',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: colors.hintColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      createPersonController.addWorkExperience(
                        CreatePersonWorkExperienceParams(
                          personId: '',
                          organizationName: orgCtrl.text.trim(),
                          roleOrDesignation: roleCtrl.text.trim(),
                          departmentOrUnit:
                              deptCtrl.text.trim().isEmpty
                                  ? null
                                  : deptCtrl.text.trim(),
                          engagementType: selectedType,
                          location:
                              locationCtrl.text.trim().isEmpty
                                  ? null
                                  : locationCtrl.text.trim(),
                          startDate: startDate,
                          endDate: isOngoing ? null : endDate,
                          isOngoing: isOngoing,
                          responsibilities:
                              respCtrl.text.trim().isEmpty
                                  ? null
                                  : respCtrl.text.trim(),
                          createdByRoleAtTime: 'Registrar',
                          createdByNameSnapshot: 'Admin',
                        ),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text(
                    'Add Experience',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          RProcessNotifierButton(
            key: UniqueKey(),
            height: 50,
            width: 200,
            generalText: 'Save Person',
            loadingText: 'Saving Information',
            errorText: 'Error Saving Information',
            processStatusNotifier: createPersonController.processStatusNotifier,
            onSave: (processNotifier) => _handleSave(),
            onDone: () {
              Navigator.pop(context);
            },
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
                          Text(
                            'People',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.hintColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.chevron_right,
                              size: 14,
                              color: colors.hintColor,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Add New Person',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Add New Person',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Register a new person in the community directory with optional education and experience.',
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
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 1. General Information
                              const CustomSectionHeader(
                                icon: Icons.badge_outlined,
                                title: 'General Information',
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField(
                                  label: 'Legal Name',
                                  hint: 'e.g. Radha Krishna Das',
                                  isRequired: true,
                                  controller: _legalNameController,
                                  onTextChanged:
                                      createPersonController.onChangeLegalName,
                                ),
                                CustomFormField(
                                  label: 'Preferred Name',
                                  hint: 'e.g. Radhe',
                                  controller: _preferredNameController,
                                  onTextChanged: createPersonController
                                      .onChangePreferredName,
                                ),
                              ]),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),

                              // 2. Personal Details
                              const CustomSectionHeader(
                                icon: Icons.event_outlined,
                                title: 'Personal Details',
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              AnimatedBuilder(
                                animation: createPersonController,
                                builder: (context, _) => _fieldRow([
                                  CustomDateField(
                                    label: 'Date of Birth',
                                    value: createPersonController.dateOfBirth,
                                    onChanged: createPersonController
                                        .selectDateOfBirth,
                                  ),
                                  CustomFormField.dropdown(
                                    label: 'Gender',
                                    hint: 'Select Gender',
                                    items: _genders,
                                    value: createPersonController.gender,
                                    onChanged:
                                        createPersonController.selectGender,
                                  ),
                                ]),
                              ),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),

                              // 3. Contact Information
                              const CustomSectionHeader(
                                icon: Icons.contact_phone_outlined,
                                title: 'Contact Information',
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 20),
                              _fieldRow([
                                CustomFormField(
                                  label: 'Primary Phone',
                                  hint: '+880 1XXX-XXXXXX',
                                  prefixIcon: Icons.call_outlined,
                                  keyboardType: TextInputType.phone,
                                  controller: _primaryPhoneController,
                                  onTextChanged: createPersonController
                                      .onChangePrimaryPhone,
                                ),
                                CustomFormField(
                                  label: 'Primary Email',
                                  hint: 'name@example.com',
                                  prefixIcon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _primaryEmailController,
                                  onTextChanged: createPersonController
                                      .onChangePrimaryEmail,
                                ),
                              ]),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),

                              // 4. Educational Qualifications (Multiple)
                              _sectionHeaderWithAction(
                                icon: Icons.school_outlined,
                                title: 'Educational Qualifications (শিক্ষাগত যোগ্যতা) [ঐচ্ছিক]',
                                buttonLabel: '+ Add Qualification',
                                onAdd: _showAddEducationDialog,
                                colors: colors,
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 16),
                              AnimatedBuilder(
                                animation: createPersonController,
                                builder: (context, _) {
                                  final edus = createPersonController.educations;
                                  if (edus.isEmpty) {
                                    return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.softAccentColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: colors.ornamentColor.withValues(alpha: 0.4),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 18,
                                            color: colors.hintColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'কোনো শিক্ষাগত যোগ্যতা এখনও যোগ করা হয়নি। একাধিক ডিগ্রি বা শ্রেণি যোগ করতে "+ যোগ্যতা যোগ করুন" বোতামে চাপুন।',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: colors.hintColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return Column(
                                    children: [
                                      for (int i = 0; i < edus.length; i++) ...[
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: colors.backgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: colors.dividerColor,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: colors.softAccentColor,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.school,
                                                  size: 20,
                                                  color: colors.primaryColor,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            edus[i].academicLevel,
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 2,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: edus[i].isOngoing
                                                                ? Colors.blue.withValues(alpha: 0.15)
                                                                : Colors.green.withValues(alpha: 0.15),
                                                            borderRadius: BorderRadius.circular(4),
                                                          ),
                                                          child: Text(
                                                            edus[i].isOngoing
                                                                ? 'Ongoing (অধ্যয়নরত)'
                                                                : 'Passed ${edus[i].passingYear ?? ''}',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w600,
                                                              color: edus[i].isOngoing
                                                                  ? Colors.blue[800]
                                                                  : Colors.green[800],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      edus[i].institutionName,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: colors.textColor,
                                                      ),
                                                    ),
                                                    if (edus[i].disciplineOrGroup != null ||
                                                        edus[i].governingBoard != null ||
                                                        edus[i].resultOrScore != null) ...[
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        [
                                                          if (edus[i].disciplineOrGroup != null)
                                                            'Dept: ${edus[i].disciplineOrGroup}',
                                                          if (edus[i].governingBoard != null)
                                                            'Board: ${edus[i].governingBoard}',
                                                          if (edus[i].resultOrScore != null)
                                                            'Result: ${edus[i].resultOrScore}',
                                                        ].join(' • '),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: colors.hintColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color: colors.errorColor,
                                                  size: 20,
                                                ),
                                                tooltip: 'Remove',
                                                onPressed: () => createPersonController.removeEducation(i),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),

                              // 5. Work & Volunteer Experience (Multiple)
                              _sectionHeaderWithAction(
                                icon: Icons.work_outline,
                                title: 'Work & Volunteer Experience (কাজের অভিজ্ঞতা) [ঐচ্ছিক]',
                                buttonLabel: '+ Add Experience',
                                onAdd: _showAddWorkExperienceDialog,
                                colors: colors,
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 16),
                              AnimatedBuilder(
                                animation: createPersonController,
                                builder: (context, _) {
                                  final exps = createPersonController.workExperiences;
                                  if (exps.isEmpty) {
                                    return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.softAccentColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: colors.ornamentColor.withValues(alpha: 0.4),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 18,
                                            color: colors.hintColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'কোনো কাজের অভিজ্ঞতা এখনও যোগ করা হয়নি। একাধিক অভিজ্ঞতা যোগ করতে "+ অভিজ্ঞতা যোগ করুন" বোতামে চাপুন।',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: colors.hintColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return Column(
                                    children: [
                                      for (int i = 0; i < exps.length; i++) ...[
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: colors.backgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: colors.dividerColor,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: colors.softAccentColor,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.business_center,
                                                  size: 20,
                                                  color: colors.primaryColor,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            exps[i].roleOrDesignation,
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 2,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: colors.primaryColor.withValues(alpha: 0.1),
                                                            borderRadius: BorderRadius.circular(4),
                                                          ),
                                                          child: Text(
                                                            exps[i].engagementType.replaceAll('_', ' ').toUpperCase(),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight: FontWeight.w600,
                                                              color: colors.primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      exps[i].organizationName,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: colors.textColor,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      '${exps[i].startDate.year}-${exps[i].startDate.month.toString().padLeft(2, '0')} → ${exps[i].isOngoing ? 'Present (বর্তমান)' : (exps[i].endDate != null ? '${exps[i].endDate!.year}-${exps[i].endDate!.month.toString().padLeft(2, '0')}' : '')}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: colors.hintColor,
                                                      ),
                                                    ),
                                                    if (exps[i].responsibilities != null &&
                                                        exps[i].responsibilities!.isNotEmpty) ...[
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        exps[i].responsibilities!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: colors.hintColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color: colors.errorColor,
                                                  size: 20,
                                                ),
                                                tooltip: 'Remove',
                                                onPressed: () => createPersonController.removeWorkExperience(i),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),
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
