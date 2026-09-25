import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class CustomSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const CustomSectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    return Row(
      children: [
        Icon(icon, color: colors.primaryColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}
