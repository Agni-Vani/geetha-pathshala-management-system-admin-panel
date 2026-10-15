import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
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
      topBarTitle: 'Overview',
      onTopBarBack: () => Navigator.of(context).maybePop(),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final overview = _controller.overview;
          final isLoading =
              _controller.processStatusNotifier.status is ProcessLoading;

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
                      final isStacked = constraints.maxWidth < 900;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppBreadcrumbs(
                            items: [
                              BreadcrumbItem(
                                label: 'হোম',
                                icon: Icons.home_outlined,
                              ),
                              BreadcrumbItem(
                                label: 'ড্যাশবোর্ড',
                                icon: Icons.dashboard_outlined,
                              ),
                            ],
                          ),
                          Text(
                            'ড্যাশবোর্ড',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: colors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'স্বাগতম, Admin! আপনার পাঠশালা সিস্টেমে এখন যা ঘটছে তার সারসংক্ষেপ।',
                            style: TextStyle(color: colors.hintColor),
                          ),
                          SizedBox(height: AppSizes.sectionGap(context)),
                          _buildStatsGrid(colors, overview.stats),
                          SizedBox(height: AppSizes.sectionGap(context)),
                          isStacked
                              ? Column(
                                  children: [
                                    _buildAttendanceCard(
                                      colors,
                                      overview.weeklyAttendance,
                                    ),
                                    const SizedBox(height: 20),
                                    _buildGenderCard(
                                      colors,
                                      overview.genderDistribution,
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _buildAttendanceCard(
                                        colors,
                                        overview.weeklyAttendance,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildGenderCard(
                                        colors,
                                        overview.genderDistribution,
                                      ),
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 20),
                          isStacked
                              ? Column(
                                  children: [
                                    _buildNoticesCard(
                                      colors,
                                      overview.recentNotices,
                                    ),
                                    const SizedBox(height: 20),
                                    _buildEventsCard(
                                      colors,
                                      overview.upcomingEvents,
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildNoticesCard(
                                        colors,
                                        overview.recentNotices,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildEventsCard(
                                        colors,
                                        overview.upcomingEvents,
                                      ),
                                    ),
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
                constraints: const BoxConstraints(minHeight: 40),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Center(
                  child: Text(
                    '© 2024 Geetha Pathshala Management. All rights reserved.',
                    textAlign: TextAlign.center,
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

  BoxDecoration _cardDecoration(AppColors colors) => BoxDecoration(
    color: colors.backgroundColor,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: colors.dividerColor),
    boxShadow: [
      BoxShadow(
        color: colors.shadowColor.withValues(alpha: .06),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );

  Widget _buildStatsGrid(AppColors colors, List<DashboardStat> stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(12) / 12;
        final columns = constraints.maxWidth < 340
            ? 1
            : constraints.maxWidth < 800 * textScale
            ? 2
            : 4;
        final gap = constraints.maxWidth < 640 ? 12.0 : 20.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final stat in stats)
              Container(
                width: width,
                constraints: const BoxConstraints(minHeight: 148),
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(colors),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(stat.tintHex).withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _resolveIcon(stat.iconKey),
                            size: 18,
                            color: Color(stat.tintHex),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            stat.label,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: colors.hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      stat.value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colors.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stat.delta,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: Color(stat.tintHex),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAttendanceCard(
    AppColors colors,
    List<WeeklyAttendancePoint> weeklyAttendance,
  ) {
    if (weeklyAttendance.isEmpty) return const SizedBox.shrink();
    final maxValue = weeklyAttendance
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final effectiveMax = maxValue == 0 ? 1 : maxValue;
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 280),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(colors),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final title = Text(
                'Attendance Overview',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
              );
              final period = Text(
                'This Week',
                style: TextStyle(fontSize: 12, color: colors.hintColor),
              );
              if (constraints.maxWidth < 360) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [title, const SizedBox(height: 6), period],
                );
              }
              return Row(
                children: [
                  Expanded(child: title),
                  const SizedBox(width: 12),
                  period,
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) => Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final point in weeklyAttendance)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: constraints.maxWidth < 400 ? 3 : 6,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 120,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 100 * (point.value / effectiveMax),
                                decoration: BoxDecoration(
                                  color: colors.primaryColor.withValues(
                                    alpha: .85,
                                  ),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            point.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.hintColor,
                            ),
                          ),
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
      key: const ValueKey('dashboard-gender-card'),
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 280),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(colors),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Students by Gender',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Padding(
              // Reserve space for the progress ring's stroke outside its bounds.
              padding: const EdgeInsets.all(7),
              child: SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: gender.malePercentage,
                        strokeWidth: 14,
                        backgroundColor: const Color(0xFFF48FB1),
                        valueColor: AlwaysStoppedAnimation(colors.primaryColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        gender.totalStudents,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 10,
              children: [
                _legendDot(
                  colors.primaryColor,
                  'ছেলে ${(gender.malePercentage * 100).round()}%',
                ),
                _legendDot(
                  const Color(0xFFF48FB1),
                  'মেয়ে ${(gender.femalePercentage * 100).round()}%',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.context(context).textColor,
          ),
        ),
      ),
    ],
  );

  Widget _buildNoticesCard(
    AppColors colors,
    List<DashboardRecentItem> notices,
  ) => _buildListCard(
    colors,
    title: 'Recent Notices',
    icon: Icons.campaign_outlined,
    items: notices,
  );

  Widget _buildEventsCard(AppColors colors, List<DashboardRecentItem> events) =>
      _buildListCard(
        colors,
        title: 'Upcoming Events',
        icon: Icons.calendar_month_outlined,
        items: events,
      );

  Widget _buildListCard(
    AppColors colors, {
    required String title,
    required IconData icon,
    required List<DashboardRecentItem> items,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: _cardDecoration(colors),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: colors.textColor,
          ),
        ),
        const SizedBox(height: 16),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, size: 16, color: colors.primaryColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final title = Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: colors.textColor,
                      ),
                    );
                    final date = Text(
                      item.date,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: colors.hintColor,
                      ),
                    );
                    if (constraints.maxWidth < 400) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [title, const SizedBox(height: 4), date],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: title),
                        const SizedBox(width: 16),
                        Expanded(child: date),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'View All',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}
