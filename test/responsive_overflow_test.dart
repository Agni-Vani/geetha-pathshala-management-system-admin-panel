import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/core/navigation/app_route_builders.dart';
import 'package:geetha_pathshala_management_web/src/core/navigation/app_route_names.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/widget/custom_widgets/custom_top_bar.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/widget/custom_widgets/custom_empty_state.dart';
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

  for (final width in [
    ..._widths.entries,
    const MapEntry('marked-mobile', Size(500, 950)),
  ]) {
    testWidgets('IAM role cards lay out at ${width.key}', (tester) async {
      await pumpRoute(tester, AppRouteNames.iam, width.value);
      // IAM loads the users, roles, permissions and related records in sequence.
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(drainOverflows(tester), isEmpty);

      final rolesTab = find.text('সিস্টেম রোল ও অনুমতি');
      await tester.ensureVisible(rolesTab);
      await tester.tap(rolesTab);
      await tester.pumpAndSettle();

      expect(find.text('Scope: PATHSHALA'), findsOneWidget);
      expect(drainOverflows(tester), isEmpty);
    });
  }

  for (final width in [
    ..._widths.entries,
    const MapEntry('marked-tablet', Size(1000, 900)),
    const MapEntry('wrapped-header', Size(1328, 900)),
    const MapEntry('wide-desktop', Size(1578, 900)),
  ]) {
    testWidgets('people empty state lays out at ${width.key}', (tester) async {
      await pumpRoute(tester, AppRouteNames.peopleRegistry, width.value);
      final search = tester.getRect(find.byType(TextField));
      final addButton = tester.getRect(
        find.byKey(const ValueKey('people-add-person')),
      );
      if (width.value.width < 640) {
        expect(addButton.width, lessThan(search.width * .5));
        expect(
          addButton.bottom,
          lessThan(tester.getTopLeft(find.text('Inactive')).dy),
        );
      }
      final occupation = tester.getRect(find.text('All Occupation').first);
      final inlineSearch = width.key.contains('desktop');
      if (inlineSearch) {
        expect(search.center.dy, closeTo(occupation.center.dy, 2));
        expect(
          search.left,
          closeTo(
            tester
                    .getTopRight(
                      find.byKey(const ValueKey('people-filter-Occupation')),
                    )
                    .dx +
                24,
            1,
          ),
        );
      } else {
        expect(search.top, greaterThan(occupation.bottom));
      }
      expect(
        search.bottom,
        lessThan(tester.getTopLeft(find.byType(Divider).last).dy),
      );
      if (inlineSearch) {
        expect(
          search.right,
          closeTo(
            tester
                .getTopRight(find.byKey(const ValueKey('people-add-person')))
                .dx,
            1,
          ),
        );
      } else {
        expect(
          search.left,
          closeTo(tester.getTopLeft(find.byType(Divider).last).dx, 1),
        );
        expect(
          search.width,
          closeTo(tester.getSize(find.byType(Divider).last).width, 1),
        );
      }
      final statusTab = find
          .ancestor(of: find.text('Inactive'), matching: find.byType(InkWell))
          .first;
      expect(tester.getSize(statusTab).height, lessThanOrEqualTo(40));
      await tester.ensureVisible(find.text('Inactive'));
      await tester.tap(find.text('Inactive'));
      await tester.pumpAndSettle();
      expect(find.text('No people in this category'), findsOneWidget);
      final empty = find.byType(CustomEmptyState);
      final footer = find.textContaining('All rights reserved');
      expect(
        tester.getCenter(empty).dx,
        closeTo(tester.getCenter(footer).dx, 1),
      );
      expect(drainOverflows(tester), isEmpty);
    });
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
        initialRoute: AppRouteNames.pathshalas,
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
      await pumpRoute(tester, AppRouteNames.peopleRegistry, width.value);
      drainOverflows(tester);

      await tester.tap(
        find.byKey(const ValueKey('people-add-person')),
        warnIfMissed: false,
      );
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
