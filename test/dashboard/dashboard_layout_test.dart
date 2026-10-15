import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/features/dashboard/presentation/view/dashboard_view.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await setupServiceLocator(useMockData: true);
  });

  const sizes = {
    'narrow phone': Size(304, 640),
    'phone': Size(390, 844),
    'landscape': Size(932, 430),
    'small tablet': Size(640, 960),
    'tablet': Size(834, 1100),
    'small desktop': Size(1024, 768),
    'desktop': Size(1440, 900),
    'reported desktop': Size(1554, 843),
  };

  for (final size in sizes.entries) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('dashboard fits ${size.key} at text scale $scale', (
        tester,
      ) async {
        tester.view.physicalSize = size.value;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme().lightTheme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: const DashboardView(),
          ),
        );
        await tester.pumpAndSettle();
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
        expect(find.text('Students by Gender'), findsOneWidget);
        expect(find.text('ছেলে 62%'), findsOneWidget);
        expect(find.text('মেয়ে 38%'), findsOneWidget);
        final card = tester.getRect(
          find.byKey(const ValueKey('dashboard-gender-card')),
        );
        for (final label in ['ছেলে 62%', 'মেয়ে 38%']) {
          final legend = tester.getRect(find.text(label));
          expect(legend.left, greaterThanOrEqualTo(card.left + 20));
          expect(legend.right, lessThanOrEqualTo(card.right - 20));
          expect(legend.bottom, lessThanOrEqualTo(card.bottom - 20));
        }
      });
    }
  }
}
