import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/custom_widgets/custom_button.dart';
import '../widgets/custom_widgets/responsive_app_shell.dart';
import 'registry_sidebar_navigation.dart';

class _ReportType {
  final IconData icon;
  final String title;
  final String description;
  final Color tint;

  const _ReportType({required this.icon, required this.title, required this.description, required this.tint});
}

const _reportTypes = [
  _ReportType(
    icon: Icons.how_to_reg_outlined,
    title: 'Attendance Report',
    description: 'উপস্থিতির সারসংক্ষেপ দেখুন।',
    tint: Color(0xFF1565C0),
  ),
  _ReportType(
    icon: Icons.groups_outlined,
    title: 'Student Report',
    description: 'শিক্ষার্থীদের বিস্তারিত তথ্য দেখুন।',
    tint: Color(0xFF1E7B34),
  ),
  _ReportType(
    icon: Icons.badge_outlined,
    title: 'Teacher Report',
    description: 'শিক্ষকদের বিস্তারিত তথ্য দেখুন।',
    tint: Color(0xFFAD6800),
  ),
  _ReportType(
    icon: Icons.trending_up_outlined,
    title: 'Performance Report',
    description: 'পারফরম্যান্স বিশ্লেষণ দেখুন।',
    tint: Color(0xFFBA1A1A),
  ),
];

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  int _selectedIndex = 8;

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    RegistrySidebarNavigation.pushReplacement(context, index);
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
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 640;
                  final crossAxisCount = constraints.maxWidth < 640
                      ? 1
                      : constraints.maxWidth < 1000
                          ? 2
                          : 4;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(colors, isNarrow),
                      const SizedBox(height: 24),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 190,
                        ),
                        itemCount: _reportTypes.length,
                        itemBuilder: (context, index) => _buildReportCard(colors, _reportTypes[index]),
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
        Text('রিপোর্ট', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colors.primaryColor)),
        const SizedBox(height: 4),
        Text('বিভিন্ন ধরনের রিপোর্ট তৈরি ও পর্যালোচনা করুন।', style: TextStyle(color: colors.hintColor)),
      ],
    );

    final dateRange = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.tileColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_outlined, size: 16, color: colors.hintColor),
          const SizedBox(width: 8),
          const Flexible(
            child: Text(
              'May 1, 2024 – May 20, 2024',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );

    if (isNarrow) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleBlock, const SizedBox(height: 16), dateRange]);
    }

    return Row(children: [Expanded(child: titleBlock), const SizedBox(width: 16), dateRange]);
  }

  Widget _buildReportCard(AppColors colors, _ReportType report) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: report.tint.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(report.icon, color: report.tint, size: 22),
          ),
          const SizedBox(height: 14),
          Text(report.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.textColor)),
          const SizedBox(height: 4),
          Text(report.description, style: TextStyle(fontSize: 12, color: colors.hintColor)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: CustomButton.outlined(label: 'View Report', onPressed: () {}),
          ),
        ],
      ),
    );
  }
}
