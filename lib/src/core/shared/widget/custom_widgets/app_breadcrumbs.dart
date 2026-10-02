import 'package:flutter/material.dart';

import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/theme/app_colors.dart';

/// Single item in the breadcrumb path.
class BreadcrumbItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const BreadcrumbItem({
    required this.label,
    this.icon,
    this.onTap,
  });

  /// Factory helper for root home / dashboard crumb.
  static BreadcrumbItem home(BuildContext context) {
    return BreadcrumbItem(
      label: 'হোম',
      icon: Icons.home_outlined,
      onTap: () => AppSidebarNavigation.navigateToIndex(context, 0),
    );
  }
}

/// A responsive, accessible, interactive breadcrumb navigation bar.
///
/// Lays out breadcrumb segments horizontally and wraps cleanly on narrow screens
/// without ever overflowing. Clickable segments provide subtle hover states,
/// while the current active segment is highlighted.
class AppBreadcrumbs extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final EdgeInsetsGeometry padding;

  const AppBreadcrumbs({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.only(bottom: 12),
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final colors = AppColors.context(context);

    return Padding(
      padding: padding,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        runSpacing: 4,
        children: List.generate(items.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Icon(
              Icons.chevron_right_rounded,
              size: 15,
              color: colors.hintColor.withValues(alpha: 0.5),
            );
          }

          final itemIndex = index ~/ 2;
          final item = items[itemIndex];
          final isLast = itemIndex == items.length - 1;

          return _BreadcrumbSegment(
            item: item,
            isCurrent: isLast,
            colors: colors,
          );
        }),
      ),
    );
  }
}

class _BreadcrumbSegment extends StatefulWidget {
  final BreadcrumbItem item;
  final bool isCurrent;
  final AppColors colors;

  const _BreadcrumbSegment({
    required this.item,
    required this.isCurrent,
    required this.colors,
  });

  @override
  State<_BreadcrumbSegment> createState() => _BreadcrumbSegmentState();
}

class _BreadcrumbSegmentState extends State<_BreadcrumbSegment> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isClickable = widget.item.onTap != null && !widget.isCurrent;

    final Color textColor;
    if (widget.isCurrent) {
      textColor = widget.colors.primaryColor;
    } else if (_isHovered && isClickable) {
      textColor = widget.colors.primaryColor;
    } else {
      textColor = widget.colors.hintColor;
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.item.icon != null) ...[
          Icon(
            widget.item.icon,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
        ],
        Text(
          widget.item.label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: widget.isCurrent ? FontWeight.w600 : FontWeight.w500,
            color: textColor,
            decoration: (_isHovered && isClickable)
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
        ),
      ],
    );

    if (widget.isCurrent) {
      content = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: widget.colors.primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: content,
      );
    }

    if (!isClickable) {
      return content;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.item.onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: content,
        ),
      ),
    );
  }
}
