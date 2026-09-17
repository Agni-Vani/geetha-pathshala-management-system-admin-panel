import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/view/registry_route_builders.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/view/registry_route_names.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/widgets/custom_widgets/custom_top_bar.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pumps every screen at the widths the app has to survive and fails on any
/// RenderFlex overflow, so a layout regression shows up here rather than as a
/// yellow-and-black stripe in the browser.
///
/// Note: the test font has different metrics than the shipped one, so Bengali
/// labels lay out wider here. That makes this stricter than the real app — a
/// pass means the layout holds even for unusually wide text.
const _widths = {
  'mobile-narrow': Size(304, 640),
  'mobile': Size(360, 740),
  'phone-landscape': Size(932, 430),
  'tablet': Size(834, 1100),
  'desktop': Size(1440, 900),
};

void main() {
  setUpAll(() async {
    // Fonts cannot be fetched in tests; without this each screen throws a
    // network error that would drown out the overflows we are looking for.
    GoogleFonts.config.allowRuntimeFetching = false;
    await setupServiceLocator(useMockData: true);
  });

  final routes = RegistryRouteBuilders.routes;

  List<String> drainOverflows(WidgetTester tester) {
    final problems = <String>[];
    Object? error;
    while ((error = tester.takeException()) != null) {
      final text = error.toString();
      if (text.contains('google_fonts') ||
          text.contains('Failed to load font')) {
        continue;
      }
      problems.add(text);
    }
    return problems;
  }

  Future<void> pumpRoute(WidgetTester tester, String route, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme().lightTheme,
        initialRoute: route,
        routes: routes,
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
  }

  for (final route in routes.keys) {
    for (final width in _widths.entries) {
      testWidgets('$route lays out at ${width.key}', (tester) async {
        await pumpRoute(tester, route, width.value);
        expect(
          drainOverflows(tester),
          isEmpty,
          reason: '$route @ ${width.key}',
        );
      });
    }
  }

  testWidgets('content clears the status bar and home indicator', (
    tester,
  ) async {
    // iPhone 16 Pro: 393x852 logical, 59pt status bar, 34pt home indicator.
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(393, 852);
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme().lightTheme,
        initialRoute: RegistryRouteNames.pathshalas,
        routes: routes,
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    drainOverflows(tester);

    final topBar = tester.getRect(find.byType(CustomTopBar));
    expect(
      topBar.top,
      greaterThanOrEqualTo(59.0),
      reason: 'top bar must start below the status bar / notch',
    );

    final footer = tester.getRect(find.textContaining('All rights reserved'));
    expect(
      footer.bottom,
      lessThanOrEqualTo(852.0 - 34.0),
      reason: 'footer must stay above the home indicator',
    );
  });

  // Pushed, so it has no route name of its own.
  for (final width in _widths.entries) {
    testWidgets('add-person form lays out at ${width.key}', (tester) async {
      await pumpRoute(tester, RegistryRouteNames.peopleRegistry, width.value);
      drainOverflows(tester);

      await tester.tap(find.text('Add New Person').first, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));

      expect(
        drainOverflows(tester),
        isEmpty,
        reason: 'add-person @ ${width.key}',
      );
    });
  }
}
