import 'package:flutter/material.dart';

import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/di.dart';
import '../../../authentication/presentation/widgets/assign_pathshala_admin_dialog.dart';
import '../../../classes/presentation/view/academic_programs_view.dart';
import '../../../classes/presentation/view/class_schedule_view.dart';
import '../../../classes/presentation/widgets/add_pathshala_class_dialog.dart';
import '../../domain/pathshala_domain.dart';
import 'add_new_patshala_view.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/custom_section_header.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../controller/pathshala_details_controller.dart';
import '../../../../core/constants/app_sizes.dart';

const _bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
const _bnMonths = [
  'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
  'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর',
];

String _bn(Object value) {
  return value.toString().split('').map((c) {
    final digit = int.tryParse(c);
    return digit != null ? _bnDigits[digit] : c;
  }).join();
}

String _bnDate(DateTime date) {
  return '${_bn(date.day)} ${_bnMonths[date.month - 1]}, ${_bn(date.year)}';
}

class _StatInfo {
  final IconData icon;
  final String label;
  final String value;
  final Color tint;

  const _StatInfo({required this.icon, required this.label, required this.value, required this.tint});
}

class PatshalaDetailsView extends StatefulWidget {
  final Pathshala pathshala;

  const PatshalaDetailsView({super.key, required this.pathshala});

  @override
  State<PatshalaDetailsView> createState() => _PatshalaDetailsViewState();
}

class _PatshalaDetailsViewState extends State<PatshalaDetailsView> {
  static const _tabs = ['সারসংক্ষেপ', 'প্রশাসক', 'শিক্ষক', 'ক্লাস ও ব্যাচ', 'শিক্ষার্থী', 'উপস্থিতি'];

  final PathshalaDetailsController controller = sl.get<PathshalaDetailsController>();
  late final SnackbarNotifier snackbarNotifier;

  final int _selectedIndex = 1;
  int _selectedTab = 1;

  Future<void> _openAddClassDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AddPathshalaClassDialog(
        pathshala: widget.pathshala,
        pathshalaTeachers: controller.pathshalaTeachers,
        programs: controller.programs,
        onSave: (params) async {
          final ok = await controller.addClassGroup(params, snackbarNotifier: snackbarNotifier);
          if (!ok) throw StateError('Failed to create class');
        },
      ),
    );
    if (result == true) {
      snackbarNotifier.notifySuccess(message: 'নতুন ক্লাস ও ব্যাচ সফলভাবে খোলা হয়েছে');
    }
  }

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
    _loadDetails();
  }

  void _loadDetails() {
    controller.load(
      organizationId: widget.pathshala.organizationId,
      pathshalaId: widget.pathshala.id,
      snackbarNotifier: snackbarNotifier,
    );
  }

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  // Material's OutlinedButton.icon/ElevatedButton.icon throw a
  // "BoxConstraints forces an infinite width" layout error when nested as a
  // bare Row child without Expanded (their internal _InputPadding wrapper
  // can't resolve the unbounded main-axis constraint Row hands non-flex
  // children). The rest of the app avoids this by hand-rolling buttons with
  // InkWell + Container + Row — mirroring that here.
  Widget _pillButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required bool filled,
    required AppColors colors,
    bool expand = false,
  }) {
    final contentColor = filled ? Colors.white : colors.primaryColor;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: expand ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          color: filled ? colors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: filled ? null : Border.all(color: colors.primaryColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: contentColor),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: contentColor, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  List<_StatInfo> _stats(AppColors colors) {
    final isLoading = controller.processStatusNotifier.status is ProcessLoading;
    return [
      _StatInfo(
        icon: Icons.people_alt_outlined,
        label: 'শিক্ষার্থী',
        value: isLoading ? '—' : _bn(controller.studentsCount),
        tint: colors.primaryColor,
      ),
      _StatInfo(
        icon: Icons.record_voice_over_outlined,
        label: 'শিক্ষক',
        value: isLoading ? '—' : _bn(controller.teachersCount),
        tint: const Color(0xFFB8860B),
      ),
      // Attendance reporting isn't built yet (no session data exists to
      // aggregate a rate from), so this stays a placeholder dash rather
      // than a fabricated percentage.
      const _StatInfo(
        icon: Icons.event_available_outlined,
        label: 'উপস্থিতি',
        value: '—',
        tint: Color(0xFF2E7BC4),
      ),
      _StatInfo(
        icon: Icons.campaign_outlined,
        label: 'নোটিশ',
        value: isLoading ? '—' : _bn(controller.noticesCount),
        tint: colors.errorColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final pathshala = widget.pathshala;

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
                animation: Listenable.merge([controller, controller.processStatusNotifier]),
                builder: (context, _) => LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 640;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopRow(colors, pathshala),
                        const SizedBox(height: 20),
                        _buildHeaderCard(colors, pathshala, isNarrow),
                        SizedBox(height: AppSizes.sectionGap(context)),
                        _buildStatsGrid(colors, isNarrow),
                        SizedBox(height: AppSizes.sectionGap(context)),
                        _buildTabs(colors),
                        const SizedBox(height: 20),
                        _buildTabContent(colors, isNarrow),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
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

  Widget _buildTopRow(AppColors colors, Pathshala pathshala) {
    return AppBreadcrumbs(
      items: [
        BreadcrumbItem.home(context),
        BreadcrumbItem(
          label: 'পাঠশালা',
          icon: Icons.school_outlined,
          onTap: () => Navigator.of(context).maybePop(),
        ),
        BreadcrumbItem(
          label: pathshala.name,
        ),
      ],
    );
  }

  Widget _buildHeaderCard(AppColors colors, Pathshala pathshala, bool isNarrow) {
    final info = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
          child: Icon(Icons.account_balance_outlined, color: colors.primaryColor, size: 30),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 6,
                children: [
                  Text(
                    pathshala.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textColor),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: pathshala.isOperational ? const Color(0xFFE6F4EA) : colors.tileColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pathshala.isOperational ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: pathshala.isOperational ? const Color(0xFF1E7B34) : colors.hintColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: colors.hintColor),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      pathshala.address.formatted,
                      style: TextStyle(fontSize: 13, color: colors.textColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: colors.hintColor),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Head: ${controller.primaryAdministrator?.person.displayName ?? "এখনো নির্ধারিত হয়নি"}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: colors.textColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final editButton = _pillButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AddNewPatshalaView(existingPathshala: pathshala)))
            .then((_) => setState(() {}));
      },
      icon: Icons.edit_outlined,
      label: 'Edit',
      filled: false,
      colors: colors,
      expand: isNarrow,
    );

    final addClassButton = _pillButton(
      onPressed: _openAddClassDialog,
      icon: Icons.add,
      label: 'Add Class',
      filled: true,
      colors: colors,
      expand: isNarrow,
    );

    final scheduleButton = _pillButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ClassScheduleView(pathshala: pathshala)),
        );
      },
      icon: Icons.visibility_outlined,
      label: 'View Class Schedule',
      filled: true,
      colors: colors,
    );

    final actionsColumn = Column(
      crossAxisAlignment: isNarrow ? CrossAxisAlignment.stretch : CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            isNarrow ? Expanded(child: editButton) : editButton,
            const SizedBox(width: 12),
            isNarrow ? Expanded(child: addClassButton) : addClassButton,
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(width: isNarrow ? double.infinity : null, child: scheduleButton),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(shape: BoxShape.circle, color: colors.primaryColor.withValues(alpha: 0.05)),
            ),
          ),
          isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [info, const SizedBox(height: 20), actionsColumn],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: info),
                    const SizedBox(width: 16),
                    actionsColumn,
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(AppColors colors, bool isNarrow) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isNarrow ? 2 : 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 130,
      ),
      itemCount: _stats(colors).length,
      itemBuilder: (context, index) {
        final stat = _stats(colors)[index];
        return Container(
          padding: const EdgeInsets.all(18),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: -20,
                right: -20,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: stat.tint.withValues(alpha: 0.06)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: stat.tint.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(stat.icon, size: 18, color: stat.tint),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          stat.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    stat.value,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: colors.textColor),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabs(AppColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(bottom: BorderSide(color: colors.dividerColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < _tabs.length; i++)
              InkWell(
                onTap: () => setState(() => _selectedTab = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _selectedTab == i ? colors.primaryColor : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    _tabs[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _selectedTab == i ? FontWeight.bold : FontWeight.w500,
                      color: _selectedTab == i ? colors.primaryColor : colors.hintColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(AppColors colors, bool isNarrow) {
    if (_selectedTab == 2) {
      return _buildTeachersTab(colors, isNarrow);
    }
    if (_selectedTab == 3) {
      return _buildClassesTab(colors, isNarrow);
    }
    if (_selectedTab != 1) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Center(
          child: Text('${_tabs[_selectedTab]} — শীঘ্রই আসছে।', style: TextStyle(color: colors.hintColor)),
        ),
      );
    }

    final isLoading = controller.processStatusNotifier.status is ProcessLoading;
    final admin = controller.primaryAdministrator;

    Widget body;
    if (isLoading) {
      body = const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (admin == null) {
      body = Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        decoration: BoxDecoration(color: colors.tileColor, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.admin_panel_settings_outlined, size: 48, color: colors.hintColor.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text('কোনো প্রশাসক এখনো নিয়োগ করা হয়নি।', style: TextStyle(color: colors.hintColor, fontSize: 14)),
            const SizedBox(height: 16),
            _pillButton(
              onPressed: _openAssignAdminDialog,
              icon: Icons.person_add_alt_1_outlined,
              label: 'প্রশাসক নিয়োগ করুন',
              filled: true,
              colors: colors,
            ),
          ],
        ),
      );
    } else {
      final photo = CircleAvatar(
        radius: 40,
        backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
        child: Icon(Icons.person, color: colors.primaryColor, size: 40),
      );

      final details = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(admin.person.displayName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor)),
          const SizedBox(height: 2),
          Text(admin.membership.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryColor)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.call_outlined, size: 15, color: colors.hintColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  admin.person.primaryPhone ?? '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: colors.textColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.mail_outline, size: 15, color: colors.hintColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  admin.person.primaryEmail ?? '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: colors.textColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 15, color: colors.hintColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'যোগদান: ${_bnDate(admin.membership.effectiveFrom)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: colors.textColor),
                ),
              ),
            ],
          ),
        ],
      );

      final changeButton = _pillButton(
        onPressed: _openAssignAdminDialog,
        icon: Icons.manage_accounts_outlined,
        label: 'প্রশাসক পরিবর্তন',
        filled: false,
        colors: colors,
      );

      body = Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: colors.tileColor, borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Positioned(
              bottom: -20,
              right: -10,
              child: Icon(Icons.groups, size: 110, color: colors.primaryColor.withValues(alpha: 0.06)),
            ),
            isNarrow
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [photo, const SizedBox(width: 16), Expanded(child: details)]),
                      const SizedBox(height: 16),
                      SizedBox(width: double.infinity, child: changeButton),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      photo,
                      const SizedBox(width: 16),
                      Expanded(child: details),
                      changeButton,
                    ],
                  ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomSectionHeader(icon: Icons.shield_outlined, title: 'বর্তমান প্রশাসক'),
              _pillButton(
                onPressed: _openAssignAdminDialog,
                icon: Icons.person_add_alt_1_outlined,
                label: admin == null ? 'প্রশাসক নিয়োগ' : 'নতুন প্রশাসক নিয়োগ / পরিবর্তন',
                filled: true,
                colors: colors,
              ),
            ],
          ),
          const SizedBox(height: 16),
          body,
        ],
      ),
    );
  }

  void _openAssignAdminDialog() {
    AssignPathshalaAdminDialog.show(
      context,
      initialPathshalaId: widget.pathshala.id,
      onSuccess: _loadDetails,
    );
  }

  Widget _buildTeachersTab(AppColors colors, bool isNarrow) {
    final teachers = controller.pathshalaTeachers;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomSectionHeader(
                      icon: Icons.badge_outlined,
                      title: 'পাঠশালায় কর্মরত শিক্ষকবৃন্দ',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'কেন্দ্রীয় প্রশাসন কর্তৃক এই পাঠশালায় বরাদ্দকৃত শিক্ষকগণ (${teachers.length} জন)',
                      style: TextStyle(fontSize: 13, color: colors.hintColor),
                    ),
                  ],
                ),
              ),
              _pillButton(
                onPressed: () => AppSidebarNavigation.navigateToIndex(context, 4),
                icon: Icons.person_add_alt,
                label: 'নতুন শিক্ষক বরাদ্দ করুন',
                filled: false,
                colors: colors,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: colors.dividerColor),
          const SizedBox(height: 16),
          if (teachers.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: colors.tileColor, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Icon(Icons.badge_outlined, size: 48, color: colors.hintColor),
                  const SizedBox(height: 12),
                  Text(
                    'এই পাঠশালায় এখনো কোনো শিক্ষক বরাদ্দ করা হয়নি।',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.textColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'ব্যক্তি রেজিস্ট্রি থেকে যেকোনো ব্যক্তিকে শিক্ষক হিসেবে এই পাঠশালায় যুক্ত করুন।',
                    style: TextStyle(fontSize: 13, color: colors.hintColor),
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(colors.tileColor),
                    columns: const [
                      DataColumn(label: Text('শিক্ষকের নাম')),
                      DataColumn(label: Text('বিষয়')),
                      DataColumn(label: Text('পদবী / ভূমিকা')),
                      DataColumn(label: Text('স্ট্যাটাস')),
                    ],
                    rows: teachers.map((teacher) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                                  child: Icon(Icons.person_outline, size: 16, color: colors.primaryColor),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  teacher.name,
                                  style: TextStyle(fontWeight: FontWeight.w600, color: colors.textColor),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(teacher.subject.isNotEmpty ? teacher.subject : 'সাধারণ')),
                          DataCell(const Text('সহকারী শিক্ষক')),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'কার্যরত',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32)),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClassesTab(AppColors colors, bool isNarrow) {
    final classes = controller.classes;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomSectionHeader(
                      icon: Icons.meeting_room_outlined,
                      title: 'পাঠশালার ক্লাস ও ব্যাচসমূহ',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'চলমান বিভিন্ন স্তরের ক্লাস এবং তাদের জন্য নিযুক্ত শ্রেণি শিক্ষকগণ (${classes.length} টি শাখা)',
                      style: TextStyle(fontSize: 13, color: colors.hintColor),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  _pillButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AcademicProgramsView()),
                      );
                    },
                    icon: Icons.settings_outlined,
                    label: 'একাডেমিক প্রোগ্রাম পরিচালনা',
                    filled: false,
                    colors: colors,
                  ),
                  _pillButton(
                    onPressed: _openAddClassDialog,
                    icon: Icons.add,
                    label: 'নতুন ক্লাস / ব্যাচ খুলুন',
                    filled: true,
                    colors: colors,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: colors.dividerColor),
          const SizedBox(height: 16),
          if (classes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(color: colors.tileColor, borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Icon(Icons.meeting_room_outlined, size: 48, color: colors.hintColor),
                  const SizedBox(height: 12),
                  Text(
                    'এই পাঠশালায় এখনো কোনো ক্লাস বা ব্যাচ খোলা হয়নি।',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.textColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'উপরের "নতুন ক্লাস / ব্যাচ খুলুন" বোতাম ব্যবহার করে শ্রেণি বা লেভেলের শাখা তৈরি করুন।',
                    style: TextStyle(fontSize: 13, color: colors.hintColor),
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(colors.tileColor),
                    columns: const [
                      DataColumn(label: Text('শাখা / ব্যাচ')),
                      DataColumn(label: Text('স্তর / শ্রেণি')),
                      DataColumn(label: Text('শ্রেণি শিক্ষক (Class Teacher)')),
                      DataColumn(label: Text('কক্ষ ও আসন')),
                      DataColumn(label: Text('স্ট্যাটাস')),
                    ],
                    rows: classes.map((cls) {
                      final hasTeacher = cls.classTeacherName != null && cls.classTeacherName!.isNotEmpty;

                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                                  child: Icon(Icons.school_outlined, size: 14, color: colors.primaryColor),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  cls.name,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: colors.textColor),
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(cls.gradeLevel)),
                          DataCell(
                            hasTeacher
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: const Color(0xFFE8F5E9),
                                        child: const Icon(Icons.check, size: 12, color: Color(0xFF2E7D32)),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        cls.classTeacherName!,
                                        style: TextStyle(fontWeight: FontWeight.w600, color: colors.textColor),
                                      ),
                                    ],
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'অনির্ধারিত',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFE65100)),
                                    ),
                                  ),
                          ),
                          DataCell(Text('${cls.room ?? "—"} (ধারণক্ষমতা: ${cls.maxCapacity ?? 30})')),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'চলমান',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32)),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
