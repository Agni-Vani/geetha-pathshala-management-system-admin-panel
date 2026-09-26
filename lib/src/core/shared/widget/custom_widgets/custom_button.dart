import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../constants/app_sizes.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;

  const CustomButton({super.key, required this.label, required this.onPressed, this.icon}) : isOutlined = false;

  const CustomButton.outlined({super.key, required this.label, required this.onPressed, this.icon}) : isOutlined = true;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isOutlined ? colors.textColor : colors.buttonContentColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );

    if (isOutlined) {
      return IntrinsicWidth(
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.textColor,
            side: BorderSide(color: colors.enabledBorderColor),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: const RoundedRectangleBorder(borderRadius: AppSizes.rectangleButtonRadius),
          ),
          child: child,
        ),
      );
    }

    return IntrinsicWidth(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryColor,
          foregroundColor: colors.buttonContentColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: AppSizes.rectangleButtonRadius),
        ),
        child: child,
      ),
    );
  }
}
