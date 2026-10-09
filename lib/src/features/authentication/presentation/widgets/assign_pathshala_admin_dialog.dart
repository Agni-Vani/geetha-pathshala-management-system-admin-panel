import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/custom_date_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/service_locator.dart';
import '../../../pathshala/domain/entities/pathshala.dart';
import '../../../pathshala/domain/params/list_pathshalas_params.dart';
import '../../../pathshala/domain/usecases/list_pathshalas.dart';
import '../../../person/domain/entities/person.dart';
import '../../../person/domain/params/search_people_params.dart';
import '../../../person/domain/usecases/search_people.dart';
import '../../domain/params/params.dart';
import '../../domain/usecases/usecases.dart';

class AssignPathshalaAdminDialog extends StatefulWidget {
  final Person? initialPerson;
  final String? initialPathshalaId;
  final VoidCallback? onSuccess;

  const AssignPathshalaAdminDialog({
    super.key,
    this.initialPerson,
    this.initialPathshalaId,
    this.onSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    Person? initialPerson,
    String? initialPathshalaId,
    VoidCallback? onSuccess,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AssignPathshalaAdminDialog(
        initialPerson: initialPerson,
        initialPathshalaId: initialPathshalaId,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  State<AssignPathshalaAdminDialog> createState() =>
      _AssignPathshalaAdminDialogState();
}

class _AssignPathshalaAdminDialogState
    extends State<AssignPathshalaAdminDialog> {
  final _formKey = GlobalKey<FormState>();
  final ProcessStatusNotifier _processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());
  late final SnackbarNotifier _snackbarNotifier;

  List<Pathshala> _pathshalas = [];
  bool _isLoadingPathshalas = true;
  String? _selectedPathshalaId;

  List<Person> _people = [];
  bool _isLoadingPeople = true;
  Person? _selectedPerson;
  bool _isCreatingNewPerson = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _titleController =
      TextEditingController(text: 'প্রধান সমন্বয়ক');

  bool _obscurePassword = false;
  DateTime _effectiveFrom = DateTime.now();

  @override
  void initState() {
    super.initState();
    _snackbarNotifier = SnackbarNotifier(context: context);
    _selectedPathshalaId = widget.initialPathshalaId;
    _selectedPerson = widget.initialPerson;

    if (widget.initialPerson != null) {
      _emailController.text = widget.initialPerson!.primaryEmail ?? '';
      _nameController.text = widget.initialPerson!.displayName;
      _phoneController.text = widget.initialPerson!.primaryPhone ?? '';
    }

    _generateRandomPassword();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _areaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _generateRandomPassword() {
    final random = Random.secure();
    final numbers = List.generate(6, (_) => random.nextInt(10)).join();
    setState(() {
      _passwordController.text = 'Admin@$numbers';
      _obscurePassword = false;
    });
  }

  Future<void> _loadData() async {
    // 1. Load Pathshalas
    try {
      final listPathshalas = sl<ListPathshalas>();
      final result = await listPathshalas(
        const ListPathshalasParams(
          organizationId: AppConfig.defaultOrganizationId,
          pageSize: 100,
        ),
      );
      if (mounted) {
        setState(() {
          _pathshalas = List<Pathshala>.from(result.data ?? []);
          if (_selectedPathshalaId == null && _pathshalas.isNotEmpty) {
            _selectedPathshalaId = _pathshalas.first.id;
          }
          _isLoadingPathshalas = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingPathshalas = false);
      }
    }

    // 2. Load People (if not preselected)
    if (widget.initialPerson == null) {
      try {
        final searchPeople = sl<SearchPeople>();
        final pResult = await searchPeople(
          const SearchPeopleParams(
            organizationId: AppConfig.defaultOrganizationId,
            pageSize: 100,
          ),
        );
        if (mounted) {
          setState(() {
            _people = List<Person>.from(pResult.data ?? []);
            _isLoadingPeople = false;
          });
        }
      } catch (_) {
        if (mounted) {
          setState(() => _isLoadingPeople = false);
        }
      }
    } else {
      setState(() => _isLoadingPeople = false);
    }
  }

  void _onPersonChanged(Person? person) {
    setState(() {
      _selectedPerson = person;
      if (person != null && (person.primaryEmail?.isNotEmpty ?? false)) {
        _emailController.text = person.primaryEmail!;
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPathshalaId == null || _selectedPathshalaId!.isEmpty) {
      _snackbarNotifier.notifyError(message: 'অনুগ্রহ করে একটি পাঠশালা নির্বাচন করুন।');
      return;
    }

    if (!_isCreatingNewPerson && _selectedPerson == null && widget.initialPerson == null) {
      _snackbarNotifier.notifyError(
        message: 'অনুগ্রহ করে একজন ব্যক্তি নির্বাচন করুন অথবা নতুন ব্যক্তির তথ্য দিন।',
      );
      return;
    }

    _processStatusNotifier.setLoading(message: 'প্রশাসক তৈরি হচ্ছে...');

    final createAdminUseCase = sl<CreatePathshalaAdmin>();

    final personId = _isCreatingNewPerson ? null : (_selectedPerson?.id ?? widget.initialPerson?.id);
    final legalName = _isCreatingNewPerson
        ? _nameController.text.trim()
        : (_selectedPerson?.displayName ?? widget.initialPerson?.displayName);

    final params = CreatePathshalaAdminParams(
      pathshalaId: _selectedPathshalaId!,
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      personId: personId,
      legalName: legalName,
      preferredName: legalName,
      primaryPhone: _isCreatingNewPerson
          ? _phoneController.text.trim()
          : (_selectedPerson?.primaryPhone ?? widget.initialPerson?.primaryPhone),
      area: _isCreatingNewPerson ? _areaController.text.trim() : null,
      title: _titleController.text.trim().isEmpty ? 'প্রধান সমন্বয়ক' : _titleController.text.trim(),
      effectiveFrom: _effectiveFrom,
    );

    final result = await createAdminUseCase(params);

    if (!mounted) return;

    if (result.success) {
      _processStatusNotifier.setEnabled();
      _snackbarNotifier.notifySuccess(
        message: 'পাঠশালা প্রশাসক সফলভাবে নিয়োগ ও অ্যাকাউন্ট তৈরি করা হয়েছে।',
      );
      Navigator.of(context).pop();
      widget.onSuccess?.call();
    } else {
      _processStatusNotifier.setError();
      final err = result.message.isNotEmpty ? result.message : 'পাঠশালা প্রশাসক তৈরিতে ব্যর্থ হয়েছে।';
      _snackbarNotifier.notifyError(message: err);
    }
  }

  InputDecoration _inputDeco({
    required AppColors colors,
    required String hint,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colors.hintColor, fontSize: 13),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 18, color: colors.hintColor) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: AppSizes.bigRectangleTileRadius,
        borderSide: BorderSide(color: colors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppSizes.bigRectangleTileRadius,
        borderSide: BorderSide(color: colors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppSizes.bigRectangleTileRadius,
        borderSide: BorderSide(color: colors.primaryColor, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 620,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.shadowColor,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: colors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.admin_panel_settings_outlined,
                      color: colors.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'পাঠশালা প্রশাসক নিয়োগ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: colors.textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'লগইন ক্রেডেনশিয়াল ও দায়িত্ব বরাদ্দ করুন',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: colors.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20, color: colors.hintColor),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'বন্ধ করুন',
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.borderColor),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pathshala Selection
                      Text(
                        'পাঠশালা *',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (widget.initialPathshalaId != null && _pathshalas.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: colors.tileColor,
                            borderRadius: AppSizes.bigRectangleTileRadius,
                            border: Border.all(color: colors.borderColor),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.account_balance_outlined, size: 18, color: colors.primaryColor),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  (_pathshalas.where((p) => p.id == widget.initialPathshalaId).firstOrNull ?? _pathshalas.first).name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textColor,
                                  ),
                                ),
                              ),
                              Icon(Icons.lock_outline, size: 16, color: colors.hintColor),
                            ],
                          ),
                        )
                      else if (_isLoadingPathshalas)
                        const LinearProgressIndicator()
                      else
                        DropdownButtonFormField<String>(
                          initialValue: _selectedPathshalaId,
                          isExpanded: true,
                          decoration: _inputDeco(colors: colors, hint: 'পাঠশালা নির্বাচন করুন'),
                          items: _pathshalas.map((p) {
                            return DropdownMenuItem(
                              value: p.id,
                              child: Text(p.name, style: TextStyle(fontSize: 13.5, color: colors.textColor)),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedPathshalaId = val),
                        ),

                      const SizedBox(height: 20),

                      // Person Section
                      Text(
                        'প্রশাসক ব্যক্তি নির্বাচন *',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (widget.initialPerson != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.tileColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: colors.borderColor),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: colors.primaryColor.withValues(alpha: 0.15),
                                child: Icon(Icons.person, color: colors.primaryColor, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.initialPerson!.displayName,
                                      style: TextStyle(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w600,
                                        color: colors.textColor,
                                      ),
                                    ),
                                    Text(
                                      widget.initialPerson!.primaryPhone ?? 'ফোন নম্বর নেই',
                                      style: TextStyle(fontSize: 12, color: colors.hintColor),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.check_circle, color: colors.primaryColor, size: 20),
                            ],
                          ),
                        )
                      else ...[
                        // Toggle between Registered person vs New person
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.tileColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colors.borderColor),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(() => _isCreatingNewPerson = false),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: !_isCreatingNewPerson ? colors.backgroundColor : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: !_isCreatingNewPerson
                                          ? [BoxShadow(color: colors.shadowColor, blurRadius: 4)]
                                          : null,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'নিবন্ধিত ব্যক্তি থেকে',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: !_isCreatingNewPerson ? FontWeight.w600 : FontWeight.normal,
                                        color: !_isCreatingNewPerson ? colors.primaryColor : colors.hintColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => setState(() => _isCreatingNewPerson = true),
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: _isCreatingNewPerson ? colors.backgroundColor : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: _isCreatingNewPerson
                                          ? [BoxShadow(color: colors.shadowColor, blurRadius: 4)]
                                          : null,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'নতুন ব্যক্তির তথ্য',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: _isCreatingNewPerson ? FontWeight.w600 : FontWeight.normal,
                                        color: _isCreatingNewPerson ? colors.primaryColor : colors.hintColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (!_isCreatingNewPerson) ...[
                          if (_isLoadingPeople)
                            const LinearProgressIndicator()
                          else
                            DropdownButtonFormField<Person>(
                              initialValue: _selectedPerson,
                              isExpanded: true,
                              hint: Text('রেজিস্ট্রি থেকে ব্যক্তি নির্বাচন করুন', style: TextStyle(fontSize: 13, color: colors.hintColor)),
                              decoration: _inputDeco(colors: colors, hint: 'ব্যক্তি নির্বাচন করুন'),
                              items: _people.map((p) {
                                return DropdownMenuItem(
                                  value: p,
                                  child: Text(
                                    '${p.displayName} (${p.primaryPhone ?? 'কোনো ফোন নেই'})',
                                    style: TextStyle(fontSize: 13, color: colors.textColor),
                                  ),
                                );
                              }).toList(),
                              onChanged: _onPersonChanged,
                            ),
                        ] else ...[
                          TextFormField(
                            controller: _nameController,
                            style: TextStyle(fontSize: 14, color: colors.textColor),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'নাম প্রদান আবশ্যক' : null,
                            decoration: _inputDeco(
                              colors: colors,
                              hint: 'সম্পূর্ণ নাম (উদা: রাহুল শর্মা)',
                              prefixIcon: Icons.person_outline,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  style: TextStyle(fontSize: 14, color: colors.textColor),
                                  decoration: _inputDeco(
                                    colors: colors,
                                    hint: 'মোবাইল নম্বর',
                                    prefixIcon: Icons.call_outlined,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _areaController,
                                  style: TextStyle(fontSize: 14, color: colors.textColor),
                                  decoration: _inputDeco(
                                    colors: colors,
                                    hint: 'ঠিকানা / এলাকা',
                                    prefixIcon: Icons.location_on_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],

                      const SizedBox(height: 20),
                      Divider(color: colors.borderColor),
                      const SizedBox(height: 16),

                      // Credentials section header
                      Row(
                        children: [
                          Icon(Icons.vpn_key_outlined, size: 18, color: colors.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'লগইন ক্রেডেনশিয়াল (Login Credentials)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: colors.textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'পাঠশালা অ্যাডমিন এই ইমেইল ও পাসওয়ার্ড দিয়ে পাঠশালা সফটওয়্যারে লগইন করবেন।',
                        style: TextStyle(fontSize: 12, color: colors.hintColor),
                      ),
                      const SizedBox(height: 14),

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(fontSize: 14, color: colors.textColor),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'ইমেইল প্রদান আবশ্যক';
                          if (!v.contains('@') || !v.contains('.')) return 'সঠিক ইমেইল ফরম্যাট দিন';
                          return null;
                        },
                        decoration: _inputDeco(
                          colors: colors,
                          hint: 'লগইন ইমেইল (উদা: admin@pathshala.org)',
                          prefixIcon: Icons.email_outlined,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Password Field with generate button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'লগইন পাসওয়ার্ড (Password) *',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textColor,
                                ),
                              ),
                              InkWell(
                                onTap: _generateRandomPassword,
                                borderRadius: BorderRadius.circular(4),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.auto_fix_high, size: 14, color: colors.primaryColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        'র‍্যান্ডম পাসওয়ার্ড তৈরি',
                                        style: TextStyle(
                                          fontSize: 11.5,
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
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: TextStyle(fontSize: 14, color: colors.textColor),
                            validator: (v) {
                              if (v == null || v.length < 6) return 'পাসওয়ার্ড ন্যূনতম ৬ অক্ষরের হতে হবে';
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'ন্যূনতম ৬ অক্ষর',
                              hintStyle: TextStyle(color: colors.hintColor, fontSize: 13),
                              prefixIcon: Icon(Icons.lock_outline, size: 18, color: colors.hintColor),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      size: 18,
                                      color: colors.hintColor,
                                    ),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                    tooltip: _obscurePassword ? 'পাসওয়ার্ড দেখুন' : 'লুকান',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.copy, size: 18, color: colors.primaryColor),
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: _passwordController.text));
                                      _snackbarNotifier.notifySuccess(message: 'পাসওয়ার্ড কপি করা হয়েছে!');
                                    },
                                    tooltip: 'পাসওয়ার্ড কপি করুন',
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: AppSizes.bigRectangleTileRadius,
                                borderSide: BorderSide(color: colors.borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppSizes.bigRectangleTileRadius,
                                borderSide: BorderSide(color: colors.borderColor),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Divider(color: colors.borderColor),
                      const SizedBox(height: 16),

                      // Designation and Effective Date
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _titleController,
                              style: TextStyle(fontSize: 14, color: colors.textColor),
                              decoration: _inputDeco(
                                colors: colors,
                                hint: 'পদবী (উদা: প্রধান সমন্বয়ক)',
                                prefixIcon: Icons.badge_outlined,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: CustomDateField(
                              label: 'কার্যকর শুরুর তারিখ',
                              value: _effectiveFrom,
                              onChanged: (d) => setState(() => _effectiveFrom = d),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Divider(height: 1, color: colors.borderColor),

            // Dialog Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    borderRadius: AppSizes.bigRectangleTileRadius,
                    onTap: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Text(
                        'বাতিল',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.hintColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ListenableBuilder(
                    listenable: _processStatusNotifier,
                    builder: (context, _) {
                      final isLoading = _processStatusNotifier.status is ProcessLoading;
                      return InkWell(
                        borderRadius: AppSizes.bigRectangleTileRadius,
                        onTap: isLoading ? null : _handleSubmit,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 11,
                          ),
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
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check, size: 16, color: Colors.white),
                                    SizedBox(width: 6),
                                    Text(
                                      'প্রশাসক নিয়োগ ও সংরক্ষণ',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
