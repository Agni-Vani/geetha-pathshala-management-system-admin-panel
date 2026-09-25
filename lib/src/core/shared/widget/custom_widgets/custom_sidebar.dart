import 'package:flutter/material.dart';

import '../../../constants/assets.dart';
import '../../../theme/app_colors.dart';
import '../../../constants/app_sizes.dart';

class SidebarMenuItem {
  final IconData icon;
  final String label;

  const SidebarMenuItem({required this.icon, required this.label});
}

class CustomSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback? onLogout;
  final bool isCollapsed;

  const CustomSidebar({super.key, required this.selectedIndex, required this.onItemSelected, this.onLogout, this.isCollapsed = false});

  static const List<SidebarMenuItem> _menuItems = [
    SidebarMenuItem(icon: Icons.dashboard_outlined, label: 'ড্যাশবোর্ড'),
    SidebarMenuItem(icon: Icons.school_outlined, label: 'পাঠশালা'),
    SidebarMenuItem(icon: Icons.person_outline, label: 'ব্যক্তি রেজিস্ট্রি'),
    SidebarMenuItem(icon: Icons.people_outline, label: 'শিক্ষার্থী'),
    SidebarMenuItem(icon: Icons.badge_outlined, label: 'শিক্ষক'),
    SidebarMenuItem(icon: Icons.how_to_reg_outlined, label: 'উপস্থিতি'),
    /*     SidebarMenuItem(icon: Icons.note_alt_outlined, label: 'নোটিশ'),
    SidebarMenuItem(icon: Icons.calendar_month_outlined, label: 'অনুষ্ঠান'),
    SidebarMenuItem(icon: Icons.bar_chart_outlined, label: 'রিপোর্ট'), */
    SidebarMenuItem(icon: Icons.settings_outlined, label: 'সেটিংস'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Container(
      width: isCollapsed ? 76 : 260,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.drawerColor,
        border: Border(right: BorderSide(color: colors.dividerColor)),
      ),
      child: Stack(
        children: [
          // Lotus resting at the foot of the sidebar, faded almost to a
          // watermark and dissolved into the panel at its top edge so it never
          // competes with the menu labels.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.white],
                  stops: [0, 0.6],
                ).createShader(bounds),
                blendMode: BlendMode.dstIn,
                child: Opacity(
                  opacity: 0.16,
                  child: Image.asset(
                    Assets.lotusImage,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(isCollapsed ? 10 : 18, 18, isCollapsed ? 10 : 18, 14),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                      child: Icon(Icons.temple_hindu_outlined, color: colors.primaryColor, size: 28),
                    ),
                    if (!isCollapsed) ...[
                      const SizedBox(height: 8),
                      Text(
                        'গীতা পাঠশালা',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.primaryColor),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 8 : 12),
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    return _SidebarMenuTile(
                      icon: item.icon,
                      label: item.label,
                      isSelected: selectedIndex == index,
                      isCollapsed: isCollapsed,
                      onTap: () => onItemSelected(index),
                      colors: colors,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(isCollapsed ? 8 : 12, 8, isCollapsed ? 8 : 12, 24),
                child: Tooltip(
                  message: isCollapsed ? 'Logout' : '',
                  child: InkWell(
                    onTap: onLogout,
                    borderRadius: AppSizes.rectangleButtonRadius,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: isCollapsed ? 0 : 16),
                      decoration: BoxDecoration(
                        color: colors.primaryColor.withValues(alpha: 0.12),
                        borderRadius: AppSizes.rectangleButtonRadius,
                        border: Border.all(color: colors.primaryColor.withValues(alpha: 0.16)),
                      ),
                      child: Row(
                        mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                        children: [
                          Icon(Icons.logout_rounded, color: colors.primaryColor),
                          if (!isCollapsed) ...[
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                'Logout',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: colors.primaryColor, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isCollapsed;
  final VoidCallback onTap;
  final AppColors colors;

  const _SidebarMenuTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isCollapsed,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final tile = Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSizes.rectangleButtonRadius,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: isCollapsed ? 0 : 14),
          decoration: BoxDecoration(
            color: isSelected ? colors.primaryColor.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: AppSizes.rectangleButtonRadius,
            border: isSelected ? Border.all(color: colors.primaryColor.withValues(alpha: 0.16)) : null,
          ),
          child: Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              if (!isCollapsed && isSelected)
                Container(
                  width: 4,
                  height: 24,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(color: colors.primaryColor, borderRadius: BorderRadius.circular(99)),
                ),
              Icon(icon, color: isSelected ? colors.primaryColor : colors.maroonColor),
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? colors.primaryColor : colors.maroonColor,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (!isCollapsed) return tile;
    return Tooltip(message: label, child: tile);
  }
}
