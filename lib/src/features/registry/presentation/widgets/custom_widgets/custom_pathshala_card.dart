import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class CustomPathshalaCard extends StatelessWidget {
  final String name;
  final String code;
  final String location;
  final int? studentsCount;
  final int? teachersCount;
  final bool isActive;
  final VoidCallback? onView;
  final VoidCallback? onEdit;

  const CustomPathshalaCard({
    super.key,
    required this.name,
    required this.code,
    required this.location,
    this.studentsCount,
    this.teachersCount,
    this.isActive = true,
    this.onView,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.dividerColor),
        boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFFE6F4EA) : colors.tileColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isActive ? const Color(0xFF1E7B34) : colors.hintColor,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                child: Icon(Icons.temple_hindu_outlined, color: colors.primaryColor, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Code: $code',
            style: TextStyle(fontSize: 12, color: colors.hintColor),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: colors.hintColor),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: colors.textColor),
                ),
              ),
            ],
          ),
          if (studentsCount != null || teachersCount != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                if (studentsCount != null)
                  Expanded(
                    child: _StatChip(
                      icon: Icons.people_outline,
                      count: studentsCount!,
                      label: 'Students',
                      colors: colors,
                    ),
                  ),
                if (studentsCount != null && teachersCount != null) const SizedBox(width: 8),
                if (teachersCount != null)
                  Expanded(
                    child: _StatChip(
                      icon: Icons.groups_outlined,
                      count: teachersCount!,
                      label: 'Teachers',
                      colors: colors,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          Divider(color: colors.dividerColor, height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onView,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: colors.tileColor,
                    foregroundColor: colors.textColor,
                    side: BorderSide(color: colors.tileColor),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('View', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onEdit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primaryColor,
                    side: BorderSide(color: colors.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Edit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final AppColors colors;

  const _StatChip({
    required this.icon,
    required this.count,
    required this.label,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: colors.primaryColor),
        const SizedBox(width: 6),
        Flexible(
          child: Text.rich(
            TextSpan(
              text: '$count ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colors.textColor),
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: colors.hintColor),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
