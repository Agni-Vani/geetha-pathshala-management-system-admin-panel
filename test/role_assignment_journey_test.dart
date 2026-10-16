import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/features/authentication/presentation/view/role_assignment_journey_view.dart';
import 'package:geetha_pathshala_management_web/src/features/person/data/models/person_model.dart';
import 'package:geetha_pathshala_management_web/src/features/person/domain/entities/person_enums.dart';

const _widths = {
  'mobile-narrow': Size(304, 640),
  'mobile': Size(360, 740),
  'tablet': Size(834, 1100),
  'desktop': Size(1440, 900),
};

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await setupServiceLocator(useMockData: true);
  });

  List<String> drainOverflows(WidgetTester tester) {
    final problems = <String>[];
    Object? error;
    while ((error = tester.takeException()) != null) {
      final text = error.toString();
      if (text.contains('google_fonts') || text.contains('Failed to load font')) {
        continue;
      }
      problems.add(text);
    }
    return problems;
  }

  for (final entry in _widths.entries) {
    testWidgets('RoleAssignmentJourneyView lays out at ${entry.key} without overflows',
        (tester) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme().lightTheme,
          home: const RoleAssignmentJourneyView(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      final overflows = drainOverflows(tester);
      expect(overflows, isEmpty, reason: 'RoleAssignmentJourneyView @ ${entry.key}');
    });
  }

  testWidgets('RoleAssignmentJourneyView steps through the journey', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme().lightTheme,
        home: const RoleAssignmentJourneyView(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Step 1 is rendered
    expect(find.text('১. ব্যবহারকারী বা ব্যক্তি নির্বাচন করুন'), findsOneWidget);
    expect(find.text('নতুন ব্যক্তি হিসেবে তথ্য দিন'), findsOneWidget);

    // Click new person mode
    await tester.tap(find.text('নতুন ব্যক্তি হিসেবে তথ্য দিন'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Step 2 is active
    expect(find.text('২. ব্যক্তিগত তথ্য যাচাই ও সম্পাদনা'), findsOneWidget);
  });

  testWidgets('RoleAssignmentJourneyView opens in edit mode on Step 3 with prefilled person and role', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final person = PersonModel(
      id: 'p-001',
      organizationId: '00000000-0000-0000-0000-000000000001',
      legalName: 'Suman Roy',
      preferredName: 'Suman',
      dateOfBirth: DateTime(1990, 5, 12),
      gender: 'male',
      primaryPhone: '01711000000',
      primaryEmail: '123sumango@gmail.com',
      status: PersonStatus.active,
      createdByUserId: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme().lightTheme,
        home: RoleAssignmentJourneyView(
          initialPerson: person,
          initialRoleType: 'PATHSHALA_ADMIN',
          initialStep: 2,
          isEditMode: true,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Step 3 is rendered directly
    expect(find.text('৩. ভূমিকা ও পোর্টাল অ্যাক্সেস নির্ধারণ করুন'), findsOneWidget);
    expect(find.text('ভূমিকা হালনাগাদ ও সংরক্ষণ করুন'), findsOneWidget);
    expect(find.text('ভূমিকা ও অ্যাক্সেস সম্পাদনা ও হালনাগাদ'), findsOneWidget);
  });
}
