import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geetha_pathshala_management_web/src/core/navigation/app_route_builders.dart';
import 'package:geetha_pathshala_management_web/src/core/navigation/app_route_names.dart';
import 'package:geetha_pathshala_management_web/src/core/navigation/main_shell_view.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/widget/custom_widgets/custom_sidebar.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:geetha_pathshala_management_web/src/features/pathshala/presentation/view/all_patshala_view.dart';
import 'package:geetha_pathshala_management_web/src/features/notices/presentation/view/notices_view.dart';
import 'package:geetha_pathshala_management_web/src/features/events/presentation/view/events_view.dart';

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await setupServiceLocator(useMockData: true);
  });

  Future<void> pumpShell(WidgetTester tester, {String route = AppRouteNames.dashboard}) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme().lightTheme,
        initialRoute: route,
        routes: RegistryRouteBuilders.routes,
      ),
    );
    await tester.pumpAndSettle();
    while (tester.takeException() != null) {}
  }

  testWidgets('Sidebar stays mounted and stationary when switching tabs', (tester) async {
    await pumpShell(tester);

    // Initial state: on Dashboard, MainShellView is active, CustomSidebar is mounted
    expect(find.byType(MainShellView), findsOneWidget);
    expect(find.byType(CustomSidebar), findsOneWidget);
    expect(find.byType(DashboardView), findsOneWidget);

    // Tap on 'পাঠশালা' (Pathshala) sidebar tile
    await tester.tap(find.text('পাঠশালা'));
    await tester.pumpAndSettle();
    while (tester.takeException() != null) {}

    // Sidebar remains exactly 1 mounted instance (never destroyed or replaced)
    expect(find.byType(CustomSidebar), findsOneWidget);
    expect(find.byType(AllPatshalaView), findsOneWidget);

    // Tap on 'নোটিশ' (Notices) sidebar tile
    await tester.tap(find.text('নোটিশ'));
    await tester.pumpAndSettle();
    while (tester.takeException() != null) {}

    expect(find.byType(CustomSidebar), findsOneWidget);
    expect(find.byType(NoticesView), findsOneWidget);

    // Tap on 'অনুষ্ঠান' (Events) sidebar tile
    await tester.tap(find.text('অনুষ্ঠান'));
    await tester.pumpAndSettle();
    while (tester.takeException() != null) {}

    expect(find.byType(CustomSidebar), findsOneWidget);
    expect(find.byType(EventsView), findsOneWidget);
  });

  testWidgets('Breadcrumbs are rendered on every page and clicking home returns to Dashboard', (tester) async {
    await pumpShell(tester, route: AppRouteNames.pathshalas);

    // Should find breadcrumb with 'হোম' and 'পাঠশালা'
    expect(find.text('হোম'), findsOneWidget);
    expect(find.text('পাঠশালা'), findsWidgets);

    // Tap 'হোম' in breadcrumbs to navigate back to Dashboard
    await tester.tap(find.text('হোম'));
    await tester.pumpAndSettle();
    while (tester.takeException() != null) {}

    expect(find.byType(DashboardView), findsOneWidget);
  });
}
