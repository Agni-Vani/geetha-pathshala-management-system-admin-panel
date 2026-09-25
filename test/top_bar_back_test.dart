import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/core/navigation/app_route_builders.dart';
import 'package:geetha_pathshala_management_web/src/core/navigation/app_route_names.dart';
import 'package:geetha_pathshala_management_web/src/features/pathshala/presentation/view/all_patshala_view.dart';

Future<void> _boot(WidgetTester tester, String route) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(393, 800);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme().lightTheme,
      initialRoute: route,
      routes: RegistryRouteBuilders.routes,
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));
  while (tester.takeException() != null) {}
}

/// The "« Overview" chip used to always call `maybePop`, which does nothing on
/// a top-level screen, so it looked tappable but was dead. These pin down what
/// it does from each kind of screen.
void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await setupServiceLocator(useMockData: true);
  });

  testWidgets('hidden on overview', (tester) async {
    await _boot(tester, RegistryRouteNames.dashboard);
    expect(find.byIcon(Icons.keyboard_double_arrow_left), findsNothing);
    // The app's name takes the empty slot instead.
    expect(find.text('গীতা পাঠশালা'), findsOneWidget);
  });

  testWidgets('has no profile button', (tester) async {
    await _boot(tester, RegistryRouteNames.pathshalas);
    expect(find.byIcon(Icons.person_outline), findsNothing);
  });

  testWidgets('hidden on a top-level screen, name shown instead', (tester) async {
    await _boot(tester, RegistryRouteNames.pathshalas);
    expect(find.byIcon(Icons.keyboard_double_arrow_left), findsNothing);
    expect(find.text('গীতা পাঠশালা'), findsOneWidget);
  });

  testWidgets('pops back from a pushed screen', (tester) async {
    await _boot(tester, RegistryRouteNames.pathshalas);
    await tester.tap(find.text('Add New Pathshala').first, warnIfMissed: false);
    await tester.pumpAndSettle();
    while (tester.takeException() != null) {}
    expect(find.byType(AllPatshalaView), findsNothing);

    await tester.tap(find.byIcon(Icons.keyboard_double_arrow_left));
    await tester.pumpAndSettle();
    while (tester.takeException() != null) {}

    expect(find.byType(AllPatshalaView), findsOneWidget);
  });
}
