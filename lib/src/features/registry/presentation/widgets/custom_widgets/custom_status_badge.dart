import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

enum StatusTone { positive, negative, neutral, warning }

/// Small rounded pill used across list/table screens (Active, Present,
/// Absent, Upcoming, etc.) — mirrors the Active/Inactive badge already used
/// on the Pathshala card and details screens.
class CustomStatusBadge extends StatelessWidget {
  final String label;
  final StatusTone tone;

  const CustomStatusBadge({super.key, required this.label, this.tone = StatusTone.neutral});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    final (Color bg, Color fg) = switch (tone) {
      StatusTone.positive => (const Color(0xFFE6F4EA), const Color(0xFF1E7B34)),
      StatusTone.negative => (colors.errorColor.withValues(alpha: 0.1), colors.errorColor),
      StatusTone.warning => (const Color(0xFFFFF3E0), const Color(0xFFAD6800)),
      StatusTone.neutral => (colors.tileColor, colors.hintColor),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
