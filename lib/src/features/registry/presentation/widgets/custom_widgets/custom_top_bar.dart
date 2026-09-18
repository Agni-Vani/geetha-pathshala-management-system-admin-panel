import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';

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
                final isVeryCompact = constraints.maxWidth < 640;

                return Row(
                  children: [
                    if (onMenuTap != null) ...[
                      InkWell(
                        onTap: onMenuTap,
                        borderRadius: AppSizes.rectangleButtonRadius,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors.tileColor,
                            borderRadius: AppSizes.rectangleButtonRadius,
                          ),
                          child: Icon(Icons.menu, color: colors.textColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    if (onBack == null)
                      // Without a back chip this corner would sit empty, so
                      // the app's name takes the slot instead.
                      Flexible(
                        child: Text(
                          'গীতা পাঠশালা',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    if (onBack != null)
                      InkWell(
                        onTap: onBack,
                        borderRadius: AppSizes.rectangleButtonRadius,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: colors.tileColor,
                            borderRadius: AppSizes.rectangleButtonRadius,
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
                            borderRadius: AppSizes.rectangleButtonRadius,
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
