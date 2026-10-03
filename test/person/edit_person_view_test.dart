import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/features/person/domain/person_domain.dart';
import 'package:geetha_pathshala_management_web/src/features/person/presentation/view/add_person_view.dart';

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await setupServiceLocator(useMockData: true);
  });

  testWidgets('AddPersonRegistryView renders in edit mode and manages qualifications & experiences', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1280, 1200);
    addTearDown(tester.view.reset);

    // Retrieve seeded person from repository
    final person = (await sl<GetPersonById>()('person-anirban-sen')).data!;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme().lightTheme,
        home: AddPersonRegistryView(existingPerson: person),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Edit Person header, breadcrumbs, and button
    expect(find.text('Edit Person'), findsOneWidget);
    expect(find.text('ব্যক্তি তথ্য সম্পাদন'), findsOneWidget);
    expect(find.text('Update Person'), findsOneWidget);

    // Verify pre-filled legal name
    expect(find.text(person.legalName), findsOneWidget);

    // Wait for qualifications & experiences to finish loading from mock datasource
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();

    // Verify existing educational qualifications are loaded
    expect(find.text('B.A. (Honours) in Sanskrit'), findsOneWidget);
    expect(find.text('University of Dhaka'), findsOneWidget);

    // Verify existing work experiences are loaded
    expect(find.text('Lead Gita Instructor'), findsOneWidget);
    expect(find.text('Geetha Pathshala Trust'), findsOneWidget);

    // Test deleting the qualification
    final eduDeleteButton = find.byTooltip('Delete Qualification');
    expect(eduDeleteButton, findsOneWidget);
    await tester.ensureVisible(eduDeleteButton);
    await tester.tap(eduDeleteButton);
    await tester.pumpAndSettle();

    // Verify confirmation dialog
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Delete Qualification'), findsWidgets);

    // Confirm deletion
    await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
    await tester.pumpAndSettle();

    // Verify dialog closed and qualification removed
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('B.A. (Honours) in Sanskrit'), findsNothing);

    // Test deleting the work experience
    final expDeleteButton = find.byTooltip('Delete Experience');
    expect(expDeleteButton, findsOneWidget);
    await tester.ensureVisible(expDeleteButton);
    await tester.tap(expDeleteButton);
    await tester.pumpAndSettle();

    // Verify confirmation dialog
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Delete Work Experience'), findsWidgets);

    // Confirm deletion
    await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
    await tester.pumpAndSettle();

    // Verify dialog closed and experience removed
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Lead Gita Instructor'), findsNothing);
  });
}
