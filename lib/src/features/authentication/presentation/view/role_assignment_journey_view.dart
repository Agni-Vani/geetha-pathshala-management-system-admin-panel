import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/async_handlers/response.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/custom_date_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_divider.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_header.dart';
import '../../../../core/shared/widget/custom_widgets/custom_status_badge.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_field_decoration.dart';
import '../../../../di/di.dart';
import '../../../classes/domain/classes_domain.dart';
import '../../../pathshala/domain/pathshala_domain.dart';
import '../../../person/domain/person_domain.dart';
import '../../domain/params/params.dart';
import '../../domain/usecases/usecases.dart';

const Color _kSuccessColor = Color(0xFF2E7D32);

/// Full-page interactive journey for searching/registering a person,
/// configuring personal attributes, and assigning IAM and educational roles.
class RoleAssignmentJourneyView extends StatefulWidget {
  final Person? initialPerson;
  final String? initialPathshalaId;
  final String? initialRoleType;
  final int? initialStep;
  final bool isEditMode;
  final VoidCallback? onSuccess;

  const RoleAssignmentJourneyView({
    super.key,
    this.initialPerson,
    this.initialPathshalaId,
    this.initialRoleType,
    this.initialStep,
    this.isEditMode = false,
    this.onSuccess,
  });

  @override
  State<RoleAssignmentJourneyView> createState() =>
      _RoleAssignmentJourneyViewState();
}

class _RoleAssignmentJourneyViewState extends State<RoleAssignmentJourneyView> {
  final _formScrollController = ScrollController();

  int _currentStep = 0;
  bool _isSubmitting = false;

  // ---------------------------------------------------------------------------
  // STEP 1: Search & Selection State
  // ---------------------------------------------------------------------------
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _isSearching = false;
  List<Person> _searchResults = [];
  Person? _selectedPerson;
  bool _isNewPersonMode = false;

  // ---------------------------------------------------------------------------
  // STEP 2: Person Details Form State
  // ---------------------------------------------------------------------------
  final _legalNameController = TextEditingController();
  final _preferredNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _occupationController = TextEditingController();
  final _areaController = TextEditingController();
  String? _gender;
  DateTime? _dateOfBirth;
  String? _bloodGroup;

  // ---------------------------------------------------------------------------
  // STEP 3: Role & Credentials Configuration State
  // ---------------------------------------------------------------------------
  late String _selectedRoleType;
  String? _selectedPathshalaId;
  List<Pathshala> _pathshalas = [];
  bool _isLoadingPathshalas = false;

  String? _selectedGroupId;
  List<EducationalGroup> _educationalGroups = [];

  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _rollNumberController = TextEditingController();
  DateTime _effectiveDate = DateTime.now();

  bool _enableLogin = true;
  final _loginEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _selectedRoleType = widget.initialRoleType ?? 'PATHSHALA_ADMIN';
    _selectedPathshalaId = widget.initialPathshalaId;

    if (widget.initialPerson != null) {
      _selectPerson(widget.initialPerson!);
      _currentStep = widget.initialStep ?? (widget.isEditMode ? 2 : 1);
    } else {
      _loadInitialPeople();
      _currentStep = widget.initialStep ?? 0;
    }

    _loadPathshalas();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _formScrollController.dispose();
    _searchController.dispose();
    _legalNameController.dispose();
    _preferredNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _occupationController.dispose();
    _areaController.dispose();
    _titleController.dispose();
    _subjectController.dispose();
    _rollNumberController.dispose();
    _loginEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (mounted) {
      SnackbarNotifier(context: context).notifyError(message: message);
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      SnackbarNotifier(context: context).notifySuccess(message: message);
    }
  }

  // ---------------------------------------------------------------------------
  // Data Loading Helpers
  // ---------------------------------------------------------------------------
  Future<void> _loadInitialPeople() async {
    setState(() => _isSearching = true);
    final response = await sl<SearchPeople>().call(
      const SearchPeopleParams(
        organizationId: '00000000-0000-0000-0000-000000000001',
        pageSize: 10,
      ),
    );
    if (!mounted) return;
    setState(() {
      _isSearching = false;
      if (response is SuccessRepoCall<List<Person>>) {
        _searchResults = response.data ?? [];
      }
    });
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () async {
      final trimmed = query.trim();
      setState(() => _isSearching = true);
      final response = await sl<SearchPeople>().call(
        SearchPeopleParams(
          organizationId: '00000000-0000-0000-0000-000000000001',
          query: trimmed.isEmpty ? null : trimmed,
          pageSize: 15,
        ),
      );
      if (!mounted) return;
      setState(() {
        _isSearching = false;
        if (response is SuccessRepoCall<List<Person>>) {
          _searchResults = response.data ?? [];
        }
      });
    });
  }

  Future<void> _loadPathshalas() async {
    setState(() => _isLoadingPathshalas = true);
    final response = await sl<ListPathshalas>().call(
      const ListPathshalasParams(
        organizationId: '00000000-0000-0000-0000-000000000001',
      ),
    );
    if (!mounted) return;
    setState(() {
      _isLoadingPathshalas = false;
      if (response is SuccessRepoCall<List<Pathshala>>) {
        _pathshalas = response.data ?? [];
        if (_selectedPathshalaId != null &&
            !_pathshalas.any((p) => p.id == _selectedPathshalaId)) {
          _selectedPathshalaId = null;
        }
      }
    });

    if (_selectedPathshalaId != null) {
      _loadEducationalGroups(_selectedPathshalaId!);
    }
  }

  Future<void> _loadEducationalGroups(String pathshalaId) async {
    final response = await sl<ListEducationalGroups>().call(
      ListGroupsParams(pathshalaId: pathshalaId),
    );
    if (!mounted) return;
    setState(() {
      if (response is SuccessRepoCall<List<EducationalGroup>>) {
        _educationalGroups = response.data ?? [];
        if (_selectedGroupId != null &&
            !_educationalGroups.any((g) => g.id == _selectedGroupId)) {
          _selectedGroupId = null;
        }
      }
    });
  }

  void _selectPerson(Person person) {
    setState(() {
      _selectedPerson = person;
      _isNewPersonMode = false;

      _legalNameController.text = person.legalName;
      _preferredNameController.text = person.displayName;
      _phoneController.text = person.primaryPhone ?? '';
      _emailController.text = person.primaryEmail ?? '';
      _occupationController.text = person.occupation ?? '';
      _areaController.text = person.area ?? '';
      _gender = person.gender;
      _dateOfBirth = person.dateOfBirth;

      _loginEmailController.text = person.primaryEmail ?? '';
      if (!widget.isEditMode && _passwordController.text.isEmpty) {
        _generateRandomPassword();
      }
    });
  }

  void _switchToNewPersonMode() {
    setState(() {
      _selectedPerson = null;
      _isNewPersonMode = true;

      _legalNameController.clear();
      _preferredNameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _occupationController.clear();
      _areaController.clear();
      _gender = null;
      _dateOfBirth = null;
      _bloodGroup = null;

      _loginEmailController.clear();
      _generateRandomPassword();
      _currentStep = 1;
    });
  }

  void _generateRandomPassword() {
    const chars =
        'abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789!@#%*';
    final random = Random.secure();
    final generated =
        List.generate(12, (_) => chars[random.nextInt(chars.length)]).join();
    setState(() {
      _passwordController.text = '${generated}1A!';
    });
  }

  // ---------------------------------------------------------------------------
  // Step Navigation & Validation
  // ---------------------------------------------------------------------------
  void _goToNextStep() {
    if (_currentStep == 0) {
      if (_selectedPerson == null && !_isNewPersonMode) {
        _showError(
          'অনুগ্রহ করে একজন বিদ্যমান ব্যক্তি নির্বাচন করুন অথবা নতুন ব্যক্তি হিসেবে এগিয়ে যান।',
        );
        return;
      }
      setState(() => _currentStep = 1);
      _formScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else if (_currentStep == 1) {
      if (_legalNameController.text.trim().isEmpty) {
        _showError('আইনি নাম (Legal Name) প্রদান করা আবশ্যক।');
        return;
      }
      if (_preferredNameController.text.trim().isEmpty) {
        _preferredNameController.text = _legalNameController.text.trim();
      }
      if (_loginEmailController.text.trim().isEmpty &&
          _emailController.text.trim().isNotEmpty) {
        _loginEmailController.text = _emailController.text.trim();
      }
      if (!widget.isEditMode && _passwordController.text.isEmpty) {
        _generateRandomPassword();
      }
      _applyRoleDefaults();
      setState(() => _currentStep = 2);
      _formScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else if (_currentStep == 2) {
      if (_selectedRoleType != 'SUPERADMIN' && _selectedPathshalaId == null) {
        _showError('পাঠশালা নির্বাচন করা আবশ্যক।');
        return;
      }
      if (_enableLogin && _loginEmailController.text.trim().isEmpty) {
        _showError('লগইন সক্রিয় করতে ইমেইল প্রয়োজন।');
        return;
      }
      if (!widget.isEditMode &&
          _enableLogin &&
          _passwordController.text.trim().isEmpty) {
        _showError('লগইন সক্রিয় করতে পাসওয়ার্ড প্রয়োজন।');
        return;
      }

      _showConfirmationActionDialog();
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _formScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _applyRoleDefaults() {
    if (_selectedRoleType == 'PATHSHALA_ADMIN' &&
        _titleController.text.trim().isEmpty) {
      _titleController.text = 'প্রধান সমন্বয়ক';
    } else if (_selectedRoleType == 'TEACHER' &&
        _titleController.text.trim().isEmpty) {
      _titleController.text = 'সহকারী শিক্ষক';
    }
  }

  // ---------------------------------------------------------------------------
  // STEP 4: Confirmation Action Dialog & Final Execution
  // ---------------------------------------------------------------------------
  Future<void> _showConfirmationActionDialog() async {
    final colors = AppColors.context(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? colors.backgroundColor : Colors.white;

    final targetPathshala = _pathshalas
        .where((p) => p.id == _selectedPathshalaId)
        .firstOrNull;

    final roleLabel = switch (_selectedRoleType) {
      'SUPERADMIN' => 'সুপার অ্যাডমিন (Super Administrator)',
      'PATHSHALA_ADMIN' => 'পাঠশালা প্রশাসক (Pathshala Administrator)',
      'TEACHER' => 'শিক্ষক (Teacher)',
      'STUDENT' => 'শিক্ষার্থী (Student)',
      _ => _selectedRoleType,
    };

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: colors.primaryColor.withValues(alpha: 0.25),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        actionsPadding: const EdgeInsets.all(20),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.primaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified_user_rounded,
                color: colors.primaryColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isEditMode ? 'ভূমিকা হালনাগাদ ও সংরক্ষণ' : 'পদক্ষেপ নিশ্চিতকরণ',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.isEditMode
                        ? 'ভূমিকা ও অ্যাক্সেস পরিবর্তনের সারসংক্ষেপ যাচাই করুন'
                        : 'ভূমিকা ও অ্যাক্সেস বরাদ্দের সারসংক্ষেপ যাচাই করুন',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colors.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colors.primaryColor.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow(
                        'লক্ষ্য ব্যক্তি:',
                        _legalNameController.text.trim(),
                        colors,
                        isBold: true,
                      ),
                      if (_preferredNameController.text.trim().isNotEmpty &&
                          _preferredNameController.text.trim() !=
                              _legalNameController.text.trim()) ...[
                        const SizedBox(height: 6),
                        _buildSummaryRow(
                          'ডাকনাম:',
                          _preferredNameController.text.trim(),
                          colors,
                        ),
                      ],
                      if (_phoneController.text.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _buildSummaryRow(
                          'ফোন নম্বর:',
                          _phoneController.text.trim(),
                          colors,
                        ),
                      ],
                      const SizedBox(height: 6),
                      _buildSummaryRow(
                        'বরাদ্দকৃত ভূমিকা:',
                        roleLabel,
                        colors,
                        valueColor: colors.primaryColor,
                        isBold: true,
                      ),
                      if (targetPathshala != null) ...[
                        const SizedBox(height: 6),
                        _buildSummaryRow(
                          'পাঠশালা:',
                          targetPathshala.name,
                          colors,
                        ),
                      ],
                      if (_selectedRoleType == 'PATHSHALA_ADMIN' &&
                          _titleController.text.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _buildSummaryRow(
                          'পদবী:',
                          _titleController.text.trim(),
                          colors,
                        ),
                      ],
                      if (_selectedRoleType == 'TEACHER') ...[
                        if (_titleController.text.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          _buildSummaryRow(
                            'পদবী:',
                            _titleController.text.trim(),
                            colors,
                          ),
                        ],
                        if (_subjectController.text.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          _buildSummaryRow(
                            'পাঠদান বিষয়:',
                            _subjectController.text.trim(),
                            colors,
                          ),
                        ],
                      ],
                      if (_selectedRoleType == 'STUDENT' &&
                          _rollNumberController.text.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _buildSummaryRow(
                          'রোল নম্বর:',
                          _rollNumberController.text.trim(),
                          colors,
                        ),
                      ],
                      const SizedBox(height: 6),
                      _buildSummaryRow(
                        'কার্যকরের তারিখ:',
                        '${_effectiveDate.year}-${_effectiveDate.month.toString().padLeft(2, '0')}-${_effectiveDate.day.toString().padLeft(2, '0')}',
                        colors,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                if (_enableLogin) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _kSuccessColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _kSuccessColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lock_person_outlined,
                          color: _kSuccessColor,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.isEditMode
                                    ? 'পোর্টাল লগইন ক্রেডেনশিয়ালস:'
                                    : 'পোর্টাল লগইন ক্রেডেনশিয়ালস তৈরি হবে:',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textColor,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'ইমেইল: ${_loginEmailController.text.trim()}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textColor,
                                ),
                              ),
                              Text(
                                _passwordController.text.trim().isEmpty
                                    ? 'পাসওয়ার্ড: (অপরিবর্তিত থাকবে)'
                                    : 'পাসওয়ার্ড: ${_passwordController.text}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w600,
                                  color: colors.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.hintColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: colors.hintColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'সরাসরি পোর্টাল লগইন অ্যাকাউন্ট ছাড়া কেবল প্রোফাইল রেকর্ড হিসেবে সংরক্ষিত হবে।',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Text(
                  'আপনি কি নিশ্চিতভাবে এই ভূমিকা ও দায়িত্ব বরাদ্দ সম্পন্ন করতে চান?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () => Navigator.pop(ctx, false),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              alignment: Alignment.center,
              child: Text(
                'ফিরে যান',
                style: TextStyle(
                  color: colors.hintColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.pop(ctx, true),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              decoration: BoxDecoration(
                color: colors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline, size: 18, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'হ্যাঁ, নিশ্চিত করুন',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _executeAssignment();
    }
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    AppColors colors, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 125,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              color: colors.hintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              color: valueColor ?? colors.textColor,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _executeAssignment() async {
    setState(() => _isSubmitting = true);

    final params = AssignRoleJourneyParams(
      roleType: _selectedRoleType,
      personId: _selectedPerson?.id,
      legalName: _legalNameController.text.trim(),
      preferredName: _preferredNameController.text.trim().isEmpty
          ? _legalNameController.text.trim()
          : _preferredNameController.text.trim(),
      primaryPhone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      primaryEmail: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      gender: _gender,
      dateOfBirth: _dateOfBirth != null
          ? '${_dateOfBirth!.year}-${_dateOfBirth!.month.toString().padLeft(2, '0')}-${_dateOfBirth!.day.toString().padLeft(2, '0')}'
          : null,
      bloodGroup: _bloodGroup,
      occupation: _occupationController.text.trim().isEmpty
          ? null
          : _occupationController.text.trim(),
      area: _areaController.text.trim().isEmpty
          ? null
          : _areaController.text.trim(),
      enableLogin: _enableLogin,
      email: _enableLogin ? _loginEmailController.text.trim() : null,
      password: _enableLogin && _passwordController.text.trim().isNotEmpty
          ? _passwordController.text
          : null,
      pathshalaId: _selectedPathshalaId,
      title: _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim(),
      subject: _subjectController.text.trim().isEmpty
          ? null
          : _subjectController.text.trim(),
      rollNumber: _rollNumberController.text.trim().isEmpty
          ? null
          : _rollNumberController.text.trim(),
      groupId: _selectedGroupId,
      effectiveFrom: _effectiveDate,
    );

    final response = await sl<AssignRoleJourney>().call(params);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (response is SuccessRepoCall<Map<String, dynamic>>) {
      widget.onSuccess?.call();
      _showSuccessResultDialog(response.data ?? {});
    } else {
      _showError('ভূমিকা বরাদ্দ ব্যর্থ হয়েছে: ${response.message}');
    }
  }

  void _showSuccessResultDialog(Map<String, dynamic> resultData) {
    final colors = AppColors.context(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? colors.backgroundColor : Colors.white;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: dialogBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: _kSuccessColor.withValues(alpha: 0.3),
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        actionsPadding: const EdgeInsets.all(20),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _kSuccessColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: _kSuccessColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'সফলভাবে সম্পন্ন হয়েছে!',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'ভূমিকা এবং প্রয়োজনীয় অনুমতি সফলভাবে বরাদ্দ হয়েছে',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colors.hintColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _kSuccessColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _kSuccessColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      'ব্যক্তি:',
                      _legalNameController.text.trim(),
                      colors,
                      isBold: true,
                    ),
                    const SizedBox(height: 6),
                    _buildSummaryRow(
                      'বরাদ্দ ভূমিকা:',
                      _selectedRoleType,
                      colors,
                      valueColor: colors.primaryColor,
                      isBold: true,
                    ),
                    if (_enableLogin) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'লগইন ইমেইল: ${_loginEmailController.text.trim()}',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'পাসওয়ার্ড: ${_passwordController.text}',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontFamily: 'monospace',
                                    color: colors.textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 20),
                            tooltip: 'ক্রেডেনশিয়ালস কপি করুন',
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text:
                                      'ইমেইল: ${_loginEmailController.text.trim()}\nপাসওয়ার্ড: ${_passwordController.text}',
                                ),
                              );
                              _showSuccess('লগইন তথ্য ক্লিপবোর্ডে কপি করা হয়েছে!');
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              widget.onSuccess?.call();
              Navigator.pop(ctx);
              Navigator.of(context).maybePop(true);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: colors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Text(
                'সমাপ্ত ও ফিরে যান',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAIN BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ResponsiveAppShell(
      selectedIndex: 11,
      onItemSelected: (index) =>
          AppSidebarNavigation.navigateToIndex(context, index),
      topBarTitle: 'Overview',
      showTopBarBack: false,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Scrollbar(
                  controller: _formScrollController,
                  thumbVisibility: true,
                  thickness: 6,
                  radius: const Radius.circular(3),
                  child: SingleChildScrollView(
                    controller: _formScrollController,
                    padding: AppSizes.pagePadding(context).copyWith(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBreadcrumbs(
                          items: [
                            BreadcrumbItem.home(context),
                            BreadcrumbItem(
                              label: 'IAM ও ভূমিকা ব্যবস্থাপনা',
                              icon: Icons.admin_panel_settings_outlined,
                              onTap: () => Navigator.of(context).maybePop(),
                            ),
                            BreadcrumbItem(
                              label: widget.isEditMode
                                  ? 'ভূমিকা হালনাগাদ যাত্রা (Update Role Journey)'
                                  : 'ভূমিকা বরাদ্দ যাত্রা (Assign Role Journey)',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.isEditMode
                              ? 'ভূমিকা ও অ্যাক্সেস সম্পাদনা ও হালনাগাদ'
                              : 'ভূমিকা ও অ্যাক্সেস বরাদ্দ যাত্রা',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colors.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.isEditMode
                              ? 'নির্বাচিত ব্যক্তির বিদ্যমান ভূমিকা, অ্যাসাইনমেন্ট ও পোর্টাল অ্যাক্সেস হালনাগাদ করুন।'
                              : 'বিদ্যমান ব্যক্তি অনুসন্ধান করুন বা নতুন ব্যক্তি যোগ করে তাদের সুপার অ্যাডমিন, পাঠশালা প্রশাসক, শিক্ষক বা শিক্ষার্থীর ভূমিকা ও পোর্টাল অ্যাক্সেস প্রদান করুন।',
                          style: TextStyle(
                            color: colors.hintColor,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildStepperBar(colors, isDark),
                        const SizedBox(height: 24),
                        if (_currentStep == 0) _buildStep1SearchAndSelect(colors),
                        if (_currentStep == 1) _buildStep2PersonDetails(colors),
                        if (_currentStep == 2) _buildStep3RoleAndAccess(colors),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomNavigationBar(colors, isDark),
            ],
          ),
          if (_isSubmitting)
            Container(
              color: Colors.black.withValues(alpha: 0.45),
              child: const Center(
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'ভূমিকা ও অ্যাক্সেস রেকর্ড প্রক্রিয়াকরণ হচ্ছে...',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEPPER HEADER
  // ---------------------------------------------------------------------------
  Widget _buildStepperBar(AppColors colors, bool isDark) {
    final steps = [
      {'title': 'ব্যবহারকারী নির্বাচন', 'subtitle': 'Search / Select Person'},
      {'title': 'ব্যক্তিগত বিবরণ', 'subtitle': 'Personal Details'},
      {'title': 'ভূমিকা ও অ্যাক্সেস', 'subtitle': 'Role & Portal Access'},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 900;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark
                ? colors.backgroundColor
                : colors.primaryColor.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colors.primaryColor.withValues(alpha: 0.15),
            ),
          ),
          child: isNarrow
              ? Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(steps.length, (index) {
                        final isActive = _currentStep == index;
                        final isDone = _currentStep > index;

                        return InkWell(
                          onTap: isDone ? () => setState(() => _currentStep = index) : null,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: isDone
                                  ? _kSuccessColor
                                  : isActive
                                      ? colors.primaryColor
                                      : colors.hintColor.withValues(alpha: 0.2),
                              child: isDone
                                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                                  : Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isActive ? Colors.white : colors.hintColor,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ধাপ ${_currentStep + 1}: ${steps[_currentStep]['title']}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: List.generate(steps.length * 2 - 1, (i) {
                    if (i.isOdd) {
                      final stepIndex = i ~/ 2;
                      final isDone = _currentStep > stepIndex;
                      return Container(
                        width: 24,
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        color: isDone
                            ? _kSuccessColor
                            : colors.primaryColor.withValues(alpha: 0.15),
                      );
                    }

                    final index = i ~/ 2;
                    final isActive = _currentStep == index;
                    final isDone = _currentStep > index;

                    return Expanded(
                      child: InkWell(
                        onTap: (isDone || widget.isEditMode || _selectedPerson != null)
                            ? () => setState(() => _currentStep = index)
                            : null,
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: isDone
                                    ? _kSuccessColor
                                    : isActive
                                        ? colors.primaryColor
                                        : colors.hintColor.withValues(alpha: 0.2),
                                child: isDone
                                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                                    : Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isActive ? Colors.white : colors.hintColor,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      steps[index]['title']!,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight:
                                            isActive ? FontWeight.bold : FontWeight.w600,
                                        color: isActive
                                            ? colors.primaryColor
                                            : isDone
                                                ? colors.textColor
                                                : colors.hintColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      steps[index]['subtitle']!,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: colors.hintColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 1 CONTENT: Search & Select Person
  // ---------------------------------------------------------------------------
  Widget _buildStep1SearchAndSelect(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 540;
            final newPersonBtn = InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _switchToNewPersonMode,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: colors.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_add_alt_1_rounded,
                        size: 16, color: colors.primaryColor),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'নতুন ব্যক্তি হিসেবে তথ্য দিন',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomSectionHeader(
                    icon: Icons.person_search_rounded,
                    title: '১. ব্যবহারকারী বা ব্যক্তি নির্বাচন করুন',
                  ),
                  const SizedBox(height: 8),
                  newPersonBtn,
                ],
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: CustomSectionHeader(
                    icon: Icons.person_search_rounded,
                    title: '১. ব্যবহারকারী বা ব্যক্তি নির্বাচন করুন',
                  ),
                ),
                const SizedBox(width: 8),
                newPersonBtn,
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        if (_selectedPerson != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colors.primaryColor,
                width: 1.5,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 480;
                final changeBtn = InkWell(
                  onTap: () => setState(() => _selectedPerson = null),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close, size: 16, color: colors.primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          'পরিবর্তন',
                          style: TextStyle(
                            color: colors.primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              if (isCompact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: colors.primaryColor,
                          child: Text(
                            _selectedPerson!.displayName.isNotEmpty
                                ? _selectedPerson!.displayName[0].toUpperCase()
                                : 'P',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedPerson!.displayName,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const CustomStatusBadge(
                                label: 'নির্বাচিত ব্যক্তি',
                                tone: StatusTone.positive,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'আইনি নাম: ${_selectedPerson!.legalName} | ফোন: ${_selectedPerson!.primaryPhone ?? 'নেই'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.hintColor,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: changeBtn,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colors.primaryColor,
                    child: Text(
                      _selectedPerson!.displayName.isNotEmpty
                          ? _selectedPerson!.displayName[0].toUpperCase()
                          : 'P',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _selectedPerson!.displayName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CustomStatusBadge(
                              label: 'নির্বাচিত ব্যক্তি',
                              tone: StatusTone.positive,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'আইনি নাম: ${_selectedPerson!.legalName} | ফোন: ${_selectedPerson!.primaryPhone ?? 'নেই'} | ইমেইল: ${_selectedPerson!.primaryEmail ?? 'নেই'}',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: colors.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  changeBtn,
                ],
              );
            },
          ),
        ),
          const SizedBox(height: 20),
        ],
        // Search Input Bar
        TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'নাম, মোবাইল নম্বর বা ইমেইল দিয়ে ব্যক্তি খুঁজুন...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null,
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? colors.backgroundColor
                : Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colors.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colors.primaryColor.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colors.primaryColor,
                width: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_isSearching)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_searchResults.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primaryColor.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colors.hintColor.withValues(alpha: 0.2),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.person_search_outlined,
                  size: 42,
                  color: colors.hintColor,
                ),
                const SizedBox(height: 10),
                Text(
                  'কোন মিল পাওয়া যায়নি',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'আপনি সরাসরি "নতুন ব্যক্তি হিসেবে তথ্য দিন" বাটনে ক্লিক করে নতুন ব্যক্তি নিবন্ধন করতে পারেন।',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _searchResults.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final person = _searchResults[index];
              final isSelected = _selectedPerson?.id == person.id;

              return InkWell(
                onTap: () => _selectPerson(person),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primaryColor.withValues(alpha: 0.08)
                        : Theme.of(context).brightness == Brightness.dark
                            ? colors.backgroundColor
                            : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? colors.primaryColor
                          : colors.hintColor.withValues(alpha: 0.2),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 440;
                      final selectBtn = InkWell(
                        onTap: () => _selectPerson(person),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colors.primaryColor
                                : colors.primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                const Icon(Icons.check, size: 16, color: Colors.white),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                isSelected ? 'নির্বাচিত' : 'নির্বাচন করুন',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : colors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      final details = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            person.displayName,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'আইনি নাম: ${person.legalName} ${person.primaryPhone != null ? '• ফোন: ${person.primaryPhone}' : ''}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.hintColor,
                            ),
                          ),
                          if (person.primaryEmail != null &&
                              person.primaryEmail!.isNotEmpty) ...[
                            Text(
                              'ইমেইল: ${person.primaryEmail}',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.hintColor,
                              ),
                            ),
                          ],
                        ],
                      );

                      if (isCompact) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: colors.primaryColor.withValues(alpha: 0.15),
                                  child: Text(
                                    person.displayName.isNotEmpty
                                        ? person.displayName[0].toUpperCase()
                                        : 'P',
                                    style: TextStyle(
                                      color: colors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(child: details),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: selectBtn,
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: colors.primaryColor.withValues(alpha: 0.15),
                            child: Text(
                              person.displayName.isNotEmpty
                                  ? person.displayName[0].toUpperCase()
                                  : 'P',
                              style: TextStyle(
                                color: colors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(child: details),
                          const SizedBox(width: 8),
                          selectBtn,
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 2 CONTENT: Personal Details Form
  // ---------------------------------------------------------------------------
  Widget _buildStep2PersonDetails(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 480;
            final badge = _selectedPerson != null
                ? const CustomStatusBadge(
                    label: 'বিদ্যমান রেকর্ড',
                    tone: StatusTone.neutral,
                  )
                : const CustomStatusBadge(
                    label: 'নতুন ব্যক্তি নিবন্ধন',
                    tone: StatusTone.positive,
                  );

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomSectionHeader(
                    icon: Icons.badge_outlined,
                    title: '২. ব্যক্তিগত তথ্য যাচাই ও সম্পাদনা',
                  ),
                  const SizedBox(height: 6),
                  badge,
                ],
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: CustomSectionHeader(
                    icon: Icons.badge_outlined,
                    title: '২. ব্যক্তিগত তথ্য যাচাই ও সম্পাদনা',
                  ),
                ),
                const SizedBox(width: 8),
                badge,
              ],
            );
          },
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final isTwoColumn = constraints.maxWidth >= 720;

            return Column(
              children: [
                if (isTwoColumn)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomFormField(
                          label: 'আইনি নাম (Legal Name)',
                          hint: 'উদা: অনির্বাণ চক্রবর্তী',
                          isRequired: true,
                          controller: _legalNameController,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomFormField(
                          label: 'ডাকনাম / পরিচিত নাম (Preferred Name)',
                          hint: 'উদা: অনির্বাণ',
                          isRequired: true,
                          controller: _preferredNameController,
                        ),
                      ),
                    ],
                  )
                else ...[
                  CustomFormField(
                    label: 'আইনি নাম (Legal Name)',
                    hint: 'উদা: অনির্বাণ চক্রবর্তী',
                    isRequired: true,
                    controller: _legalNameController,
                  ),
                  const SizedBox(height: 14),
                  CustomFormField(
                    label: 'ডাকনাম / পরিচিত নাম (Preferred Name)',
                    hint: 'উদা: অনির্বাণ',
                    isRequired: true,
                    controller: _preferredNameController,
                  ),
                ],
                const SizedBox(height: 14),
                if (isTwoColumn)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomFormField(
                          label: 'মোবাইল নম্বর (Phone)',
                          hint: 'উদা: +8801712345678',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomFormField(
                          label: 'ইমেইল (Email)',
                          hint: 'উদা: anirban@example.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          onTextChanged: (val) {
                            if (_loginEmailController.text.trim().isEmpty ||
                                _loginEmailController.text == val) {
                              _loginEmailController.text = val;
                            }
                          },
                        ),
                      ),
                    ],
                  )
                else ...[
                  CustomFormField(
                    label: 'মোবাইল নম্বর (Phone)',
                    hint: 'উদা: +8801712345678',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),
                  CustomFormField(
                    label: 'ইমেইল (Email)',
                    hint: 'উদা: anirban@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onTextChanged: (val) {
                      if (_loginEmailController.text.trim().isEmpty ||
                          _loginEmailController.text == val) {
                        _loginEmailController.text = val;
                      }
                    },
                  ),
                ],
                const SizedBox(height: 14),
                if (isTwoColumn)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomFormField.dropdown(
                          label: 'লিঙ্গ (Gender)',
                          hint: 'লিঙ্গ নির্বাচন করুন',
                          items: const ['Male', 'Female', 'Other'],
                          value: _gender,
                          onChanged: (val) => setState(() => _gender = val),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomDateField(
                          label: 'জন্ম তারিখ (Date of Birth)',
                          value: _dateOfBirth,
                          onChanged: (d) => setState(() => _dateOfBirth = d),
                        ),
                      ),
                    ],
                  )
                else ...[
                  CustomFormField.dropdown(
                    label: 'লিঙ্গ (Gender)',
                    hint: 'লিঙ্গ নির্বাচন করুন',
                    items: const ['Male', 'Female', 'Other'],
                    value: _gender,
                    onChanged: (val) => setState(() => _gender = val),
                  ),
                  const SizedBox(height: 14),
                  CustomDateField(
                    label: 'জন্ম তারিখ (Date of Birth)',
                    value: _dateOfBirth,
                    onChanged: (d) => setState(() => _dateOfBirth = d),
                  ),
                ],
                const SizedBox(height: 14),
                if (isTwoColumn)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomFormField.dropdown(
                          label: 'রক্তের গ্রুপ (Blood Group)',
                          hint: 'গ্রুপ বাছাই করুন',
                          items: const [
                            'A+',
                            'A-',
                            'B+',
                            'B-',
                            'AB+',
                            'AB-',
                            'O+',
                            'O-'
                          ],
                          value: _bloodGroup,
                          onChanged: (val) => setState(() => _bloodGroup = val),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomFormField(
                          label: 'পেশা (Occupation)',
                          hint: 'উদা: শিক্ষক / ব্যবসায়ী / শিক্ষার্থী',
                          controller: _occupationController,
                        ),
                      ),
                    ],
                  )
                else ...[
                  CustomFormField.dropdown(
                    label: 'রক্তের গ্রুপ (Blood Group)',
                    hint: 'গ্রুপ বাছাই করুন',
                    items: const [
                      'A+',
                      'A-',
                      'B+',
                      'B-',
                      'AB+',
                      'AB-',
                      'O+',
                      'O-'
                    ],
                    value: _bloodGroup,
                    onChanged: (val) => setState(() => _bloodGroup = val),
                  ),
                  const SizedBox(height: 14),
                  CustomFormField(
                    label: 'পেশা (Occupation)',
                    hint: 'উদা: শিক্ষক / ব্যবসায়ী / শিক্ষার্থী',
                    controller: _occupationController,
                  ),
                ],
                const SizedBox(height: 14),
                CustomFormField(
                  label: 'এলাকা বা বর্তমান ঠিকানা (Area / Address)',
                  hint: 'উদা: সূত্রাপুর, ঢাকা',
                  controller: _areaController,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 3 CONTENT: Role & Access Configuration
  // ---------------------------------------------------------------------------
  Widget _buildStep3RoleAndAccess(AppColors colors) {
    final roleCards = [
      {
        'key': 'SUPERADMIN',
        'title': 'সুপার অ্যাডমিন',
        'subtitle': 'কেন্দ্রীয় পূর্ণ প্রশাসনিক নিয়ন্ত্রণ ও IAM সিস্টেম পরিচালনা।',
        'icon': Icons.admin_panel_settings_rounded,
        'badge': 'Central Superadmin',
        'color': colors.primaryColor,
      },
      {
        'key': 'PATHSHALA_ADMIN',
        'title': 'পাঠশালা প্রশাসক',
        'subtitle': 'নির্দিষ্ট পাঠশালার স্থানীয় পরিচালনা, শিক্ষক ও শিক্ষার্থী সমন্বয়।',
        'icon': Icons.account_balance_rounded,
        'badge': 'Pathshala Admin',
        'color': _kSuccessColor,
      },
      {
        'key': 'TEACHER',
        'title': 'শিক্ষক',
        'subtitle': 'পাঠশালার শিক্ষক প্রোফাইল, শ্রেণি পরিচালনা ও পাঠদান নিয়ন্ত্রণ।',
        'icon': Icons.school_rounded,
        'badge': 'Teaching Staff',
        'color': Colors.indigo,
      },
      {
        'key': 'STUDENT',
        'title': 'শিক্ষার্থী',
        'subtitle': 'পাঠশালায় শিক্ষার্থী ভর্তি ও শ্রেণি পোর্টাল পর্যবেক্ষণ অ্যাক্সেস।',
        'icon': Icons.menu_book_rounded,
        'badge': 'Student Admission',
        'color': Colors.deepOrange,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomSectionHeader(
          icon: Icons.shield_outlined,
          title: '৩. ভূমিকা ও পোর্টাল অ্যাক্সেস নির্ধারণ করুন',
        ),
        const SizedBox(height: 12),
        // Role Selection Cards
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            final crossAxisCount = isWide ? 2 : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: roleCards.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 110,
              ),
              itemBuilder: (context, index) {
                final card = roleCards[index];
                final isSelected = _selectedRoleType == card['key'];
                final cardColor = card['color'] as Color;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedRoleType = card['key'] as String;
                      _applyRoleDefaults();
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cardColor.withValues(alpha: 0.09)
                          : Theme.of(context).brightness == Brightness.dark
                              ? colors.backgroundColor
                              : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? cardColor
                            : colors.hintColor.withValues(alpha: 0.2),
                        width: isSelected ? 2.0 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            card['icon'] as IconData,
                            color: cardColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    card['title'] as String,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: colors.textColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: cardColor,
                                      size: 20,
                                    ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                card['subtitle'] as String,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: colors.hintColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 24),
        const CustomSectionDivider(),
        const SizedBox(height: 16),

        // Contextual role configuration fields
        if (_selectedRoleType != 'SUPERADMIN') ...[
          Text(
            'পাঠশালা নির্দিষ্টকরণ *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          if (_isLoadingPathshalas)
            const Center(child: LinearProgressIndicator())
          else
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _selectedPathshalaId,
              decoration: AppFieldDecoration.build(
                context,
                hint: 'তালিকা থেকে পাঠশালা বাছাই করুন',
              ),
              items: _pathshalas.map((p) {
                return DropdownMenuItem<String>(
                  value: p.id,
                  child: Text('${p.name} (${p.code})'),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => _selectedPathshalaId = val);
                if (val != null) _loadEducationalGroups(val);
              },
            ),
          const SizedBox(height: 16),
        ],

        if (_selectedRoleType == 'PATHSHALA_ADMIN') ...[
          CustomFormField(
            label: 'প্রশাসনিক পদবী (Designation / Title)',
            hint: 'উদা: প্রধান সমন্বয়ক / সভাপতি',
            controller: _titleController,
          ),
          const SizedBox(height: 16),
        ],

        if (_selectedRoleType == 'TEACHER') ...[
          LayoutBuilder(
            builder: (context, constraints) {
              final isTwoColumn = constraints.maxWidth >= 640;
              return Column(
                children: [
                  if (isTwoColumn)
                    Row(
                      children: [
                        Expanded(
                          child: CustomFormField(
                            label: 'পদবী (Title)',
                            hint: 'উদা: প্রধান শিক্ষক / সহকারী শিক্ষক',
                            controller: _titleController,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: CustomFormField(
                            label: 'পাঠদান বিষয় (Subject)',
                            hint: 'উদা: গীতা পাঠ ও অনুধাবন',
                            controller: _subjectController,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    CustomFormField(
                      label: 'পদবী (Title)',
                      hint: 'উদা: প্রধান শিক্ষক / সহকারী শিক্ষক',
                      controller: _titleController,
                    ),
                    const SizedBox(height: 14),
                    CustomFormField(
                      label: 'পাঠদান বিষয় (Subject)',
                      hint: 'উদা: গীতা পাঠ ও অনুধাবন',
                      controller: _subjectController,
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          if (_educationalGroups.isNotEmpty) ...[
            Text(
              'শ্রেণি বরাদ্দ (ঐচ্ছিক)',
              style: TextStyle(
                fontSize: 13,
                color: colors.textColor,
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _selectedGroupId,
              decoration: AppFieldDecoration.build(
                context,
                hint: 'কোন শ্রেণি নির্দিষ্ট নয়',
              ),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('কোন শ্রেণি নির্দিষ্ট নয়')),
                ..._educationalGroups.map((g) {
                  return DropdownMenuItem<String>(
                    value: g.id,
                    child: Text('${g.name} (${g.gradeLevel})'),
                  );
                }),
              ],
              onChanged: (val) => setState(() => _selectedGroupId = val),
            ),
            const SizedBox(height: 16),
          ],
        ],

        if (_selectedRoleType == 'STUDENT') ...[
          LayoutBuilder(
            builder: (context, constraints) {
              final isTwoColumn = constraints.maxWidth >= 640;
              return Column(
                children: [
                  if (isTwoColumn)
                    Row(
                      children: [
                        Expanded(
                          child: CustomFormField(
                            label: 'রোল নম্বর (Roll Number)',
                            hint: 'উদা: 01, 102',
                            controller: _rollNumberController,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ভর্তিকৃত শ্রেণি / দল (Group)',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                initialValue: _selectedGroupId,
                                decoration: AppFieldDecoration.build(
                                  context,
                                  hint: 'শ্রেণি নির্বাচন পরে হবে',
                                ),
                                items: [
                                  const DropdownMenuItem(
                                      value: null,
                                      child: Text('শ্রেণি নির্বাচন পরে হবে')),
                                  ..._educationalGroups.map((g) {
                                    return DropdownMenuItem<String>(
                                      value: g.id,
                                      child:
                                          Text('${g.name} (${g.gradeLevel})'),
                                    );
                                  }),
                                ],
                                onChanged: (val) =>
                                    setState(() => _selectedGroupId = val),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else ...[
                    CustomFormField(
                      label: 'রোল নম্বর (Roll Number)',
                      hint: 'উদা: 01, 102',
                      controller: _rollNumberController,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'ভর্তিকৃত শ্রেণি / দল (Group)',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedGroupId,
                      decoration: AppFieldDecoration.build(
                        context,
                        hint: 'শ্রেণি নির্বাচন পরে হবে',
                      ),
                      items: [
                        const DropdownMenuItem(
                            value: null,
                            child: Text('শ্রেণি নির্বাচন পরে হবে')),
                        ..._educationalGroups.map((g) {
                          return DropdownMenuItem<String>(
                            value: g.id,
                            child: Text('${g.name} (${g.gradeLevel})'),
                          );
                        }),
                      ],
                      onChanged: (val) =>
                          setState(() => _selectedGroupId = val),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 16),
        ],

        CustomDateField(
          label: 'কার্যকরের তারিখ (Effective Date)',
          value: _effectiveDate,
          onChanged: (d) => setState(() => _effectiveDate = d),
          isRequired: true,
        ),
        const SizedBox(height: 24),
        const CustomSectionDivider(),
        const SizedBox(height: 16),

        // Portal Login Credentials Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.primaryColor.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colors.primaryColor.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.key_rounded,
                    color: colors.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ওয়েব পোর্টাল লগইন ও নিরাপত্তা ব্যবস্থা',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: colors.textColor,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: _enableLogin,
                    onChanged: (val) => setState(() => _enableLogin = val),
                  ),
                ],
              ),
              Text(
                'ব্যবহারকারীকে সিস্টেমে লগইন করার জন্য একটি সুনির্দিষ্ট ইমেইল ও পাসওয়ার্ড সেট করুন।',
                style: TextStyle(
                  fontSize: 12.5,
                  color: colors.hintColor,
                ),
              ),
              if (_enableLogin) ...[
                const SizedBox(height: 14),
                CustomFormField(
                  label: 'লগইন ইমেইল (Login Email)',
                  hint: 'উদা: admin@pathshala.org',
                  isRequired: true,
                  controller: _loginEmailController,
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: widget.isEditMode
                                  ? 'নতুন পাসওয়ার্ড (Password - ঐচ্ছিক)'
                                  : 'প্রাথমিক পাসওয়ার্ড (Password)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: colors.textColor,
                              ),
                              children: [
                                if (!widget.isEditMode)
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: colors.errorColor),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.textColor,
                            ),
                            decoration: AppFieldDecoration.build(
                              context,
                              hint: widget.isEditMode
                                  ? 'অপরিবর্তিত রাখতে ফাঁকা রাখুন'
                                  : 'কমপক্ষে ৬ ডিজিটের পাসওয়ার্ড',
                              suffixWidget: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 18,
                                  color: colors.hintColor,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: _generateRandomPassword,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: colors.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.autorenew_rounded,
                              size: 18,
                              color: colors.primaryColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'তৈরি করুন',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM ACTION BAR
  // ---------------------------------------------------------------------------
  Widget _buildBottomNavigationBar(AppColors colors, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? colors.backgroundColor : Colors.white,
        border: Border(
          top: BorderSide(
            color: colors.hintColor.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 450;

          final backBtn = InkWell(
            onTap: _goToPreviousStep,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.hintColor.withValues(alpha: 0.3)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_rounded, size: 16, color: colors.textColor),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      _currentStep == 0 ? 'ফিরে যান' : 'পূর্ববর্তী ধাপ',
                      style: TextStyle(
                        color: colors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );

          final nextBtn = InkWell(
            onTap: _goToNextStep,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: _currentStep == 2 ? _kSuccessColor : colors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _currentStep == 2
                          ? (widget.isEditMode
                              ? 'ভূমিকা হালনাগাদ ও সংরক্ষণ করুন'
                              : 'চূড়ান্ত বরাদ্দ ও অনুমোদন করুন')
                          : 'পরবর্তী ধাপ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _currentStep == 2
                        ? Icons.check_circle_outline
                        : Icons.arrow_forward_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                nextBtn,
                const SizedBox(height: 8),
                backBtn,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              backBtn,
              nextBtn,
            ],
          );
        },
      ),
    );
  }
}
