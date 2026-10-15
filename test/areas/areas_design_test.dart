import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/presentation/widgets/geographic_areas_management_widget.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await setupServiceLocator(useMockData: true);
  });

  void expectNoLayoutErrors(WidgetTester tester) {
    final errors = <String>[];
    Object? error;
    while ((error = tester.takeException()) != null) {
      final message = error.toString();
      if (!message.contains('google_fonts') &&
          !message.contains('Failed to load font')) {
        errors.add(message);
      }
    }
    expect(errors, isEmpty);
  }

  const sizes = {
    'narrow phone': Size(304, 640),
    'phone': Size(390, 844),
    'landscape': Size(932, 430),
    'tablet': Size(834, 1100),
    'desktop': Size(1440, 900),
  };

  for (final size in sizes.entries) {
    for (final label in ['নতুন বিভাগ', 'নতুন জেলা', 'নতুন উপজেলা']) {
      testWidgets('$label dialog fits ${size.key}', (tester) async {
        tester.view.physicalSize = size.value;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme().lightTheme,
            home: const Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: GeographicAreasManagementWidget(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expectNoLayoutErrors(tester);
        await tester.ensureVisible(find.text(label));
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expectNoLayoutErrors(tester);
        final dialog = tester.getRect(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Material && widget.type == MaterialType.card,
            ),
          ),
        );
        expect(dialog.left, greaterThanOrEqualTo(16));
        expect(dialog.right, lessThanOrEqualTo(size.value.width - 16));
        expect(dialog.top, greaterThanOrEqualTo(24));
        expect(dialog.bottom, lessThanOrEqualTo(size.value.height - 24));
        expect(find.text('সংরক্ষণ করুন'), findsOneWidget);
        await tester.tap(find.byTooltip('বন্ধ করুন'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
        expectNoLayoutErrors(tester);
      });
    }
  }

  testWidgets(
    'side by side panes share their height with populated and empty districts',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme().lightTheme,
          home: const Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: GeographicAreasManagementWidget(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final districts = find.byKey(const ValueKey('areas-districts-pane'));
      final upazilas = find.byKey(const ValueKey('areas-upazilas-pane'));
      void expectEqualHeights() {
        expect(tester.getRect(districts).top, tester.getRect(upazilas).top);
        final detailHeading = find.textContaining('জেলার উপজেলাসমূহ');
        if (detailHeading.evaluate().isNotEmpty) {
          expect(
            tester.getCenter(find.text('জেলার তালিকা')).dy,
            closeTo(tester.getCenter(detailHeading).dy, .01),
          );
        }
        expect(
          tester.getRect(districts).right,
          closeTo(tester.getRect(upazilas).left, .01),
        );
        expect(
          tester.getRect(districts).bottom,
          closeTo(tester.getRect(upazilas).bottom, .01),
        );
        expectNoLayoutErrors(tester);
      }

      expectEqualHeights();
      final upazilaSearch = find.byKey(const ValueKey('areas-upazila-search'));
      expect(upazilaSearch, findsNothing);
      expect(find.textContaining('মোট '), findsNothing);
      await tester.tap(find.byTooltip('উপজেলা খুঁজুন'));
      await tester.pumpAndSettle();
      expect(upazilaSearch, findsOneWidget);
      await tester.enterText(upazilaSearch, 'missing upazila');
      await tester.pumpAndSettle();
      expect(find.text('এই নামে কোন উপজেলা পাওয়া যায়নি।'), findsOneWidget);
      expectEqualHeights();
      await tester.tap(find.byTooltip('উপজেলা সার্চ বন্ধ করুন'));
      await tester.pumpAndSettle();
      expect(upazilaSearch, findsNothing);
      expect(find.text('এই নামে কোন উপজেলা পাওয়া যায়নি।'), findsNothing);
      await tester.enterText(
        find.widgetWithText(TextField, 'জেলার নাম খুঁজুন...'),
        'missing district',
      );
      await tester.pumpAndSettle();
      expect(find.text('কোন জেলা পাওয়া যায়নি।'), findsOneWidget);
      expect(find.textContaining('জেলার উপজেলাসমূহ'), findsNothing);
      expect(find.byTooltip('উপজেলা খুঁজুন'), findsNothing);
      expect(
        find.text('উপজেলা দেখানোর জন্য কোনো জেলা পাওয়া যায়নি।'),
        findsOneWidget,
      );
      expectEqualHeights();
    },
  );

  testWidgets('phone dialog fits above the keyboard with larger text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme().darkTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.3)),
          child: child!,
        ),
        home: const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: GeographicAreasManagementWidget(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expectNoLayoutErrors(tester);
    await tester.ensureVisible(find.text('নতুন উপজেলা'));
    await tester.tap(find.text('নতুন উপজেলা'));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expectNoLayoutErrors(tester);
    expect(tester.getRect(find.text('সংরক্ষণ করুন')).bottom, lessThan(552));
  });

  testWidgets('phone lists districts alone, then one district with its '
      'upazilas', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme().lightTheme,
        home: const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: GeographicAreasManagementWidget(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final districtsPane = find.byKey(const ValueKey('areas-districts-pane'));
    final upazilasPane = find.byKey(const ValueKey('areas-upazilas-pane'));
    final showAll = find.byKey(const ValueKey('areas-show-all-districts'));
    // One per district row.
    final tiles = find.descendant(
      of: districtsPane,
      matching: find.byIcon(Icons.location_city_rounded),
    );
    final search = find.byKey(const ValueKey('areas-district-search'));
    final searchToggle = find.byKey(
      const ValueKey('areas-district-search-toggle'),
    );

    // Every district, no upazilas yet.
    final districtCount = tiles.evaluate().length;
    expect(districtCount, greaterThan(1));
    expect(upazilasPane, findsNothing);
    expect(showAll, findsNothing);

    // The district search hides behind the header's icon and narrows the list.
    expect(search, findsNothing);
    await tester.ensureVisible(searchToggle);
    await tester.tap(searchToggle);
    await tester.pumpAndSettle();
    expect(search, findsOneWidget);
    await tester.enterText(search, 'no-such-district');
    await tester.pumpAndSettle();
    expect(tiles, findsNothing);
    await tester.tap(searchToggle);
    await tester.pumpAndSettle();
    expect(search, findsNothing);
    expect(tiles, findsNWidgets(districtCount));

    // Picking one leaves only it, with its upazilas underneath.
    await tester.ensureVisible(tiles.at(1));
    await tester.tap(tiles.at(1));
    await tester.pumpAndSettle();
    expect(upazilasPane, findsOneWidget);
    expect(showAll, findsOneWidget);
    expect(tiles, findsOneWidget);
    expect(searchToggle, findsNothing);
    expect(
      tester.getTopLeft(upazilasPane).dy,
      greaterThanOrEqualTo(tester.getBottomLeft(districtsPane).dy),
    );

    // The button brings the full list back and hides the upazilas again.
    await tester.ensureVisible(showAll);
    await tester.tap(showAll);
    await tester.pumpAndSettle();
    expect(upazilasPane, findsNothing);
    expect(tiles, findsNWidgets(districtCount));
    expectNoLayoutErrors(tester);
  });
}
