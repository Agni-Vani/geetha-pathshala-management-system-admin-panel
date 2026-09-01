import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/custom_widgets/responsive_app_shell.dart';
import 'registry_sidebar_navigation.dart';

class _OverviewStat {
  final IconData icon;
  final String value;
  final String label;
  final String delta;
  final Color tint;

  const _OverviewStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.delta,
    required this.tint,
  });
}

// TODO: static design-stage data — wire to real aggregate usecases
// (ListPathshalas, education/attendance counts) once available.
const _overviewStats = [
  _OverviewStat(icon: Icons.account_balance_outlined, value: '২৪', label: 'Total Pathshalas', delta: '+২ এই মাসে', tint: Color(0xFF1565C0)),
  _OverviewStat(icon: Icons.people_alt_outlined, value: '১,২৪৮', label: 'Total Students', delta: '+১৫৬ এই মাসে', tint: Color(0xFF1E7B34)),
  _OverviewStat(icon: Icons.badge_outlined, value: '৮৬', label: 'Total Teachers', delta: '+৮ এই মাসে', tint: Color(0xFFAD6800)),
  _OverviewStat(icon: Icons.how_to_reg_outlined, value: '৯২.৫%', label: 'Attendance Today', delta: '+২.৩% গতকাল থেকে', tint: Color(0xFFBA1A1A)),
];

const _weeklyAttendance = [70, 76, 82, 88, 79, 91, 85];
const _weeklyLabels = ['সোম', 'মঙ্গল', 'বুধ', 'বৃহঃ', 'শুক্র', 'শনি', 'রবি'];

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

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
                  final isStacked = constraints.maxWidth < 900;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ড্যাশবোর্ড', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colors.primaryColor)),
                      const SizedBox(height: 4),
                      Text(
                        'স্বাগতম, Admin! আপনার পাঠশালা সিস্টেমে এখন যা ঘটছে তার সারসংক্ষেপ।',
                        style: TextStyle(color: colors.hintColor),
                      ),
                      const SizedBox(height: 24),
                      _buildStatsGrid(colors, isNarrow),
                      const SizedBox(height: 24),
                      isStacked
                          ? Column(
                              children: [
                                _buildAttendanceCard(colors),
                                const SizedBox(height: 20),
                                _buildGenderCard(colors),
                              ],
                            )
                          : IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(flex: 2, child: _buildAttendanceCard(colors)),
                                  const SizedBox(width: 20),
                                  Expanded(child: _buildGenderCard(colors)),
                                ],
                              ),
                            ),
                      const SizedBox(height: 20),
                      isStacked
                          ? Column(
                              children: [
                                _buildNoticesCard(colors),
                                const SizedBox(height: 20),
                                _buildEventsCard(colors),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: _buildNoticesCard(colors)),
                                const SizedBox(width: 20),
                                Expanded(child: _buildEventsCard(colors)),
                              ],
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

  Widget _buildStatsGrid(AppColors colors, bool isNarrow) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isNarrow ? 2 : 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 124,
      ),
      itemCount: _overviewStats.length,
      itemBuilder: (context, index) {
        final stat = _overviewStats[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: stat.tint.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                    child: Icon(stat.icon, size: 18, color: stat.tint),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(stat.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: colors.hintColor)),
                  ),
                ],
              ),
              const Spacer(),
              Text(stat.value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colors.textColor)),
              Text(stat.delta, style: TextStyle(fontSize: 11, color: stat.tint, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceCard(AppColors colors) {
    final maxValue = _weeklyAttendance.reduce((a, b) => a > b ? a : b);

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
              Text('Attendance Overview', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.textColor)),
              Text('This Week', style: TextStyle(fontSize: 12, color: colors.hintColor)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < _weeklyAttendance.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 100 * (_weeklyAttendance[i] / maxValue),
                            decoration: BoxDecoration(
                              color: colors.primaryColor.withValues(alpha: 0.85),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_weeklyLabels[i], style: TextStyle(fontSize: 11, color: colors.hintColor)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderCard(AppColors colors) {
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
          Text('Students by Gender', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.textColor)),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 130,
                  height: 130,
                  child: CircularProgressIndicator(
                    value: 0.62,
                    strokeWidth: 14,
                    backgroundColor: const Color(0xFFF48FB1),
                    valueColor: AlwaysStoppedAnimation(colors.primaryColor),
                  ),
                ),
                Text('১,২৪৮', style: TextStyle(fontWeight: FontWeight.bold, color: colors.textColor)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(colors.primaryColor, 'ছেলে ৬২%'),
              const SizedBox(width: 16),
              _legendDot(const Color(0xFFF48FB1), 'মেয়ে ৩৮%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildNoticesCard(AppColors colors) {
    const items = [
      ('জন্মাষ্টমী উদযাপন', '২০ আগস্ট, ২০২৪'),
      ('শিক্ষার্থীদের জন্য প্রবন্ধ প্রতিযোগিতা', '১৮ আগস্ট, ২০২৪'),
      ('অভিভাবক-শিক্ষক সভা', '১৫ আগস্ট, ২০২৪'),
    ];

    return _buildListCard(colors, title: 'Recent Notices', icon: Icons.campaign_outlined, items: items);
  }

  Widget _buildEventsCard(AppColors colors) {
    const items = [
      ('জন্মাষ্টমী', '২৬ আগস্ট, ২০২৪'),
      ('গীতা জয়ন্তী', '১১ ডিসেম্বর, ২০২৪'),
      ('বার্ষিক দিবস', '২৬ জানুয়ারি, ২০২৫'),
    ];

    return _buildListCard(colors, title: 'Upcoming Events', icon: Icons.calendar_month_outlined, items: items);
  }

  Widget _buildListCard(AppColors colors, {required String title, required IconData icon, required List<(String, String)> items}) {
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
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.textColor)),
          const SizedBox(height: 12),
          for (final item in items) ...[
            Row(
              children: [
                Icon(icon, size: 16, color: colors.primaryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item.$1, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: colors.textColor)),
                ),
                const SizedBox(width: 8),
                Text(item.$2, style: TextStyle(fontSize: 11, color: colors.hintColor)),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: Text('View All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primaryColor)),
          ),
        ],
      ),
    );
  }
}
