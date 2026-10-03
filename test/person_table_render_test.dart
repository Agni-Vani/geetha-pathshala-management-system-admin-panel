import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/features/person/domain/person_domain.dart';
import 'package:geetha_pathshala_management_web/src/features/person/data/models/person_model.dart';
import 'package:geetha_pathshala_management_web/src/features/person/presentation/view/all_people_view.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await setupServiceLocator(useMockData: true);
  });

  testWidgets('AllPeopleView renders 2 persons in table without RenderFlex overflow or error', (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme().lightTheme,
        home: const AllPeopleView(),
      ),
    );
    await tester.pumpAndSettle();

    final dynamic state = tester.state(find.byType(AllPeopleView));
    state.listPeopleController.people = [
      PersonModel(
        id: '1',
        organizationId: '00000000-0000-0000-0000-000000000001',
        legalName: 'Jane Austen',
        preferredName: 'Jane',
        primaryPhone: '01711111111',
        primaryEmail: 'jane@example.com',
        gender: 'female',
        dateOfBirth: DateTime(1995, 5, 10),
        status: PersonStatus.active,
        createdByUserId: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      PersonModel(
        id: '2',
        organizationId: '00000000-0000-0000-0000-000000000001',
        legalName: 'George Orwell',
        preferredName: 'George',
        primaryPhone: '01822222222',
        primaryEmail: 'george@example.com',
        gender: 'male',
        dateOfBirth: DateTime(1985, 3, 1),
        status: PersonStatus.active,
        createdByUserId: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    state.listPeopleController.notifyListeners();

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Jane'), findsOneWidget);
    expect(find.text('George'), findsOneWidget);
    expect(find.text('01711111111'), findsOneWidget);
    expect(find.text('01822222222'), findsOneWidget);
    expect(find.text('Active'), findsNWidgets(3));
  });
}
