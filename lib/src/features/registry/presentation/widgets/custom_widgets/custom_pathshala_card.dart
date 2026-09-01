import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/assets.dart';
import '../../../../../core/theme/app_colors.dart';

/// Below this width the two action buttons no longer fit side by side, so they
/// stack instead of clipping their labels.
const _stackedActionsBreakpoint = 240.0;

const _omBadgeColor = Color(0xFF6E2C1E);
const _omGlyphColor = Color(0xFFE3C08A);

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
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Stack(
        children: [
          // Illustration sits behind everything as a soft, washed-out texture.
          // It covers the whole card at any size — so it scales with the card
          // and leaves no visible edge — and the scrim on top of it keeps the
          // text fully legible.
          Positioned.fill(
            child: Image.asset(
              Assets.gurukulImage,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.backgroundColor.withValues(alpha: 0.93),
                    colors.backgroundColor.withValues(alpha: 0.9),
                    colors.tileColor.withValues(alpha: 0.9),
                  ],
                  stops: const [0, 0.55, 1],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            left: 10,
            child: Text('❖', style: TextStyle(fontSize: 11, color: colors.primaryColor.withValues(alpha: 0.35))),
          ),
          Positioned(
            bottom: 6,
            right: 10,
            child: Text('❖', style: TextStyle(fontSize: 11, color: colors.primaryColor.withValues(alpha: 0.35))),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFE6F4EA) : colors.tileColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isActive ? 'Active' : 'Inactive',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isActive ? const Color(0xFF1E7B34) : colors.hintColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                      child: Icon(Icons.temple_hindu_outlined, color: colors.primaryColor, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _omBadgeColor,
                      child: Text(
                        'ॐ',
                        style: GoogleFonts.notoSansDevanagari(
                          color: _omGlyphColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.yatraOne(fontSize: 17, color: colors.textColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Code: $code',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.primaryColor),
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
                const Spacer(),
                const SizedBox(height: 16),
                _CardActions(colors: colors, onView: onView, onEdit: onEdit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardActions extends StatelessWidget {
  final AppColors colors;
  final VoidCallback? onView;
  final VoidCallback? onEdit;

  const _CardActions({required this.colors, this.onView, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final view = _ActionButton(
      icon: Icons.visibility_outlined,
      label: 'View Details',
      onPressed: onView,
      foregroundColor: colors.textColor,
      backgroundColor: colors.tileColor,
      borderColor: colors.tileColor,
    );
    final edit = _ActionButton(
      icon: Icons.edit_outlined,
      label: 'Edit',
      onPressed: onEdit,
      foregroundColor: colors.primaryColor,
      borderColor: colors.primaryColor,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _stackedActionsBreakpoint) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: double.infinity, child: view),
              const SizedBox(height: 8),
              SizedBox(width: double.infinity, child: edit),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: view),
            const SizedBox(width: 12),
            Expanded(child: edit),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color foregroundColor;
  final Color borderColor;
  final Color? backgroundColor;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.foregroundColor,
    required this.borderColor,
    this.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        side: BorderSide(color: borderColor),
        // The default 64px minimum width would push the label past the button
        // in a narrow card; the content is what should shrink here.
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
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
