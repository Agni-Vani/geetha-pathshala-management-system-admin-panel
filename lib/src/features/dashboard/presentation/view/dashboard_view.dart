import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/service_locator.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../controller/dashboard_controller.dart';

class DashboardView extends StatefulWidget {
  final DashboardController? controller;

  const DashboardView({super.key, this.controller});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;
  late final DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? sl<DashboardController>();
    _controller.load();
  }

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  IconData _resolveIcon(String key) {
    switch (key) {
      case 'account_balance':
        return Icons.account_balance_outlined;
      case 'people':
        return Icons.people_alt_outlined;
      case 'badge':
        return Icons.badge_outlined;
      case 'how_to_reg':
        return Icons.how_to_reg_outlined;
      default:
        return Icons.analytics_outlined;
    }
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
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final overview = _controller.overview;
          final isLoading = _controller.processStatusNotifier.status is ProcessLoading;

          if (isLoading && overview == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (overview == null) {
            return Center(
              child: Text(
                'তথ্য লোড করা যায়নি',
                style: TextStyle(color: colors.hintColor),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSizes.pagePadding(context),
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
                          SizedBox(height: AppSizes.sectionGap(context)),
                          _buildStatsGrid(colors, isNarrow, overview.stats),
                          SizedBox(height: AppSizes.sectionGap(context)),
                          isStacked
                              ? Column(
                                  children: [
                                    _buildAttendanceCard(colors, overview.weeklyAttendance),
                                    const SizedBox(height: 20),
                                    _buildGenderCard(colors, overview.genderDistribution),
                                  ],
                                )
                              : IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(flex: 2, child: _buildAttendanceCard(colors, overview.weeklyAttendance)),
                                      const SizedBox(width: 20),
                                      Expanded(child: _buildGenderCard(colors, overview.genderDistribution)),
                                    ],
                                  ),
                                ),
                          const SizedBox(height: 20),
                          isStacked
                              ? Column(
                                  children: [
                                    _buildNoticesCard(colors, overview.recentNotices),
                                    const SizedBox(height: 20),
                                    _buildEventsCard(colors, overview.upcomingEvents),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _buildNoticesCard(colors, overview.recentNotices)),
                                    const SizedBox(width: 20),
                                    Expanded(child: _buildEventsCard(colors, overview.upcomingEvents)),
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
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(AppColors colors, bool isNarrow, List<DashboardStat> stats) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isNarrow ? 2 : 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 124,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        final tintColor = Color(stat.tintHex);
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
                    decoration: BoxDecoration(color: tintColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                    child: Icon(_resolveIcon(stat.iconKey), size: 18, color: tintColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(stat.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: colors.hintColor)),
                  ),
                ],
              ),
              const Spacer(),
              Text(stat.value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colors.textColor)),
              Text(stat.delta, style: TextStyle(fontSize: 11, color: tintColor, fontWeight: FontWeight.w600)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceCard(AppColors colors, List<WeeklyAttendancePoint> weeklyAttendance) {
    if (weeklyAttendance.isEmpty) return const SizedBox.shrink();

    final maxValue = weeklyAttendance.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final effectiveMax = maxValue == 0 ? 1 : maxValue;

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
            children: [
              Expanded(
                child: Text(
                  'Attendance Overview',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.textColor),
                ),
              ),
              const SizedBox(width: 8),
              Text('This Week', style: TextStyle(fontSize: 12, color: colors.hintColor)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final point in weeklyAttendance)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 100 * (point.value / effectiveMax),
                            decoration: BoxDecoration(
                              color: colors.primaryColor.withValues(alpha: 0.85),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(point.label, style: TextStyle(fontSize: 11, color: colors.hintColor)),
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

  Widget _buildGenderCard(AppColors colors, GenderDistribution gender) {
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
                    value: gender.malePercentage,
                    strokeWidth: 14,
                    backgroundColor: const Color(0xFFF48FB1),
                    valueColor: AlwaysStoppedAnimation(colors.primaryColor),
                  ),
                ),
                Text(gender.totalStudents, style: TextStyle(fontWeight: FontWeight.bold, color: colors.textColor)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 6,
            children: [
              _legendDot(colors.primaryColor, 'ছেলে ${(gender.malePercentage * 100).round()}%'),
              _legendDot(const Color(0xFFF48FB1), 'মেয়ে ${(gender.femalePercentage * 100).round()}%'),
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

  Widget _buildNoticesCard(AppColors colors, List<DashboardRecentItem> notices) {
    return _buildListCard(
      colors,
      title: 'Recent Notices',
      icon: Icons.campaign_outlined,
      items: notices,
    );
  }

  Widget _buildEventsCard(AppColors colors, List<DashboardRecentItem> events) {
    return _buildListCard(
      colors,
      title: 'Upcoming Events',
      icon: Icons.calendar_month_outlined,
      items: events,
    );
  }

  Widget _buildListCard(
    AppColors colors, {
    required String title,
    required IconData icon,
    required List<DashboardRecentItem> items,
  }) {
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
                  child: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: colors.textColor)),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    item.date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: colors.hintColor),
                  ),
                ),
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
