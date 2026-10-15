import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/presentation/widgets/division_filter_dropdown.dart';

void main() {
  const divisions = [
    'Barishal',
    'Chattogram',
    'Dhaka',
    'Khulna',
    'Mymensingh',
    'Rajshahi',
    'Rangpur',
    'Sylhet',
  ];

  for (final size in [const Size(304, 640), const Size(1440, 900)]) {
    testWidgets('search reveals, filters and resets divisions at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      String? selectedDivision;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: StatefulBuilder(
                builder: (context, update) => Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 260,
                    child: DivisionFilterDropdown(
                      divisions: divisions,
                      selectedDivision: selectedDivision,
                      onChanged: (value) =>
                          update(() => selectedDivision = value),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final button = find.byKey(const ValueKey('division-filter-button'));
      final search = find.byKey(const ValueKey('division-filter-search'));
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(search, findsNothing);
      await tester.tap(find.byTooltip('বিভাগ খুঁজুন'));
      await tester.pumpAndSettle();
      expect(search, findsOneWidget);
      if (size.width < 400) {
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        await tester.pumpAndSettle();
        expect(tester.getRect(search).bottom, lessThanOrEqualTo(340));
        expect(tester.takeException(), isNull);
        tester.view.viewInsets = const FakeViewPadding();
        await tester.pumpAndSettle();
      }
      await tester.enterText(search, '  rAnG  ');
      await tester.pumpAndSettle();
      expect(find.text('Rangpur'), findsOneWidget);
      expect(find.text('Dhaka'), findsNothing);
      await tester.tap(find.text('Rangpur'));
      await tester.pumpAndSettle();
      expect(selectedDivision, 'Rangpur');
      expect(search, findsNothing);

      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(search, findsNothing);
      expect(find.text('Dhaka'), findsOneWidget);
      await tester.tap(find.text('বিভাগ সমূহ'));
      await tester.pumpAndSettle();
      expect(selectedDivision, isNull);

      await tester.tap(button);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('বিভাগ খুঁজুন'));
      await tester.pumpAndSettle();
      await tester.enterText(search, 'missing division');
      await tester.pumpAndSettle();
      expect(find.text('কোন বিভাগ পাওয়া যায়নি।'), findsOneWidget);
      await tester.tap(find.byTooltip('সার্চ বন্ধ করুন'));
      await tester.pumpAndSettle();
      expect(search, findsNothing);
      expect(find.text('Dhaka'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byTooltip('বিভাগ খুঁজুন'), findsNothing);
      await tester.tap(button);
      await tester.pumpAndSettle();
      await tester.tapAt(Offset(2, size.height - 2));
      await tester.pumpAndSettle();
      expect(find.byTooltip('বিভাগ খুঁজুন'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
