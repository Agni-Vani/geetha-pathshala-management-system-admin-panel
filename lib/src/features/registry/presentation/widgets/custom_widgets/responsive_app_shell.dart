import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import 'custom_sidebar.dart';
import 'custom_top_bar.dart';

/// Shared page skeleton (sidebar + top bar + body) that adapts across
/// mobile (< [mobileBreakpoint]), tablet (< [tabletBreakpoint]) and desktop
/// widths:
/// - Desktop: full sidebar with labels, always visible.
/// - Tablet: icon-only collapsed sidebar rail, always visible.
/// - Mobile: sidebar hidden behind a Drawer, opened via a hamburger button
///   in the top bar.
class ResponsiveAppShell extends StatelessWidget {
  static const double mobileBreakpoint = 640;
  static const double tabletBreakpoint = 1024;

  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback? onLogout;
  final String topBarTitle;
  final VoidCallback? onTopBarBack;
  final Widget body;

  const ResponsiveAppShell({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.topBarTitle,
    this.onLogout,
    this.onTopBarBack,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < mobileBreakpoint;
        final isTablet = !isMobile && constraints.maxWidth < tabletBreakpoint;

        void handleItemSelected(int index) {
          if (isMobile) Navigator.of(context).maybePop();
          onItemSelected(index);
        }

        final sidebar = CustomSidebar(
          selectedIndex: selectedIndex,
          onItemSelected: handleItemSelected,
          onLogout: onLogout,
          isCollapsed: isTablet,
        );

        return Scaffold(
          backgroundColor: colors.tileColor,
          drawer: isMobile ? Drawer(width: 260, child: SafeArea(child: sidebar)) : null,
          body: Row(
            children: [
              if (!isMobile) sidebar,
              Expanded(
                child: Builder(
                  builder: (innerContext) => Column(
                    children: [
                      CustomTopBar(
                        title: topBarTitle,
                        onBack: onTopBarBack,
                        onMenuTap: isMobile ? () => Scaffold.of(innerContext).openDrawer() : null,
                      ),
                      Expanded(child: body),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
