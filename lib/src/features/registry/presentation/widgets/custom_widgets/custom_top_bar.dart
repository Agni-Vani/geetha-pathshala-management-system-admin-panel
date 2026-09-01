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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 900;
                final isVeryCompact = constraints.maxWidth < 640;

                return Row(
                  children: [
                    if (onMenuTap != null) ...[
                      InkWell(
                        onTap: onMenuTap,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors.tileColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.menu, color: colors.textColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    InkWell(
                      onTap: onBack,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colors.tileColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.keyboard_double_arrow_left,
                              color: colors.primaryColor,
                            ),
                            if (!isVeryCompact) ...[
                              const SizedBox(width: 6),
                              Text(
                                title,
                                style: TextStyle(
                                  color: colors.primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (!isVeryCompact) ...[
                      const SizedBox(width: 18),
                      Expanded(
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: colors.tileColor,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                size: 18,
                                color: colors.hintColor,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Search people, pathshala, reports...',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colors.hintColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.tileColor,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: colors.textColor,
                              child: Icon(
                                Icons.person_outline,
                                color: colors.invertTextColor,
                                size: 18,
                              ),
                            ),
                            if (!isCompact) ...[
                              const SizedBox(width: 8),
                              Text(
                                'Admin',
                                style: TextStyle(
                                  color: colors.textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Divider(height: 1, color: colors.dividerColor),
        ],
      ),
    );
  }
}
