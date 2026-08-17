import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onMenuTap;

  const CustomTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.onNotificationTap,
    this.onProfileTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Container(
      color: colors.drawerColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                if (onMenuTap != null) ...[
                  InkWell(
                    onTap: onMenuTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(Icons.menu, color: colors.textColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                InkWell(
                  onTap: onBack,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Icon(Icons.keyboard_double_arrow_left,
                          color: colors.primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        title,
                        style: TextStyle(
                          color: colors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onNotificationTap,
                  borderRadius: BorderRadius.circular(20),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: colors.softGrey,
                    child: Icon(
                      Icons.notifications_none,
                      color: colors.textColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: onProfileTap,
                  borderRadius: BorderRadius.circular(20),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: colors.textColor,
                    child: Icon(
                      Icons.person_outline,
                      color: colors.invertTextColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.dividerColor),
        ],
      ),
    );
  }
}
