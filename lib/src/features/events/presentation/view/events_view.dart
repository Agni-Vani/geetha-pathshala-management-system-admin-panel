import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/widget/custom_widgets/custom_button.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/service_locator.dart';
import '../../domain/events_domain.dart';
import '../controller/events_controller.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  late final EventsController _controller;
  int _selectedIndex = 7;

  @override
  void initState() {
    super.initState();
    _controller = sl<EventsController>();
    _controller.load();
  }

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  IconData _resolveIcon(String? iconName) {
    switch (iconName) {
      case 'auto_awesome_outlined':
        return Icons.auto_awesome_outlined;
      case 'menu_book_outlined':
        return Icons.menu_book_outlined;
      case 'celebration_outlined':
        return Icons.celebration_outlined;
      case 'local_florist_outlined':
        return Icons.local_florist_outlined;
      default:
        return Icons.event_outlined;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
      'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
    ];
    final bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String bn(int num) => num.toString().split('').map((c) => bnDigits[int.parse(c)]).join();
    return '${bn(date.day)} ${months[date.month - 1]}, ${bn(date.year)}';
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
          final events = _controller.events;

          return Column(
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
                            itemCount: events.length,
                            itemBuilder: (context, index) =>
                                _buildEventCard(colors, events[index]),
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

  Widget _buildEventCard(AppColors colors, Event event) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconData = _resolveIcon(event.iconName);

    return Container(
      padding: const EdgeInsets.all(18),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
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
                child: Icon(iconData, color: colors.primaryColor, size: 20),
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
                  _metaChip(colors, Icons.calendar_today_outlined, _formatDate(event.eventDate)),
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
