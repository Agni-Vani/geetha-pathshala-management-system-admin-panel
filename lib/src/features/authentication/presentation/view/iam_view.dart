import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/service_locator.dart';
import '../controller/iam_controller.dart';
import '../widgets/assign_pathshala_admin_dialog.dart';
import '../widgets/assign_role_dialog.dart';

class IamView extends StatefulWidget {
  final IamController? controller;

  const IamView({super.key, this.controller});

  @override
  State<IamView> createState() => _IamViewState();
}

class _IamViewState extends State<IamView> with SingleTickerProviderStateMixin {
  late final IamController _controller;
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  static const int _selectedIndex = 11;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? sl<IamController>();
    _tabController = TabController(length: 2, vsync: this);
    _controller.loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
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
            child: SingleChildScrollView(
              padding: AppSizes.pagePadding(context),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Breadcrumbs
                      AppBreadcrumbs(
                        items: [
                          BreadcrumbItem.home(context),
                          const BreadcrumbItem(
                            label: 'IAM (Identity & Access Management)',
                            icon: Icons.admin_panel_settings_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Header & Action
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 600;

                          final titleCol = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'IAM',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: colors.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primaryColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: colors.primaryColor.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Text(
                                      'Identity & Access Management',
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
                                'সিস্টেম ব্যবহারকারী, ভূমিকা (Roles) এবং অ্যাক্সেস অনুমতি পরিচালনা করুন।',
                                style: TextStyle(color: colors.hintColor, fontSize: 13.5),
                              ),
                            ],
                          );

                          final createAdminBtn = InkWell(
                            borderRadius: AppSizes.bigRectangleTileRadius,
                            onTap: () => AssignPathshalaAdminDialog.show(
                              context,
                              onSuccess: _controller.loadData,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: colors.tileColor,
                                borderRadius: AppSizes.bigRectangleTileRadius,
                                border: Border.all(color: colors.primaryColor),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.admin_panel_settings_outlined, color: colors.primaryColor, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'পাঠশালা প্রশাসক তৈরি',
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

                          final assignBtn = InkWell(
                            borderRadius: AppSizes.bigRectangleTileRadius,
                            onTap: () => AssignRoleDialog.show(
                              context,
                              controller: _controller,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primaryColor,
                                borderRadius: AppSizes.bigRectangleTileRadius,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_moderator_outlined, color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'নতুন ভূমিকা বরাদ্দ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                          final actions = Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              createAdminBtn,
                              assignBtn,
                            ],
                          );

                          if (isNarrow) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titleCol,
                                const SizedBox(height: 14),
                                actions,
                              ],
                            );
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: titleCol),
                              actions,
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Metrics Cards
                      _buildMetrics(colors),
                      const SizedBox(height: 24),

                      // Tab Bar Switcher
                      Container(
                        decoration: BoxDecoration(
                          color: colors.tileColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colors.borderColor),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: colors.primaryColor,
                          labelColor: colors.primaryColor,
                          unselectedLabelColor: colors.hintColor,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.people_outline, size: 18),
                              text: 'ব্যবহারকারী ও বরাদ্দকৃত ভূমিকা',
                            ),
                            Tab(
                              icon: Icon(Icons.security_outlined, size: 18),
                              text: 'সিস্টেম রোল ও অনুমতি',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tab Contents
                      AnimatedBuilder(
                        animation: _tabController,
                        builder: (context, _) {
                          if (_tabController.index == 0) {
                            return _buildUsersTab(colors);
                          } else {
                            return _buildRolesTab(colors);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            color: colors.tileColor,
            height: 40,
            child: Center(
              child: Text(
                '© 2026 Geetha Pathshala Management. All rights reserved.',
                style: TextStyle(fontSize: 12, color: colors.hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics(AppColors colors) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 640
            ? 2
            : constraints.maxWidth < 1000
                ? 3
                : 4;

        final items = [
          _MetricItem(
            label: 'মোট ব্যবহারকারী',
            value: '${_controller.users.length}',
            icon: Icons.people_alt_outlined,
            color: Colors.blue,
          ),
          _MetricItem(
            label: 'বরাদ্দকৃত ভূমিকা',
            value: '${_controller.allUserRoles.where((r) => r.isCurrentlyEffective).length}',
            icon: Icons.assignment_ind_outlined,
            color: Colors.green,
          ),
          _MetricItem(
            label: 'সিস্টেম রোল',
            value: '${_controller.roles.length}',
            icon: Icons.shield_outlined,
            color: Colors.orange,
          ),
          _MetricItem(
            label: 'পারমিশন কোড',
            value: '${_controller.permissions.length}',
            icon: Icons.lock_open_outlined,
            color: Colors.purple,
          ),
        ];

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            final cardWidth =
                (constraints.maxWidth - (crossAxisCount - 1) * 12) / crossAxisCount;

            return Container(
              width: cardWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: colors.tileColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: colors.borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item.icon, color: item.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.value,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors.textColor,
                          ),
                        ),
                        Text(
                          item.label,
                          style: TextStyle(fontSize: 12, color: colors.hintColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildUsersTab(AppColors colors) {
    final filteredUsers = _controller.filteredUsers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter bar
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 600;

            final searchField = SizedBox(
              width: isNarrow ? double.infinity : 280,
              height: 40,
              child: TextField(
                controller: _searchController,
                onChanged: _controller.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'ইমেইল বা নাম খুঁজুন...',
                  hintStyle: TextStyle(fontSize: 13, color: colors.hintColor),
                  prefixIcon: Icon(Icons.search, size: 18, color: colors.hintColor),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  filled: true,
                  fillColor: colors.tileColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors.borderColor),
                  ),
                ),
              ),
            );

            final roleFilter = Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: colors.tileColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.borderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  value: _controller.selectedRoleFilter,
                  hint: Text(
                    'সকল ভূমিকা',
                    style: TextStyle(fontSize: 13, color: colors.hintColor),
                  ),
                  dropdownColor: colors.backgroundColor,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(
                        'সকল ভূমিকা',
                        style: TextStyle(fontSize: 13, color: colors.textColor),
                      ),
                    ),
                    ..._controller.roles.map((r) => DropdownMenuItem(
                          value: r.code,
                          child: Text(
                            r.name,
                            style: TextStyle(fontSize: 13, color: colors.textColor),
                          ),
                        )),
                  ],
                  onChanged: _controller.setRoleFilter,
                ),
              ),
            );

            if (isNarrow) {
              return Column(
                children: [
                  searchField,
                  const SizedBox(height: 10),
                  Align(alignment: Alignment.centerLeft, child: roleFilter),
                ],
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                searchField,
                roleFilter,
              ],
            );
          },
        ),
        const SizedBox(height: 16),

        // Users List
        if (filteredUsers.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: colors.tileColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.borderColor),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 40, color: colors.hintColor),
                  const SizedBox(height: 8),
                  Text(
                    'কোনো ব্যবহারকারী পাওয়া যায়নি',
                    style: TextStyle(color: colors.hintColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: colors.tileColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.borderColor),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredUsers.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: colors.dividerColor),
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                final person = _controller.personMap[user.personId];
                final roles = _controller.rolesForUser(user.id);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 640;

                      final userDetails = Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: colors.primaryColor.withValues(alpha: 0.15),
                            child: Text(
                              (user.email.isNotEmpty ? user.email[0] : 'U').toUpperCase(),
                              style: TextStyle(
                                color: colors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
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
                                        person?.displayName ?? user.email,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: colors.textColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (person != null) ...[
                                      const SizedBox(width: 8),
                                      Text(
                                        '(${user.email})',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: colors.hintColor,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: roles.isEmpty
                                      ? [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colors.borderColor,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'কোনো ভূমিকা নেই',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: colors.hintColor,
                                              ),
                                            ),
                                          )
                                        ]
                                      : roles.map((r) {
                                          final isSuper = r.roleCode.toUpperCase() == 'SUPERADMIN';
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSuper
                                                  ? Colors.amber.withValues(alpha: 0.15)
                                                  : colors.primaryColor.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(
                                                color: isSuper
                                                    ? Colors.amber.shade700
                                                    : colors.primaryColor.withValues(alpha: 0.4),
                                              ),
                                            ),
                                            child: Text(
                                              r.roleCode,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: isSuper
                                                    ? Colors.amber.shade900
                                                    : colors.primaryColor,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );

                      final actionButton = InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () => AssignRoleDialog.show(
                          context,
                          controller: _controller,
                          initialUser: user,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: colors.primaryColor.withValues(alpha: 0.4)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit_outlined, size: 14, color: colors.primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                'ভূমিকা বরাদ্দ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: colors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      if (isMobile) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            userDetails,
                            const SizedBox(height: 10),
                            actionButton,
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: userDetails),
                          actionButton,
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRolesTab(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'সিস্টেম রোল ও অনুমতি কনফিগারেশন',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: colors.textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'প্রতিটি রোলে নির্ধারিত পারমিশন কোড ও আওতা (Scope)',
          style: TextStyle(fontSize: 12.5, color: colors.hintColor),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _controller.roles.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final role = _controller.roles[index];

                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.tileColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colors.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.security,
                              color: colors.primaryColor,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      role.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: colors.textColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.borderColor,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        role.code,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: colors.hintColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Scope: ${role.scopeType.name.toUpperCase()}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: colors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (role.description != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    role.description!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colors.hintColor,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Divider(height: 1, color: colors.dividerColor),
                      const SizedBox(height: 12),
                      Text(
                        'অনুমোদিত পারমিশনসমূহ:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colors.textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: role.permissionCodes.map((code) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: colors.backgroundColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: colors.borderColor),
                            ),
                            child: Text(
                              code == '*' ? 'ALL PERMISSIONS (*)' : code,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: code == '*' ? Colors.amber.shade800 : colors.textColor,
                                fontWeight: code == '*' ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _MetricItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}
