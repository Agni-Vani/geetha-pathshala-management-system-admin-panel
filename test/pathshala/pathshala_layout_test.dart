import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/widget/custom_widgets/custom_empty_state.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/features/pathshala/presentation/view/all_patshala_view.dart';
import 'package:geetha_pathshala_management_web/src/features/pathshala/presentation/widgets/custom_pathshala_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/features/pathshala/domain/pathshala_domain.dart';
import 'package:geetha_pathshala_management_web/src/features/pathshala/presentation/controller/list_pathshalas_controller.dart';

// The mock seed uses a named organization; the live page requests a UUID.
// Adapt that ID only in the test so the real UI renders populated cards.
class _SeededPathshalasController extends ListPathshalasController {
  _SeededPathshalasController() : super(listPathshalas: sl<ListPathshalas>());

  @override
  Future<void> load({
    required String organizationId,
    String? searchQuery,
    SnackbarNotifier? snackbarNotifier,
  }) => super.load(
    organizationId: 'org-gp-central',
    searchQuery: searchQuery,
    snackbarNotifier: snackbarNotifier,
  );
}

class _PagedPathshalasController extends _SeededPathshalasController {
  @override
  Future<void> load({
    required String organizationId,
    String? searchQuery,
    SnackbarNotifier? snackbarNotifier,
  }) async {
    await super.load(
      organizationId: organizationId,
      searchQuery: searchQuery,
      snackbarNotifier: snackbarNotifier,
    );
    pathshalas = [...pathshalas, ...pathshalas, ...pathshalas];
    notifyListeners();
  }
}

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await setupServiceLocator(useMockData: true);
    await sl.unregister<ListPathshalasController>();
    sl.registerFactory<ListPathshalasController>(
      () => _SeededPathshalasController(),
    );
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

  Future<void> pumpPage(
    WidgetTester tester,
    Size size,
    double scale, {
    bool dark = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: dark ? AppTheme().darkTheme : AppTheme().lightTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: const AllPatshalaView(),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// On mobile the search field is hidden behind an icon in the filter row.
  Future<void> openSearch(WidgetTester tester) async {
    final toggle = find.byKey(const ValueKey('pathshala-search-toggle'));
    if (toggle.evaluate().isEmpty) return;
    await tester.ensureVisible(toggle);
    await tester.pumpAndSettle();
    await tester.tap(toggle);
    await tester.pumpAndSettle();
  }

  const sizes = {
    'narrow phone': Size(304, 640),
    'phone': Size(390, 844),
    'landscape': Size(932, 430),
    'small tablet': Size(640, 960),
    'tablet': Size(834, 1100),
    'small desktop': Size(1024, 768),
    'desktop': Size(1440, 900),
    'reported desktop': Size(1545, 804),
  };

  for (final size in sizes.entries) {
    for (final scale in [1.0, 1.3, 1.6]) {
      testWidgets('pathshala UI fits ${size.key} at text scale $scale', (
        tester,
      ) async {
        await pumpPage(tester, size.value, scale);
        expectNoLayoutErrors(tester);
        expect(find.byType(CustomPathshalaCard), findsNWidgets(3));
        final isMobile = size.value.width < 640;
        expect(
          find.byType(TextField),
          isMobile ? findsNothing : findsOneWidget,
        );
        await openSearch(tester);
        final field = tester.getRect(find.byType(TextField));
        if (isMobile) {
          // The revealed field sits under the filter row.
          expect(
            field.top,
            greaterThan(
              tester
                  .getBottomLeft(find.widgetWithText(TextButton, 'Inactive'))
                  .dy,
            ),
          );
        }
        expect(field.left, greaterThanOrEqualTo(0));
        expect(field.right, lessThanOrEqualTo(size.value.width));
        await tester.ensureVisible(
          find.byKey(const ValueKey('pathshala-pagination')),
        );
        await tester.pumpAndSettle();
        final pagination = tester.getRect(
          find.byKey(const ValueKey('pathshala-pagination')),
        );
        // The pager is just the three page buttons — no "Showing …" text.
        expect(
          find.textContaining('Showing', findRichText: true),
          findsNothing,
        );
        final more = find.byKey(const ValueKey('pathshala-page-more'));
        expect(more, findsOneWidget);
        final rect = tester.getRect(more);
        expect(rect.left, greaterThanOrEqualTo(pagination.left));
        expect(rect.right, lessThanOrEqualTo(pagination.right));
        expect(rect.bottom, lessThanOrEqualTo(pagination.bottom));
        expect(find.text('Previous'), findsNothing);
        expect(find.text('Next'), findsNothing);
        expectNoLayoutErrors(tester);
      });
    }
  }

  for (final size in [
    const Size(390, 844),
    const Size(834, 1112),
    const Size(1440, 900),
  ]) {
    testWidgets('empty message is centered at width ${size.width}', (
      tester,
    ) async {
      await pumpPage(tester, size, 1);
      await openSearch(tester);
      await tester.enterText(find.byType(TextField), 'no-matching-pathshala');
      await tester.pumpAndSettle();
      final empty = find.byType(CustomEmptyState);
      expect(empty, findsOneWidget);
      final footer = tester.getRect(
        find
            .ancestor(
              of: find.text(
                '© 2024 Geetha Pathshala Management. All rights reserved.',
              ),
              matching: find.byType(Container),
            )
            .first,
      );
      final isMobile = size.width < 640;
      // The header ends 18 below the filter row's divider, or — on mobile —
      // 18 below the search field revealed under it.
      final headerBottom = isMobile
          ? tester.getBottomLeft(find.byType(TextField)).dy + 18
          : tester
                    .getBottomLeft(find.widgetWithText(TextButton, 'Inactive'))
                    .dy +
                19;
      final bottomPadding = isMobile ? 16.0 : 24.0;
      final center = tester.getCenter(empty);
      expect(center.dx, closeTo(footer.center.dx, 1));
      expect(
        center.dy,
        closeTo((headerBottom + footer.top - bottomPadding) / 2, 2),
      );
      expectNoLayoutErrors(tester);
    });
  }

  testWidgets('status filters and clearable search still update the cards', (
    tester,
  ) async {
    await pumpPage(tester, const Size(390, 844), 1);
    await tester.tap(find.text('Inactive').first);
    await tester.pumpAndSettle();
    expect(find.byType(CustomPathshalaCard), findsOneWidget);
    expect(find.text('Sylhet East Gita Pathshala'), findsOneWidget);
    await tester.tap(find.text('Active').first);
    await tester.pumpAndSettle();
    expect(find.byType(CustomPathshalaCard), findsNWidgets(2));
    await tester.tap(find.text('All'));
    await openSearch(tester);
    await tester.enterText(find.byType(TextField), 'Dhaka');
    await tester.pumpAndSettle();
    expect(find.byType(CustomPathshalaCard), findsOneWidget);
    expect(find.text('Dhaka Central Gita Pathshala'), findsOneWidget);
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomPathshalaCard), findsNWidgets(3));
    // Closing the mobile search hides the field and drops its query.
    await tester.enterText(find.byType(TextField), 'Dhaka');
    await tester.pumpAndSettle();
    expect(find.byType(CustomPathshalaCard), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('pathshala-search-toggle')));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(CustomPathshalaCard), findsNWidgets(3));
    expectNoLayoutErrors(tester);
  });

  for (final size in [const Size(390, 844), const Size(1440, 900)]) {
    testWidgets(
      'pagination controls move between pages at width ${size.width}',
      (tester) async {
        await sl.unregister<ListPathshalasController>();
        sl.registerFactory<ListPathshalasController>(
          () => _PagedPathshalasController(),
        );
        addTearDown(() async {
          await sl.unregister<ListPathshalasController>();
          sl.registerFactory<ListPathshalasController>(
            () => _SeededPathshalasController(),
          );
        });
        await pumpPage(tester, size, 1.3);
        expect(find.byType(CustomPathshalaCard), findsNWidgets(8));
        final current = find.byKey(const ValueKey('pathshala-page-current'));
        final next = find.byKey(const ValueKey('pathshala-page-next'));
        final more = find.byKey(const ValueKey('pathshala-page-more'));
        expect(
          find.descendant(of: current, matching: find.text('1')),
          findsOneWidget,
        );
        await tester.ensureVisible(next);
        await tester.tap(next);
        await tester.pumpAndSettle();
        expect(find.byType(CustomPathshalaCard), findsOneWidget);
        expect(
          find.descendant(of: current, matching: find.text('2')),
          findsOneWidget,
        );
        // "More" lists every page in a grid; picking one jumps to it.
        await tester.ensureVisible(more);
        await tester.tap(more);
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('pathshala-page-option-2')),
          findsOneWidget,
        );
        final screen = tester.view.physicalSize;
        final picker = tester.getRect(
          find.byKey(const ValueKey('pathshala-page-option-2')),
        );
        expect(picker.left, greaterThanOrEqualTo(0));
        expect(picker.right, lessThanOrEqualTo(screen.width));
        expect(picker.top, greaterThanOrEqualTo(0));
        await tester.tap(find.byKey(const ValueKey('pathshala-page-option-1')));
        await tester.pumpAndSettle();
        expect(find.byType(CustomPathshalaCard), findsNWidgets(8));
        expect(
          find.descendant(of: current, matching: find.text('1')),
          findsOneWidget,
        );
        expectNoLayoutErrors(tester);
      },
    );
  }

  testWidgets('dark phone layout fits with larger text', (tester) async {
    await pumpPage(tester, const Size(390, 844), 1.6, dark: true);
    expectNoLayoutErrors(tester);
  });

  testWidgets(
    'long card text and optional stats fit without clipping actions',
    (tester) async {
      tester.view.physicalSize = const Size(304, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var views = 0;
      var edits = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme().lightTheme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!,
          ),
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: CustomPathshalaCard(
                name: 'A very long community Gita Pathshala name in Dhaka',
                code: 'PATH-DHAKA-CENTRAL-000001',
                location: 'A long address in Dhanmondi, Dhaka, Bangladesh',
                studentsCount: 1248,
                teachersCount: 86,
                onView: () => views++,
                onEdit: () => edits++,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expectNoLayoutErrors(tester);
      for (final label in ['View Details', 'Edit']) {
        await tester.ensureVisible(find.text(label));
        await tester.tap(find.text(label));
      }
      expect(views, 1);
      expect(edits, 1);
      expectNoLayoutErrors(tester);
    },
  );
}
