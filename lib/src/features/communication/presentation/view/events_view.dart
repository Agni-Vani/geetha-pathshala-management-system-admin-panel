import 'package:flutter/material.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/widget/custom_widgets/custom_button.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/constants/app_sizes.dart';

class _EventItem {
  final String title;
  final String description;
  final String date;
  final String time;
  final String scope;
  final IconData icon;

  const _EventItem({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.scope,
    required this.icon,
  });
}

// TODO: static design-stage data — no events entity/usecase exists yet
// in the domain layer; wire this up once one is added.
const _demoEvents = [
  _EventItem(
    title: 'জন্মাষ্টমী',
    description: 'শ্রীকৃষ্ণের জন্মোৎসব উদযাপন।',
    date: '২৬ আগস্ট, ২০২৪',
    time: 'সকাল ১০:০০',
    scope: 'All Pathshalas',
    icon: Icons.auto_awesome_outlined,
  ),
  _EventItem(
    title: 'গীতা জয়ন্তী',
    description: 'ভগবদ্গীতা অবতরণের স্মরণে অনুষ্ঠান।',
    date: '১১ ডিসেম্বর, ২০২৪',
    time: 'সকাল ১০:০০',
    scope: 'All Pathshalas',
    icon: Icons.menu_book_outlined,
  ),
  _EventItem(
    title: 'বার্ষিক দিবস',
    description: 'সাংস্কৃতিক অনুষ্ঠানসহ বার্ষিক উৎসব।',
    date: '২৬ জানুয়ারি, ২০২৫',
    time: 'সকাল ১০:০০',
    scope: 'Main Pathshala',
    icon: Icons.celebration_outlined,
  ),
  _EventItem(
    title: 'সরস্বতী পূজা',
    description: 'দেবী সরস্বতীর পূজা অর্চনা।',
    date: '২ ফেব্রুয়ারি, ২০২৫',
    time: 'সকাল ১০:০০',
    scope: 'All Pathshalas',
    icon: Icons.local_florist_outlined,
  ),
];

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  int _selectedIndex = 7;

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
              padding: AppSizes.pagePadding(context),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 640;
                  final crossAxisCount = constraints.maxWidth < 640
                      ? 1
                      : constraints.maxWidth < 1000
                      ? 2
                      : 3;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(colors, isNarrow),
                      SizedBox(height: AppSizes.sectionGap(context)),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 250,
                        ),
                        itemCount: _demoEvents.length,
                        itemBuilder: (context, index) =>
                            _buildEventCard(colors, _demoEvents[index]),
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
        Text(
          'অনুষ্ঠান',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colors.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'আসন্ন উৎসব ও অনুষ্ঠানসমূহ।',
          style: TextStyle(color: colors.hintColor),
        ),
      ],
    );

    final addButton = SizedBox(
      width: isNarrow ? double.infinity : null,
      child: CustomButton(
        label: 'Add Event',
        icon: Icons.add,
        onPressed: () {},
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleBlock, const SizedBox(height: 16), addButton],
      );
    }

    // CustomButton needs a bounded width here — a bare Row child otherwise
    // gets an unbounded main-axis width, crashing Material's tap-target
    // padding. IntrinsicWidth bounds it to its natural content size.
    return Row(
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        IntrinsicWidth(child: addButton),
      ],
    );
  }

  Widget _metaChip(AppColors colors, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: colors.hintColor),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: colors.hintColor),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(AppColors colors, _EventItem event) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        // Peacock-feather watermark anchored to the card's right edge; kept
        // faint so the event text stays the focus.
        image: DecorationImage(
          image: const AssetImage(Assets.peacockFeatherImage),
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
          opacity: isDark ? 0.08 : 0.14,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadowColor,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                child: Icon(event.icon, color: colors.primaryColor, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                event.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                event.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: colors.hintColor),
              ),
              const Spacer(),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _metaChip(colors, Icons.calendar_today_outlined, event.date),
                  _metaChip(colors, Icons.schedule_outlined, event.time),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                event.scope,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
