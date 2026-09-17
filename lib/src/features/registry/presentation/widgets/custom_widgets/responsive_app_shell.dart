import 'package:flutter/material.dart';

import '../../../../../core/shared/widget/app_background.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../view/registry_sidebar_navigation.dart';
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

  /// What the "« Overview" chip should do from here.
  ///
  /// It used to always call `maybePop`, which does nothing on a top-level
  /// screen — the chip looked tappable but was dead. Now it pops when there is
  /// something to pop, otherwise it goes to the Overview it names. On Overview
  /// itself, with nothing to pop, there is nowhere to go and it is hidden.
  VoidCallback? _resolveBackAction(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      return onTopBarBack ?? () => Navigator.of(context).maybePop();
    }
    const overviewIndex = 0;
    if (selectedIndex == overviewIndex) return null;
    return () =>
        RegistrySidebarNavigation.pushReplacement(context, overviewIndex);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final backAction = _resolveBackAction(context);

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

        // The illustrated background belongs to the content area only — the
        // sidebar and top bar sit on the flat surface colour so their
        // translucent panels stay readable.
        return Scaffold(
          backgroundColor: colors.appBackgroundColor,
          drawer: isMobile
              ? Drawer(
                  width: 260,
                  backgroundColor: colors.appBackgroundColor,
                  surfaceTintColor: Colors.transparent,
                  shadowColor: colors.shadowColor,
                  child: SafeArea(child: sidebar),
                )
              : null,
          drawerScrimColor: colors.textColor.withValues(alpha: 0.12),
          body: Column(
            children: [
              // Paint the status bar / notch strip in the top bar's colour so
              // the bar reads as starting below it, then inset the rest for
              // the remaining cutouts and the home indicator.
              Container(
                height: MediaQuery.paddingOf(context).top,
                color: colors.drawerColor,
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      if (!isMobile) sidebar,
                      Expanded(
                        child: Builder(
                          builder: (innerContext) => Column(
                            children: [
                              CustomTopBar(
                                title: topBarTitle,
                                onBack: backAction,
                                onMenuTap: isMobile
                                    ? () =>
                                          Scaffold.of(innerContext).openDrawer()
                                    : null,
                              ),
                              Expanded(child: AppBackground(child: body)),
                            ],
                          ),
                        ),
                      ),
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
