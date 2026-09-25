import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/widget/custom_widgets/custom_button.dart';
import '../../../../core/shared/widget/custom_widgets/custom_status_badge.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/constants/app_sizes.dart';

class _NoticeItem {
  final String title;
  final String description;
  final String date;
  final String tag;
  final StatusTone tone;

  const _NoticeItem({
    required this.title,
    required this.description,
    required this.date,
    required this.tag,
    required this.tone,
  });
}

// TODO: static design-stage data — this app already has a real GetNotices
// usecase (communication feature); wire this screen up to it in a
// follow-up pass instead of leaving it as design-only.
const _demoNotices = [
  _NoticeItem(
    title: 'জন্মাষ্টমী উদযাপন',
    description: 'আগামী ২০ আগস্ট জন্মাষ্টমী উদযাপন করা হবে বলে আনন্দের সাথে জানানো যাচ্ছে।',
    date: '২০ আগস্ট, ২০২৪',
    tag: 'General',
    tone: StatusTone.neutral,
  ),
  _NoticeItem(
    title: 'শিক্ষার্থীদের জন্য প্রবন্ধ প্রতিযোগিতা',
    description: 'সকল শিক্ষার্থীর জন্য প্রবন্ধ প্রতিযোগিতা অনুষ্ঠিত হবে।',
    date: '১৮ আগস্ট, ২০২৪',
    tag: 'Competition',
    tone: StatusTone.warning,
  ),
  _NoticeItem(
    title: 'অভিভাবক-শিক্ষক সভা',
    description: 'সকল অভিভাবককে উপস্থিত থাকার জন্য অনুরোধ করা হচ্ছে।',
    date: '১৫ আগস্ট, ২০২৪',
    tag: 'Meeting',
    tone: StatusTone.positive,
  ),
  _NoticeItem(
    title: 'ছুটির নোটিশ',
    description: 'স্বাধীনতা দিবস উপলক্ষে পাঠশালা বন্ধ থাকবে।',
    date: '১০ আগস্ট, ২০২৪',
    tag: 'Holiday',
    tone: StatusTone.negative,
  ),
];

class NoticesView extends StatefulWidget {
  const NoticesView({super.key});

  @override
  State<NoticesView> createState() => _NoticesViewState();
}

class _NoticesViewState extends State<NoticesView> {
  int _selectedIndex = 6;

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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(colors, isNarrow),
                      SizedBox(height: AppSizes.sectionGap(context)),
                      for (final notice in _demoNotices) ...[
                        _buildNoticeCard(colors, notice),
                        const SizedBox(height: 16),
                      ],
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
        Text('নোটিশ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colors.primaryColor)),
        const SizedBox(height: 4),
        Text('সকল পাঠশালার জন্য প্রকাশিত নোটিশসমূহ।', style: TextStyle(color: colors.hintColor)),
      ],
    );

    final addButton = SizedBox(
      width: isNarrow ? double.infinity : null,
      child: CustomButton(label: 'Add Notice', icon: Icons.add, onPressed: () {}),
    );

    if (isNarrow) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [titleBlock, const SizedBox(height: 16), addButton]);
    }

    // CustomButton needs a bounded width here — a bare Row child otherwise
    // gets an unbounded main-axis width, crashing Material's tap-target
    // padding. IntrinsicWidth bounds it to its natural content size.
    return Row(children: [Expanded(child: titleBlock), const SizedBox(width: 16), IntrinsicWidth(child: addButton)]);
  }

  Widget _buildNoticeCard(AppColors colors, _NoticeItem notice) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
            child: Icon(Icons.campaign_outlined, color: colors.primaryColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    Text(notice.title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.textColor)),
                    CustomStatusBadge(label: notice.tag, tone: notice.tone),
                  ],
                ),
                const SizedBox(height: 6),
                Text(notice.description, style: TextStyle(fontSize: 13, color: colors.hintColor)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 13, color: colors.hintColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        notice.date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: colors.hintColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
