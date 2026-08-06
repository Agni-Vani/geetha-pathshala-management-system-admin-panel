import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

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
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ],
    );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textColor,
          side: BorderSide(color: colors.enabledBorderColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primaryColor,
        foregroundColor: colors.buttonContentColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: child,
    );
  }
}
