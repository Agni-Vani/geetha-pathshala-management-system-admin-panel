import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/person/data/datasources/mock_person_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/person/data/repositories/person_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/person/domain/params/params.dart';

void main() {
  group('PersonRepositoryImpl Tests', () {
    late MockPersonDatasource mockDatasource;
    late PersonRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockPersonDatasource(processingDelay: Duration.zero);
      repository = PersonRepositoryImpl(mockDatasource);
    });

    test('searchPeople returns filtered people list', () async {
      final response = await repository.searchPeople(
        const SearchPeopleParams(
          organizationId: 'org-gp-central',
          query: 'Anirban',
          dateOfBirth: null,
          phone: null,
          email: null,
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, greaterThanOrEqualTo(1));
    });

    test('getPersonById returns person details', () async {
      final response = await repository.getPersonById('person-anirban-sen');
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.legalName, equals('Anirban Sen'));
    });
  });
}
