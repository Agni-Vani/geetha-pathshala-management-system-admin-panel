import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/widget/app_background.dart';
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

  // The background illustration starts right under the tab bar, as on the
  // pathshala list; these locate it after layout.
  // Lazy so a hot reload that adds them to a live state still works.
  late final GlobalKey _contentKey = GlobalKey();
  late final GlobalKey _tabBarKey = GlobalKey();

  // The tab contents card stretches to the bottom of the viewport; its
  // minimum height is whatever the header above it leaves free.
  late final GlobalKey _listCardKey = GlobalKey();
  double? _listCardMinHeight;

  /// Below this viewport height the header can no longer stay pinned.
  static const double _pinnedHeaderMinHeight = 620;

  /// The card holding the active tab's contents. With [scrolls] it fills the
  /// space it is given and scrolls inside; otherwise it grows with its
  /// contents (at least down to the viewport's bottom) and the page scrolls.
  Widget _contentsCard(AppColors colors, {required bool scrolls}) {
    final padding = EdgeInsets.all(AppSizes.isCompact(context) ? 12 : 20);
    final tab = AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) => _tabController.index == 0
          ? _buildUsersTab(colors)
          : _buildRolesTab(colors),
    );
    return Container(
      key: _listCardKey,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      constraints: scrolls
          ? null
          : BoxConstraints(minHeight: _listCardMinHeight ?? 0),
      padding: scrolls ? null : padding,
      decoration: BoxDecoration(
        color: _cardSurfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.ornamentColor.withValues(alpha: .6)),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor.withValues(alpha: .06),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: scrolls
          ? SingleChildScrollView(padding: padding, child: tab)
          : tab,
    );
  }

  void _measureListCard(double viewportHeight) {
    final content =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    final card = _listCardKey.currentContext?.findRenderObject() as RenderBox?;
    if (content == null || card == null) return;
    if (!content.hasSize || !card.hasSize) return;
    final top = card.localToGlobal(Offset.zero, ancestor: content).dy;
    final minHeight =
        (viewportHeight - AppSizes.pagePadding(context).vertical - top).clamp(
          0.0,
          double.infinity,
        );
    if (((_listCardMinHeight ?? 0) - minHeight).abs() > .5) {
      setState(() => _listCardMinHeight = minHeight);
    }
  }

  Color get _cardSurfaceColor => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF13201F)
      : Colors.white;

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
      showBackgroundImage: false,
      body: Column(
        children: [
          Expanded(
            child: IllustrationBelowAnchor(
              contentKey: _contentKey,
              anchorKey: _tabBarKey,
              contentTop: AppSizes.pagePadding(context).top,
              child: LayoutBuilder(
                builder: (context, viewport) {
                  // With room to spare the header stays put and only the
                  // card's contents scroll. A short viewport (landscape
                  // phone) cannot fit the header and a usable card, so the
                  // whole page scrolls there instead.
                  final pinHeader =
                      viewport.maxHeight >= _pinnedHeaderMinHeight;
                  if (!pinHeader) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) _measureListCard(viewport.maxHeight);
                    });
                  }
                  final content = AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Column(
                        key: _contentKey,
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
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 6,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        'IAM',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: colors.primaryColor,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colors.primaryColor.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: colors.primaryColor
                                                .withValues(alpha: 0.3),
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
                                    style: TextStyle(
                                      color: colors.hintColor,
                                      fontSize: 13.5,
                                    ),
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
                                  alignment: isNarrow ? Alignment.center : null,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _cardSurfaceColor,
                                    borderRadius:
                                        AppSizes.bigRectangleTileRadius,
                                    border: Border.all(
                                      color: colors.primaryColor,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add_rounded,
                                        color: colors.primaryColor,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'পাঠশালা প্রশাসক তৈরি',
                                          style: TextStyle(
                                            color: colors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
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
                                  alignment: isNarrow ? Alignment.center : null,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.primaryColor,
                                    // Matches the outlined button's border so the
                                    // pair measures the same.
                                    border: Border.all(
                                      color: colors.primaryColor,
                                    ),
                                    borderRadius:
                                        AppSizes.bigRectangleTileRadius,
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.add_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'নতুন ভূমিকা বরাদ্দ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                              final actions = Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [createAdminBtn, assignBtn],
                              );

                              if (isNarrow) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titleCol,
                                    const SizedBox(height: 14),
                                    // Stacked under the title the two buttons
                                    // share the row equally, at one height.
                                    IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(child: createAdminBtn),
                                          const SizedBox(width: 10),
                                          Expanded(child: assignBtn),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: titleCol),
                                  Flexible(child: actions),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 12),

                          // Metrics Cards
                          _buildMetrics(colors),
                          const SizedBox(height: 20),

                          // Tab Bar Switcher — flat on the header surface, closed
                          // by a divider the illustration starts under.
                          SizedBox(
                            key: _tabBarKey,
                            width: double.infinity,
                            child: TabBar(
                              controller: _tabController,
                              dividerColor: colors.dividerColor.withValues(
                                alpha: .7,
                              ),
                              // No ripple or hover wash on tap.
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: const WidgetStatePropertyAll(
                                Colors.transparent,
                              ),
                              // A line under the selected tab's own label.
                              indicator: UnderlineTabIndicator(
                                borderSide: BorderSide(
                                  color: colors.primaryColor,
                                  width: 2.5,
                                ),
                              ),
                              indicatorSize: TabBarIndicatorSize.label,
                              labelColor: colors.primaryColor,
                              unselectedLabelColor: colors.hintColor,
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              unselectedLabelStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                              tabs: [
                                _tab(
                                  Icons.people_outline,
                                  'ব্যবহারকারী ও বরাদ্দকৃত ভূমিকা',
                                ),
                                _tab(
                                  Icons.security_outlined,
                                  'সিস্টেম রোল ও অনুমতি',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (pinHeader)
                            Expanded(
                              child: _contentsCard(colors, scrolls: true),
                            )
                          else
                            _contentsCard(colors, scrolls: false),
                        ],
                      );
                    },
                  );
                  if (pinHeader) {
                    return Padding(
                      padding: AppSizes.pagePadding(context),
                      child: content,
                    );
                  }
                  return SingleChildScrollView(
                    padding: AppSizes.pagePadding(context),
                    child: content,
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

  /// A single-line tab: icon beside the label rather than stacked above it,
  /// which keeps the tab bar short.
  Widget _tab(IconData icon, String label) {
    return Tab(
      height: 34,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics(AppColors colors) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Without card chrome the figures are slim enough to sit four in a
        // row from tablet widths up, so none is orphaned on a second line.
        final crossAxisCount = constraints.maxWidth < 640 ? 2 : 4;

        final items = [
          _MetricItem(
            label: 'মোট ব্যবহারকারী',
            value: '${_controller.users.length}',
            icon: Icons.people_alt_outlined,
            color: Colors.blue,
          ),
          _MetricItem(
            label: 'বরাদ্দকৃত ভূমিকা',
            value:
                '${_controller.allUserRoles.where((r) => r.isCurrentlyEffective).length}',
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
                (constraints.maxWidth - (crossAxisCount - 1) * 12) /
                crossAxisCount;

            // Plain figures on the page surface — no card behind them.
            return Container(
              width: cardWidth,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
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
                          style: TextStyle(
                            fontSize: 12,
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
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: colors.hintColor,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
                  filled: true,
                  fillColor: _cardSurfaceColor,
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
              width: isNarrow ? double.infinity : 240,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _cardSurfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.borderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  isExpanded: true,
                  value: _controller.selectedRoleFilter,
                  hint: Text(
                    'সকল ভূমিকা',
                    style: TextStyle(fontSize: 13, color: colors.hintColor),
                  ),
                  dropdownColor: _cardSurfaceColor,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(
                        'সকল ভূমিকা',
                        style: TextStyle(fontSize: 13, color: colors.textColor),
                      ),
                    ),
                    ..._controller.roles.map(
                      (r) => DropdownMenuItem(
                        value: r.code,
                        child: Text(
                          r.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.textColor,
                          ),
                        ),
                      ),
                    ),
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
              children: [searchField, roleFilter],
            );
          },
        ),
        const SizedBox(height: 16),

        // Users List
        if (filteredUsers.isEmpty)
          Padding(
            padding: const EdgeInsets.all(40),
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
              color: _cardSurfaceColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.borderColor),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredUsers.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: colors.dividerColor),
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                final person = _controller.personMap[user.personId];
                final roles = _controller.rolesForUser(user.id);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 640;

                      final userDetails = Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: colors.primaryColor.withValues(
                              alpha: 0.15,
                            ),
                            child: Text(
                              (user.email.isNotEmpty ? user.email[0] : 'U')
                                  .toUpperCase(),
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
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    Text(
                                      person?.displayName ?? user.email,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: colors.textColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (person != null) ...[
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
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              'কোনো ভূমিকা নেই',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: colors.hintColor,
                                              ),
                                            ),
                                          ),
                                        ]
                                      : roles.map((r) {
                                          final isSuper =
                                              r.roleCode.toUpperCase() ==
                                              'SUPERADMIN';
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSuper
                                                  ? Colors.amber.withValues(
                                                      alpha: 0.15,
                                                    )
                                                  : colors.primaryColor
                                                        .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: isSuper
                                                    ? Colors.amber.shade700
                                                    : colors.primaryColor
                                                          .withValues(
                                                            alpha: 0.4,
                                                          ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colors.primaryColor.withValues(alpha: 0.4),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 14,
                                color: colors.primaryColor,
                              ),
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
                    color: _cardSurfaceColor,
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
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 6,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      role.name,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: colors.textColor,
                                      ),
                                    ),
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.primaryColor.withValues(
                                          alpha: 0.1,
                                        ),
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
                              color: _cardSurfaceColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: colors.borderColor),
                            ),
                            child: Text(
                              code == '*' ? 'ALL PERMISSIONS (*)' : code,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: code == '*'
                                    ? Colors.amber.shade800
                                    : colors.textColor,
                                fontWeight: code == '*'
                                    ? FontWeight.bold
                                    : FontWeight.normal,
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
