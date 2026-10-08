import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/custom_date_field.dart';
import '../../../../core/shared/widget/custom_widgets/custom_form_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/utils.dart';
import '../../../../di/service_locator.dart';
import '../../../pathshala/domain/pathshala_domain.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/usecases/usecases.dart';

class AssignTeacherDialog extends StatefulWidget {
  final Person person;
  final VoidCallback onSuccess;

  const AssignTeacherDialog({
    super.key,
    required this.person,
    required this.onSuccess,
  });

  static Future<void> show(
    BuildContext context, {
    required Person person,
    required VoidCallback onSuccess,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AssignTeacherDialog(
        person: person,
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  State<AssignTeacherDialog> createState() => _AssignTeacherDialogState();
}

class _AssignTeacherDialogState extends State<AssignTeacherDialog> {
  final ProcessStatusNotifier _processStatusNotifier =
      ProcessStatusNotifier(initialStatus: ProcessEnabled());
  late final SnackbarNotifier _snackbarNotifier;

  List<Pathshala> _pathshalas = [];
  bool _isLoadingPathshalas = true;
  String? _selectedPathshalaId;

  String _selectedRole = 'Lead Teacher';
  static const _roles = [
    'Lead Teacher',
    'Assistant Teacher',
    'Gita Instructor',
    'Guest Speaker',
  ];

  String _selectedSubject = 'শ্রীমদ্ভগবদ্গীতা';
  static const _subjects = [
    'শ্রীমদ্ভগবদ্গীতা',
    'সংস্কৃত ও শ্লোক',
    'নৈতিক শিক্ষা ও চরিত্র গঠন',
    'সাধারণ জ্ঞান ও সংস্কৃতি',
  ];

  DateTime _joinedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _snackbarNotifier = SnackbarNotifier(context: context);
    _loadPathshalas();
  }

  Future<void> _loadPathshalas() async {
    final response = await sl<ListPathshalas>().call(
      const ListPathshalasParams(organizationId: AppConfig.defaultOrganizationId),
    );
    if (mounted) {
      setState(() {
        _isLoadingPathshalas = false;
        if (response.data != null && response.data!.isNotEmpty) {
          _pathshalas = response.data!;
          _selectedPathshalaId = _pathshalas.first.id;
        }
      });
    }
  }

  Future<void> _handleAssign() async {
    if (_selectedPathshalaId == null) {
      _snackbarNotifier.notifyError(message: 'Please select a Pathshala.');
      return;
    }

    final params = AssignPersonAsTeacherParams(
      personId: widget.person.id,
      organizationId: widget.person.organizationId.isNotEmpty
          ? widget.person.organizationId
          : AppConfig.defaultOrganizationId,
      pathshalaIds: [_selectedPathshalaId!],
      role: _selectedRole,
      subject: _selectedSubject,
      joinedDate: _joinedDate,
    );

    await handleFutureRequest(
      request: () => sl<AssignPersonAsTeacher>().call(params),
      processStatusNotifier: _processStatusNotifier,
      errorSnackbarNotifier: _snackbarNotifier,
      successSnackbarNotifier: _snackbarNotifier,
    );

    if (_processStatusNotifier.status is ProcessEnabled && mounted) {
      _snackbarNotifier.notifySuccess(
        message:
            '${widget.person.displayName} has been assigned as a Teacher successfully.',
      );
      Navigator.of(context).pop();
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: isDark ? const Color(0xFF13201F) : Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.softAccentColor.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.school_outlined,
                        color: colors.primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assign as Teacher',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: colors.textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'শিক্ষক হিসেবে পাঠশালায় নিয়োগ',
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
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: colors.dividerColor),
                const SizedBox(height: 16),

                // Person Preview Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.softAccentColor.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.dividerColor.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.backgroundColor,
                          border: Border.all(
                            color: colors.primaryColor.withValues(alpha: 0.25),
                          ),
                        ),
                        child: ClipOval(
                          child: (widget.person.photoUrl != null &&
                                  widget.person.photoUrl!.trim().isNotEmpty)
                              ? Image.network(
                                  widget.person.photoUrl!,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.person_outline,
                                    color: colors.primaryColor,
                                  ),
                                )
                              : Icon(
                                  Icons.person_outline,
                                  color: colors.primaryColor,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.person.displayName,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: colors.textColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.person.primaryPhone ?? widget.person.primaryEmail ?? 'No contact info',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: colors.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.person.area != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.person.area!,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: colors.primaryColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Form Fields
                if (_isLoadingPathshalas)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  )
                else
                  CustomFormField.dropdown(
                    label: 'Select Pathshala (পাঠশালা নির্বাচন)',
                    hint: 'Choose Pathshala',
                    isRequired: true,
                    items: _pathshalas.map((p) => p.name).toList(),
                    value: _pathshalas
                        .where((p) => p.id == _selectedPathshalaId)
                        .map((p) => p.name)
                        .firstOrNull,
                    onChanged: (name) {
                      final match = _pathshalas.where((p) => p.name == name).firstOrNull;
                      if (match != null) {
                        setState(() => _selectedPathshalaId = match.id);
                      }
                    },
                  ),
                const SizedBox(height: 16),

                CustomFormField.dropdown(
                  label: 'Role / Designation (পদমর্যাদা)',
                  hint: 'Select Role',
                  isRequired: true,
                  items: _roles,
                  value: _selectedRole,
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedRole = val);
                  },
                ),
                const SizedBox(height: 16),

                CustomFormField.dropdown(
                  label: 'Primary Subject (মূল বিষয়)',
                  hint: 'Select Subject',
                  isRequired: true,
                  items: _subjects,
                  value: _selectedSubject,
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSubject = val);
                  },
                ),
                const SizedBox(height: 16),

                CustomDateField(
                  label: 'Joining Date (যোগদানের তারিখ)',
                  value: _joinedDate,
                  onChanged: (date) {
                    setState(() => _joinedDate = date);
                  },
                ),
                const SizedBox(height: 24),
                Divider(color: colors.dividerColor),
                const SizedBox(height: 16),

                // Footer Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: colors.hintColor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ListenableBuilder(
                      listenable: _processStatusNotifier,
                      builder: (context, _) {
                        final isLoading =
                            _processStatusNotifier.status is ProcessLoading;
                        return ElevatedButton(
                          onPressed: isLoading ? null : _handleAssign,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            elevation: 0,
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
                                  'Confirm Assignment',
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
      ),
    );
  }
}
