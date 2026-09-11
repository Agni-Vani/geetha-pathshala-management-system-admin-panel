import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class SidebarMenuItem {
  final IconData icon;
  final String label;

  const SidebarMenuItem({required this.icon, required this.label});
}

class CustomSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback? onLogout;

  const CustomSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.onLogout,
  });

  static const List<SidebarMenuItem> _menuItems = [
    SidebarMenuItem(icon: Icons.dashboard_outlined, label: 'ড্যাশবোর্ড'),
    SidebarMenuItem(icon: Icons.school_outlined, label: 'পাঠশালা'),
    SidebarMenuItem(icon: Icons.person_outline, label: 'ব্যক্তি রেজিস্ট্রি'),
    SidebarMenuItem(icon: Icons.people_outline, label: 'শিক্ষার্থী'),
    SidebarMenuItem(icon: Icons.badge_outlined, label: 'শিক্ষক'),
    SidebarMenuItem(icon: Icons.how_to_reg_outlined, label: 'উপস্থিতি'),
    SidebarMenuItem(icon: Icons.note_alt_outlined, label: 'নোটিশ'),
    SidebarMenuItem(icon: Icons.calendar_month_outlined, label: 'অনুষ্ঠান'),
    SidebarMenuItem(icon: Icons.bar_chart_outlined, label: 'রিপোর্ট'),
    SidebarMenuItem(icon: Icons.settings_outlined, label: 'সেটিংস'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: colors.drawerColor,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                  child: Icon(
                    Icons.temple_hindu_outlined,
                    color: colors.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'গীতা পাঠশালা',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return _SidebarMenuTile(
                  icon: item.icon,
                  label: item.label,
                  isSelected: selectedIndex == index,
                  onTap: () => onItemSelected(index),
                  colors: colors,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
            child: InkWell(
              onTap: onLogout,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: colors.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: colors.errorColor),
                    const SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: colors.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
  final VoidCallback onTap;
  final AppColors colors;

  const _SidebarMenuTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? colors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? colors.invertTextColor : colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? colors.invertTextColor : colors.textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
