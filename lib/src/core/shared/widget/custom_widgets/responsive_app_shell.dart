import 'package:flutter/material.dart';

import '../../../navigation/app_sidebar_navigation.dart';
import '../../../shared/widget/app_background.dart';
import '../../../theme/app_colors.dart';
import 'custom_sidebar.dart';
import 'custom_top_bar.dart';

/// An InheritedWidget that provides the persistent shell context to child views.
/// When child views are rendered inside a ShellScope, their nested [ResponsiveAppShell]
/// avoids duplicating the Scaffold, Sidebar, or TopBar and returns [body] directly.
class ShellScope extends InheritedWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const ShellScope({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required super.child,
  });

  static ShellScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShellScope>();
  }

  @override
  bool updateShouldNotify(ShellScope oldWidget) =>
      selectedIndex != oldWidget.selectedIndex;
}

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

  /// Whether the shared background illustration is painted behind [body].
  final bool showBackgroundImage;

  /// The heading of a pushed page (add / edit…), shown in the mobile top bar.
  /// Pages that pass one should drop their in-body heading while [hasTopBar]
  /// is true. Top-level pages leave it null and get the app's name.
  final String? pageTitle;

  /// Whether the top bar may offer a back chip. The shell hosting the
  /// top-level tabs turns it off: those are peers reached from the sidebar,
  /// so "back" there would leave the app's main screen altogether.
  final bool showTopBarBack;

  const ResponsiveAppShell({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.topBarTitle,
    this.onLogout,
    this.onTopBarBack,
    required this.body,
    this.showBackgroundImage = true,
    this.pageTitle,
    this.showTopBarBack = true,
  });

  /// Whether the shell currently shows its top bar (mobile widths only).
  static bool hasTopBar(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  /// The top bar's back chip, or null when there is nothing to go back to.
  ///
  /// Top-level screens are reached from the sidebar by replacement, so there
  /// is no previous screen and the chip would be dead; returning null hides it
  /// and the top bar shows the app's name in its place. Screens pushed on top
  /// (add / edit / details) get a working back chip.
  VoidCallback? _resolveBackAction(BuildContext context) {
    if (!showTopBarBack) return null;
    if (!Navigator.of(context).canPop()) return null;
    return onTopBarBack ?? () => Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final shellScope = ShellScope.of(context);
    if (shellScope != null) {
      return body;
    }

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
          onLogout: onLogout ?? () => AppSidebarNavigation.logout(context),
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
                          builder: (innerContext) {
                            return Column(
                              children: [
                                if (isMobile)
                                  CustomTopBar(
                                    title: topBarTitle,
                                    onBack: backAction,
                                    pageTitle: pageTitle,
                                    onMenuTap: () =>
                                        Scaffold.of(innerContext).openDrawer(),
                                  ),
                                Expanded(
                                  child: AppBackground(
                                    blendWithSidebar: true,
                                    showImage: showBackgroundImage,
                                    child: body,
                                  ),
                                ),
                              ],
                            );
                          },
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
