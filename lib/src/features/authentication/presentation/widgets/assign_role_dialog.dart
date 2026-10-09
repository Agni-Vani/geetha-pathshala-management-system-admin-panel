import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../pathshala/domain/entities/pathshala.dart';
import '../../domain/entities/entities.dart';
import '../controller/iam_controller.dart';

class AssignRoleDialog extends StatefulWidget {
  final IamController controller;
  final UserAccount? initialUser;

  const AssignRoleDialog({
    super.key,
    required this.controller,
    this.initialUser,
  });

  static Future<void> show(
    BuildContext context, {
    required IamController controller,
    UserAccount? initialUser,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AssignRoleDialog(
        controller: controller,
        initialUser: initialUser,
      ),
    );
  }

  @override
  State<AssignRoleDialog> createState() => _AssignRoleDialogState();
}

class _AssignRoleDialogState extends State<AssignRoleDialog> {
  final _processNotifier = ProcessStatusNotifier(initialStatus: ProcessEnabled());

  UserAccount? _selectedUser;
  Role? _selectedRole;
  Pathshala? _selectedPathshala;

  @override
  void initState() {
    super.initState();
    _selectedUser = widget.initialUser ??
        (widget.controller.users.isNotEmpty ? widget.controller.users.first : null);
    _selectedRole = widget.controller.roles.isNotEmpty
        ? widget.controller.roles.first
        : null;
    if (widget.controller.pathshalas.isNotEmpty) {
      _selectedPathshala = widget.controller.pathshalas.first;
    }
  }

  Future<void> _handleSubmit() async {
    if (_selectedUser == null || _selectedRole == null) {
      return;
    }

    _processNotifier.setLoading();

    final isPathshalaScoped = _selectedRole!.scopeType == RoleScopeType.pathshala;
    final pathshalaId = isPathshalaScoped ? _selectedPathshala?.id : null;

    final snackbar = SnackbarNotifier(context: context);
    final success = await widget.controller.assignRole(
      userAccountId: _selectedUser!.id,
      roleId: _selectedRole!.id,
      scopeType: _selectedRole!.scopeType,
      scopePathshalaId: pathshalaId,
      snackbarNotifier: snackbar,
    );

    if (mounted) {
      if (success) {
        Navigator.of(context).pop();
      } else {
        _processNotifier.setError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final isPathshalaScoped = _selectedRole?.scopeType == RoleScopeType.pathshala;

    return Dialog(
      backgroundColor: colors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
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
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.primaryColor.withValues(alpha: 0.12),
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
                            'নতুন ভূমিকা বরাদ্দ করুন',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'ব্যবহারকারী একাউন্টে উপযুক্ত রোল ও স্কোপ নির্ধারণ করুন',
                            style: TextStyle(fontSize: 12, color: colors.hintColor),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: colors.hintColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: colors.dividerColor),
                const SizedBox(height: 16),

                // User Selector
                Text(
                  'ব্যবহারকারী একাউন্ট (User Account)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.tileColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.borderColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<UserAccount>(
                      value: _selectedUser,
                      isExpanded: true,
                      dropdownColor: colors.backgroundColor,
                      items: widget.controller.users.map((u) {
                        final person = widget.controller.personMap[u.personId];
                        final label = person != null
                            ? '${person.displayName} (${u.email})'
                            : u.email;
                        return DropdownMenuItem(
                          value: u,
                          child: Text(
                            label,
                            style: TextStyle(fontSize: 13, color: colors.textColor),
                          ),
                        );
                      }).toList(),
                      onChanged: widget.initialUser != null
                          ? null
                          : (val) => setState(() => _selectedUser = val),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Role Selector
                Text(
                  'ভূমিকা / রোল (Role)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.tileColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.borderColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Role>(
                      value: _selectedRole,
                      isExpanded: true,
                      dropdownColor: colors.backgroundColor,
                      items: widget.controller.roles.map((r) {
                        return DropdownMenuItem(
                          value: r,
                          child: Row(
                            children: [
                              Text(
                                r.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colors.primaryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  r.scopeType.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: colors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedRole = val),
                    ),
                  ),
                ),
                if (_selectedRole?.description != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    _selectedRole!.description!,
                    style: TextStyle(fontSize: 12, color: colors.hintColor),
                  ),
                ],

                // Pathshala Selector (if scoped)
                if (isPathshalaScoped) ...[
                  const SizedBox(height: 16),
                  Text(
                    'পাঠশালা নির্ধারণ করুন (Scope Pathshala)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.tileColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.borderColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Pathshala>(
                        value: _selectedPathshala,
                        isExpanded: true,
                        dropdownColor: colors.backgroundColor,
                        items: widget.controller.pathshalas.map((p) {
                          return DropdownMenuItem(
                            value: p,
                            child: Text(
                              p.name,
                              style: TextStyle(fontSize: 13, color: colors.textColor),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _selectedPathshala = val),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                Divider(color: colors.dividerColor),
                const SizedBox(height: 16),

                // Footer Buttons (InkWell + Container to avoid infinite width)
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
                      listenable: _processNotifier,
                      builder: (context, _) {
                        final isLoading =
                            _processNotifier.status is ProcessLoading;

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
                                : const Text(
                                    'ভূমিকা বরাদ্দ নিশ্চিত করুন',
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
      ),
    );
  }
}
