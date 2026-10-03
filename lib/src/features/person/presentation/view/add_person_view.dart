import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/core/config/app_config.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/widget/process_notifier_button.dart';
import 'package:geetha_pathshala_management_web/src/core/utils/utils.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import '../../domain/person_domain.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/widget/custom_widgets/custom_date_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_divider.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_header.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/constants/app_sizes.dart';

/// Unified editable representation of an educational qualification item.
class EditableEducationItem {
  final String? id; // non-null when loaded from DB, null for newly added draft
  final String academicLevel;
  final String institutionName;
  final String? disciplineOrGroup;
  final String? governingBoard;
  final int? startYear;
  final int? passingYear;
  final bool isOngoing;
  final String? resultOrScore;
  final String? remarks;

  EditableEducationItem({
    this.id,
    required this.academicLevel,
    required this.institutionName,
    this.disciplineOrGroup,
    this.governingBoard,
    this.startYear,
    this.passingYear,
    this.isOngoing = false,
    this.resultOrScore,
    this.remarks,
  });

  factory EditableEducationItem.fromEntity(PersonEducation entity) {
    return EditableEducationItem(
      id: entity.id,
      academicLevel: entity.academicLevel,
      institutionName: entity.institutionName,
      disciplineOrGroup: entity.disciplineOrGroup,
      governingBoard: entity.governingBoard,
      startYear: entity.startYear,
      passingYear: entity.passingYear,
      isOngoing: entity.isOngoing,
      resultOrScore: entity.resultOrScore,
      remarks: entity.remarks,
    );
  }

  CreatePersonEducationParams toCreateParams({required String personId}) {
    return CreatePersonEducationParams(
      personId: personId,
      academicLevel: academicLevel,
      institutionName: institutionName,
      disciplineOrGroup: disciplineOrGroup,
      governingBoard: governingBoard,
      startYear: startYear,
      passingYear: passingYear,
      isOngoing: isOngoing,
      resultOrScore: resultOrScore,
      remarks: remarks,
      createdByRoleAtTime: 'Registrar',
      createdByNameSnapshot: 'Admin',
    );
  }
}

/// Unified editable representation of a work/volunteer experience item.
class EditableWorkExperienceItem {
  final String? id; // non-null when loaded from DB, null for newly added draft
  final String organizationName;
  final String roleOrDesignation;
  final String? departmentOrUnit;
  final String engagementType;
  final String? location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isOngoing;
  final String? responsibilities;

  EditableWorkExperienceItem({
    this.id,
    required this.organizationName,
    required this.roleOrDesignation,
    this.departmentOrUnit,
    required this.engagementType,
    this.location,
    required this.startDate,
    this.endDate,
    this.isOngoing = true,
    this.responsibilities,
  });

  factory EditableWorkExperienceItem.fromEntity(PersonWorkExperience entity) {
    return EditableWorkExperienceItem(
      id: entity.id,
      organizationName: entity.organizationName,
      roleOrDesignation: entity.roleOrDesignation,
      departmentOrUnit: entity.departmentOrUnit,
      engagementType: entity.engagementType,
      location: entity.location,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isOngoing: entity.isOngoing,
      responsibilities: entity.responsibilities,
    );
  }

  CreatePersonWorkExperienceParams toCreateParams({required String personId}) {
    return CreatePersonWorkExperienceParams(
      personId: personId,
      organizationName: organizationName,
      roleOrDesignation: roleOrDesignation,
      departmentOrUnit: departmentOrUnit,
      engagementType: engagementType,
      location: location,
      startDate: startDate,
      endDate: endDate,
      isOngoing: isOngoing,
      responsibilities: responsibilities,
      createdByRoleAtTime: 'Registrar',
      createdByNameSnapshot: 'Admin',
    );
  }
}

class AddPersonRegistryView extends StatefulWidget {
  final Person? existingPerson;

  const AddPersonRegistryView({super.key, this.existingPerson});

  @override
  State<AddPersonRegistryView> createState() => _AddPersonRegistryViewState();
}

class _AddPersonRegistryViewState extends State<AddPersonRegistryView> {
  static const _genders = ['Male', 'Female', 'Other'];

  final int _selectedIndex = 3;
  late final SnackbarNotifier snackbarNotifier;
  final ProcessStatusNotifier _processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());

  final _legalNameController = TextEditingController();
  final _preferredNameController = TextEditingController();
  final _primaryPhoneController = TextEditingController();
  final _primaryEmailController = TextEditingController();

  DateTime? _dateOfBirth;
  String? _gender;
  PersonStatus _status = PersonStatus.active;

  final List<EditableEducationItem> _educations = [];
  final List<EditableWorkExperienceItem> _workExperiences = [];
  bool _isLoadingExistingData = false;

  final _formScrollController = ScrollController();

  bool get _isEditing => widget.existingPerson != null;

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);

    if (widget.existingPerson != null) {
      final person = widget.existingPerson!;
      _legalNameController.text = person.legalName;
      _preferredNameController.text = person.preferredName ?? '';
      _primaryPhoneController.text = person.primaryPhone ?? '';
      _primaryEmailController.text = person.primaryEmail ?? '';
      _dateOfBirth = person.dateOfBirth;
      if (person.gender != null) {
        final match = _genders.where(
          (g) => g.toLowerCase() == person.gender!.trim().toLowerCase(),
        );
        _gender = match.isNotEmpty ? match.first : person.gender;
      }
      _status = person.status;
      _loadExistingDetails(person.id);
    }
  }

  Future<void> _loadExistingDetails(String personId) async {
    setState(() => _isLoadingExistingData = true);
    final eduFuture = sl<GetPersonEducations>().call(personId);
    final expFuture = sl<GetPersonWorkExperiences>().call(personId);
    final results = await Future.wait([eduFuture, expFuture]);

    if (mounted) {
      setState(() {
        _isLoadingExistingData = false;
        final eduRes = results[0];
        if (eduRes is SuccessRepoCall<List<PersonEducation>> && eduRes.data != null) {
          _educations.clear();
          _educations.addAll(eduRes.data!.map(EditableEducationItem.fromEntity));
        }
        final expRes = results[1];
        if (expRes is SuccessRepoCall<List<PersonWorkExperience>> && expRes.data != null) {
          _workExperiences.clear();
          _workExperiences.addAll(
            expRes.data!.map(EditableWorkExperienceItem.fromEntity),
          );
        }
      });
    }
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

  Future<void> _handleSave() async {
    final legalName = _legalNameController.text.trim();
    if (legalName.isEmpty) {
      snackbarNotifier.notifyError(
        message: 'Please fill in all required fields (Legal Name is required).',
      );
      return;
    }

    if (!_isEditing) {
      final params = CreatePersonParams(
        organizationId: AppConfig.defaultOrganizationId,
        legalName: legalName,
        preferredName: _preferredNameController.text.trim().isEmpty
            ? null
            : _preferredNameController.text.trim(),
        dateOfBirth: _dateOfBirth,
        gender: _gender,
        primaryPhone: _primaryPhoneController.text.trim().isEmpty
            ? null
            : _primaryPhoneController.text.trim(),
        primaryEmail: _primaryEmailController.text.trim().isEmpty
            ? null
            : _primaryEmailController.text.trim(),
        educations: _educations
            .map((e) => e.toCreateParams(personId: ''))
            .toList(),
        workExperiences: _workExperiences
            .map((e) => e.toCreateParams(personId: ''))
            .toList(),
      );

      await handleFutureRequest(
        request: () => sl<CreatePerson>().call(params),
        processStatusNotifier: _processStatusNotifier,
        errorSnackbarNotifier: snackbarNotifier,
        successSnackbarNotifier: snackbarNotifier,
      );
    } else {
      final personId = widget.existingPerson!.id;
      final updateParams = UpdatePersonParams(
        personId: personId,
        legalName: legalName,
        preferredName: _preferredNameController.text.trim().isEmpty
            ? null
            : _preferredNameController.text.trim(),
        dateOfBirth: _dateOfBirth,
        gender: _gender,
        primaryPhone: _primaryPhoneController.text.trim().isEmpty
            ? null
            : _primaryPhoneController.text.trim(),
        primaryEmail: _primaryEmailController.text.trim().isEmpty
            ? null
            : _primaryEmailController.text.trim(),
        status: _status,
      );

      await handleFutureRequest(
        request: () async {
          // 1. Update core person info
          final updateRes = await sl<UpdatePerson>().call(updateParams);
          if (updateRes is! SuccessRepoCall) {
            return updateRes;
          }

          // 2. Persist any newly added qualifications
          for (final edu in _educations.where((e) => e.id == null)) {
            final eduRes = await sl<AddPersonEducation>().call(
              edu.toCreateParams(personId: personId),
            );
            if (eduRes is! SuccessRepoCall) {
              return FailedRepoCall<Person>(
                message: eduRes.message,
                exception: eduRes is FailedRepoCall<PersonEducation>
                    ? eduRes.exception
                    : Exception(eduRes.message),
                stackTrace: eduRes is FailedRepoCall<PersonEducation>
                    ? eduRes.stackTrace
                    : StackTrace.current,
              );
            }
          }

          // 3. Persist any newly added work experiences
          for (final exp in _workExperiences.where((e) => e.id == null)) {
            final expRes = await sl<AddPersonWorkExperience>().call(
              exp.toCreateParams(personId: personId),
            );
            if (expRes is! SuccessRepoCall) {
              return FailedRepoCall<Person>(
                message: expRes.message,
                exception: expRes is FailedRepoCall<PersonWorkExperience>
                    ? expRes.exception
                    : Exception(expRes.message),
                stackTrace: expRes is FailedRepoCall<PersonWorkExperience>
                    ? expRes.stackTrace
                    : StackTrace.current,
              );
            }
          }

          return updateRes;
        },
        processStatusNotifier: _processStatusNotifier,
        errorSnackbarNotifier: snackbarNotifier,
        successSnackbarNotifier: snackbarNotifier,
      );
    }
  }

  Future<void> _handleDeleteEducation(int index) async {
    final item = _educations[index];
    if (item.id == null) {
      setState(() {
        _educations.removeAt(index);
      });
      snackbarNotifier.notifySuccess(message: 'Qualification removed.');
      return;
    }

    final colors = AppColors.context(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: colors.errorColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Delete Qualification',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colors.textColor,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently delete "${item.academicLevel} - ${item.institutionName}" from this person\'s profile?',
          style: TextStyle(color: colors.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: colors.hintColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.errorColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final response = await sl<DeletePersonEducation>().call(item.id!);
      if (mounted) {
        if (response is SuccessRepoCall) {
          setState(() {
            _educations.removeAt(index);
          });
          snackbarNotifier.notifySuccess(message: 'Educational qualification deleted successfully.');
        } else {
          snackbarNotifier.notifyError(message: response.message);
        }
      }
    }
  }

  Future<void> _handleDeleteWorkExperience(int index) async {
    final item = _workExperiences[index];
    if (item.id == null) {
      setState(() {
        _workExperiences.removeAt(index);
      });
      snackbarNotifier.notifySuccess(message: 'Experience removed.');
      return;
    }

    final colors = AppColors.context(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: colors.errorColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Delete Work Experience',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colors.textColor,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to permanently delete "${item.roleOrDesignation} at ${item.organizationName}" from this person\'s profile?',
          style: TextStyle(color: colors.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: colors.hintColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.errorColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final response = await sl<DeletePersonWorkExperience>().call(item.id!);
      if (mounted) {
        if (response is SuccessRepoCall) {
          setState(() {
            _workExperiences.removeAt(index);
          });
          snackbarNotifier.notifySuccess(message: 'Work experience deleted successfully.');
        } else {
          snackbarNotifier.notifyError(message: response.message);
        }
      }
    }
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
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
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
                      setState(() {
                        _educations.add(
                          EditableEducationItem(
                            academicLevel: selectedLevel,
                            institutionName: institutionCtrl.text.trim(),
                            disciplineOrGroup: disciplineCtrl.text.trim().isEmpty
                                ? null
                                : disciplineCtrl.text.trim(),
                            governingBoard: boardCtrl.text.trim().isEmpty
                                ? null
                                : boardCtrl.text.trim(),
                            startYear: int.tryParse(startYearCtrl.text.trim()),
                            passingYear: isOngoing
                                ? null
                                : int.tryParse(passingYearCtrl.text.trim()),
                            isOngoing: isOngoing,
                            resultOrScore: resultCtrl.text.trim().isEmpty
                                ? null
                                : resultCtrl.text.trim(),
                            remarks: remarksCtrl.text.trim().isEmpty
                                ? null
                                : remarksCtrl.text.trim(),
                          ),
                        );
                      });
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
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
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
                      setState(() {
                        _workExperiences.add(
                          EditableWorkExperienceItem(
                            organizationName: orgCtrl.text.trim(),
                            roleOrDesignation: roleCtrl.text.trim(),
                            departmentOrUnit: deptCtrl.text.trim().isEmpty
                                ? null
                                : deptCtrl.text.trim(),
                            engagementType: selectedType,
                            location: locationCtrl.text.trim().isEmpty
                                ? null
                                : locationCtrl.text.trim(),
                            startDate: startDate,
                            endDate: isOngoing ? null : endDate,
                            isOngoing: isOngoing,
                            responsibilities: respCtrl.text.trim().isEmpty
                                ? null
                                : respCtrl.text.trim(),
                          ),
                        );
                      });
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
            generalText: _isEditing ? 'Update Person' : 'Save Person',
            loadingText:
                _isEditing ? 'Updating Information' : 'Saving Information',
            errorText: _isEditing
                ? 'Error Updating Information'
                : 'Error Saving Information',
            processStatusNotifier: _processStatusNotifier,
            onSave: (processNotifier) => _handleSave(),
            onDone: () {
              Navigator.pop(context, true);
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
                      AppBreadcrumbs(
                        items: [
                          BreadcrumbItem.home(context),
                          BreadcrumbItem(
                            label: 'ব্যক্তি রেজিস্ট্রি',
                            icon: Icons.person_outline,
                            onTap: () => Navigator.of(context).maybePop(),
                          ),
                          BreadcrumbItem(
                            label: _isEditing
                                ? 'ব্যক্তি তথ্য সম্পাদন'
                                : 'নতুন ব্যক্তি নিবন্ধন',
                          ),
                        ],
                      ),
                      Text(
                        _isEditing ? 'Edit Person' : 'Add New Person',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isEditing
                            ? 'ব্যক্তির তথ্য এবং শিক্ষাগত যোগ্যতা ও কাজের অভিজ্ঞতা সম্পাদন ও পরিচালনা করুন।'
                            : 'Register a new person in the community directory with optional education and experience.',
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
                                ),
                                CustomFormField(
                                  label: 'Preferred Name',
                                  hint: 'e.g. Radhe',
                                  controller: _preferredNameController,
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
                              _fieldRow([
                                CustomDateField(
                                  label: 'Date of Birth',
                                  value: _dateOfBirth,
                                  onChanged: (d) =>
                                      setState(() => _dateOfBirth = d),
                                ),
                                CustomFormField.dropdown(
                                  label: 'Gender',
                                  hint: 'Select Gender',
                                  items: _genders,
                                  value: _gender,
                                  onChanged: (g) =>
                                      setState(() => _gender = g),
                                ),
                                if (_isEditing)
                                  CustomFormField.dropdown(
                                    label: 'Status (অবস্থা)',
                                    hint: 'Select Status',
                                    items: const ['Active', 'Inactive'],
                                    value: _status == PersonStatus.active
                                        ? 'Active'
                                        : 'Inactive',
                                    onChanged: (s) {
                                      setState(() {
                                        _status = (s == 'Inactive')
                                            ? PersonStatus.inactive
                                            : PersonStatus.active;
                                      });
                                    },
                                  ),
                              ]),
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
                                ),
                                CustomFormField(
                                  label: 'Primary Email',
                                  hint: 'name@example.com',
                                  prefixIcon: Icons.mail_outline,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _primaryEmailController,
                                ),
                              ]),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),

                              // 4. Educational Qualifications (Multiple)
                              _sectionHeaderWithAction(
                                icon: Icons.school_outlined,
                                title:
                                    'Educational Qualifications (শিক্ষাগত যোগ্যতা) [ঐচ্ছিক]',
                                buttonLabel: '+ Add Qualification',
                                onAdd: _showAddEducationDialog,
                                colors: colors,
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 16),
                              if (_isLoadingExistingData)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24,
                                    ),
                                    child: CircularProgressIndicator(
                                      color: colors.primaryColor,
                                    ),
                                  ),
                                )
                              else if (_educations.isEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.softAccentColor.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: colors.ornamentColor.withValues(
                                        alpha: 0.4,
                                      ),
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
                                )
                              else
                                Column(
                                  children: [
                                    for (
                                      int i = 0;
                                      i < _educations.length;
                                      i++
                                    ) ...[
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: colors.backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: colors.dividerColor,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: colors.softAccentColor,
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          _educations[i]
                                                              .academicLevel,
                                                          style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 2,
                                                            ),
                                                        decoration:
                                                            BoxDecoration(
                                                              color: _educations[i]
                                                                      .isOngoing
                                                                  ? Colors.blue
                                                                      .withValues(
                                                                        alpha:
                                                                            0.15,
                                                                      )
                                                                  : Colors.green
                                                                      .withValues(
                                                                        alpha:
                                                                            0.15,
                                                                      ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    4,
                                                                  ),
                                                            ),
                                                        child: Text(
                                                          _educations[i]
                                                                  .isOngoing
                                                              ? 'Ongoing (অধ্যয়নরত)'
                                                              : 'Passed ${_educations[i].passingYear ?? ''}',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: _educations[i]
                                                                    .isOngoing
                                                                ? Colors
                                                                    .blue[800]
                                                                : Colors
                                                                    .green[800],
                                                          ),
                                                        ),
                                                      ),
                                                      if (_educations[i].id ==
                                                              null &&
                                                          _isEditing) ...[
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 6,
                                                                vertical: 2,
                                                              ),
                                                          decoration:
                                                              BoxDecoration(
                                                                color: Colors
                                                                    .orange
                                                                    .withValues(
                                                                      alpha:
                                                                          0.15,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      4,
                                                                    ),
                                                              ),
                                                          child: const Text(
                                                            'Draft (নতুন)',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    _educations[i]
                                                        .institutionName,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: colors.textColor,
                                                    ),
                                                  ),
                                                  if (_educations[i]
                                                              .disciplineOrGroup !=
                                                          null ||
                                                      _educations[i]
                                                              .governingBoard !=
                                                          null ||
                                                      _educations[i]
                                                              .resultOrScore !=
                                                          null) ...[
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      [
                                                        if (_educations[i]
                                                                .disciplineOrGroup !=
                                                            null)
                                                          'Dept: ${_educations[i].disciplineOrGroup}',
                                                        if (_educations[i]
                                                                .governingBoard !=
                                                            null)
                                                          'Board: ${_educations[i].governingBoard}',
                                                        if (_educations[i]
                                                                .resultOrScore !=
                                                            null)
                                                          'Result: ${_educations[i].resultOrScore}',
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
                                              tooltip: _educations[i].id != null
                                                  ? 'Delete Qualification'
                                                  : 'Remove Qualification',
                                              onPressed: () =>
                                                  _handleDeleteEducation(i),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              const SizedBox(height: 24),
                              const CustomSectionDivider(),
                              const SizedBox(height: 24),

                              // 5. Work & Volunteer Experience (Multiple)
                              _sectionHeaderWithAction(
                                icon: Icons.work_outline,
                                title:
                                    'Work & Volunteer Experience (কাজের অভিজ্ঞতা) [ঐচ্ছিক]',
                                buttonLabel: '+ Add Experience',
                                onAdd: _showAddWorkExperienceDialog,
                                colors: colors,
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colors.dividerColor),
                              const SizedBox(height: 16),
                              if (_isLoadingExistingData)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24,
                                    ),
                                    child: CircularProgressIndicator(
                                      color: colors.primaryColor,
                                    ),
                                  ),
                                )
                              else if (_workExperiences.isEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.softAccentColor.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: colors.ornamentColor.withValues(
                                        alpha: 0.4,
                                      ),
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
                                )
                              else
                                Column(
                                  children: [
                                    for (
                                      int i = 0;
                                      i < _workExperiences.length;
                                      i++
                                    ) ...[
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: colors.backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: colors.dividerColor,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: colors.softAccentColor,
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          _workExperiences[i]
                                                              .roleOrDesignation,
                                                          style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 2,
                                                            ),
                                                        decoration:
                                                            BoxDecoration(
                                                              color: colors
                                                                  .primaryColor
                                                                  .withValues(
                                                                    alpha: 0.1,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    4,
                                                                  ),
                                                            ),
                                                        child: Text(
                                                          _workExperiences[i]
                                                              .engagementType
                                                              .replaceAll(
                                                                '_',
                                                                ' ',
                                                              )
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: colors
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                      if (_workExperiences[i]
                                                                  .id ==
                                                              null &&
                                                          _isEditing) ...[
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 6,
                                                                vertical: 2,
                                                              ),
                                                          decoration:
                                                              BoxDecoration(
                                                                color: Colors
                                                                    .orange
                                                                    .withValues(
                                                                      alpha:
                                                                          0.15,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      4,
                                                                    ),
                                                              ),
                                                          child: const Text(
                                                            'Draft (নতুন)',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    _workExperiences[i]
                                                        .organizationName,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: colors.textColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    '${_workExperiences[i].startDate.year}-${_workExperiences[i].startDate.month.toString().padLeft(2, '0')} → ${_workExperiences[i].isOngoing ? 'Present (বর্তমান)' : (_workExperiences[i].endDate != null ? '${_workExperiences[i].endDate!.year}-${_workExperiences[i].endDate!.month.toString().padLeft(2, '0')}' : '')}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: colors.hintColor,
                                                    ),
                                                  ),
                                                  if (_workExperiences[i]
                                                              .responsibilities !=
                                                          null &&
                                                      _workExperiences[i]
                                                          .responsibilities!
                                                          .isNotEmpty) ...[
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      _workExperiences[i]
                                                          .responsibilities!,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                              tooltip: _workExperiences[i].id !=
                                                      null
                                                  ? 'Delete Experience'
                                                  : 'Remove Experience',
                                              onPressed: () =>
                                                  _handleDeleteWorkExperience(
                                                    i,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
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
