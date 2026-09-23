import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../registry/presentation/widgets/custom_widgets/custom_button.dart';
import '../../../registry/presentation/widgets/custom_widgets/custom_status_badge.dart';
import '../../../registry/presentation/widgets/custom_widgets/responsive_app_shell.dart';
import '../../../registry/presentation/view/registry_sidebar_navigation.dart';
import '../../../../core/constants/app_sizes.dart';

class _AttendanceSummary {
  final IconData icon;
  final String value;
  final String label;
  final Color tint;

  const _AttendanceSummary({
    required this.icon,
    required this.value,
    required this.label,
    required this.tint,
  });
}

class _AttendanceRow {
  final String name;
  final String studentClass;
  final String pathshala;
  final bool isPresent;

  const _AttendanceRow({
    required this.name,
    required this.studentClass,
    required this.pathshala,
    required this.isPresent,
  });
}

// TODO: static design-stage data — swap for RecordAttendance/session
// aggregates once a "list today's attendance" usecase exists.
const _demoSummary = [
  _AttendanceSummary(
    icon: Icons.groups_outlined,
    value: '৮৫',
    label: 'Total Students',
    tint: Color(0xFF1565C0),
  ),
  _AttendanceSummary(
    icon: Icons.check_circle_outline,
    value: '৭৮',
    label: 'Present',
    tint: Color(0xFF1E7B34),
  ),
  _AttendanceSummary(
    icon: Icons.cancel_outlined,
    value: '৭',
    label: 'Absent',
    tint: Color(0xFFBA1A1A),
  ),
  _AttendanceSummary(
    icon: Icons.pie_chart_outline,
    value: '৯২%',
    label: 'Attendance %',
    tint: Color(0xFFAD6800),
  ),
];

const _demoAttendance = [
  _AttendanceRow(
    name: 'অনন্যা শর্মা',
    studentClass: 'শ্রেণি ৫',
    pathshala: 'Chattogram North Gita Pathshala',
    isPresent: true,
  ),
  _AttendanceRow(
    name: 'বিবান পাটেল',
    studentClass: 'শ্রেণি ৬',
    pathshala: 'Dhaka Central Gita Pathshala',
    isPresent: true,
  ),
  _AttendanceRow(
    name: 'ইশিকা ভার্মা',
    studentClass: 'শ্রেণি ৪',
    pathshala: 'Sylhet East Gita Pathshala',
    isPresent: false,
  ),
  _AttendanceRow(
    name: 'কৃষ্ণ তিওয়ারি',
    studentClass: 'শ্রেণি ৭',
    pathshala: 'Chattogram North Gita Pathshala',
    isPresent: true,
  ),
  _AttendanceRow(
    name: 'মায়রা জোশী',
    studentClass: 'শ্রেণি ৩',
    pathshala: 'Dhaka Central Gita Pathshala',
    isPresent: true,
  ),
];

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  final ScrollController _tableScrollController = ScrollController();

  int _selectedIndex = 5;

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  @override
  void dispose() {
    _tableScrollController.dispose();
    super.dispose();
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
            child: SingleChildScrollView(
              padding: AppSizes.pagePadding(context),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 640;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(colors, isNarrow),
                      SizedBox(height: AppSizes.sectionGap(context)),
                      _buildSummaryGrid(colors, isNarrow),
                      SizedBox(height: AppSizes.sectionGap(context)),
                      _buildTable(colors),
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
                '© 2024 Geetha Pathshala Management. All rights reserved.',
                style: TextStyle(fontSize: 12, color: colors.hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppColors colors, bool isNarrow) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'উপস্থিতি',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colors.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'আজকের ক্লাস-ভিত্তিক উপস্থিতির সারসংক্ষেপ ও রেকর্ড।',
          style: TextStyle(color: colors.hintColor),
        ),
      ],
    );

    final exportButton = SizedBox(
      width: isNarrow ? double.infinity : null,
      child: CustomButton(
        label: 'Export Report',
        icon: Icons.download_outlined,
        onPressed: () {},
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleBlock, const SizedBox(height: 16), exportButton],
      );
    }

    // CustomButton needs a bounded width here — a bare Row child otherwise
    // gets an unbounded main-axis width, crashing Material's tap-target
    // padding. IntrinsicWidth bounds it to its natural content size.
    return Row(
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        IntrinsicWidth(child: exportButton),
      ],
    );
  }

  Widget _buildSummaryGrid(AppColors colors, bool isNarrow) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isNarrow ? 2 : 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 110,
      ),
      itemCount: _demoSummary.length,
      itemBuilder: (context, index) {
        final item = _demoSummary[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colors.shadowColor,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.tint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.tint, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textColor,
                      ),
                    ),
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: colors.hintColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTable(AppColors colors) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Scrollbar(
          controller: _tableScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _tableScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(bottom: 12),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(colors.tileColor),
                columns: const [
                  DataColumn(label: Text('নাম')),
                  DataColumn(label: Text('শ্রেণি')),
                  DataColumn(label: Text('পাঠশালা')),
                  DataColumn(label: Text('স্ট্যাটাস')),
                ],
                rows: [
                  for (final row in _demoAttendance)
                    DataRow(
                      cells: [
                        DataCell(
                          Text(
                            row.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: colors.textColor,
                            ),
                          ),
                        ),
                        DataCell(Text(row.studentClass)),
                        DataCell(Text(row.pathshala)),
                        DataCell(
                          CustomStatusBadge(
                            label: row.isPresent ? 'Present' : 'Absent',
                            tone: row.isPresent
                                ? StatusTone.positive
                                : StatusTone.negative,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
