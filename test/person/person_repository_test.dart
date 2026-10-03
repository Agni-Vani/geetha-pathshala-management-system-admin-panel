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

    test('deletePersonEducation deletes qualification', () async {
      final edusRes = await repository.getPersonEducations('person-anirban-sen');
      expect(edusRes, isA<SuccessRepoCall>());
      final edus = (edusRes as SuccessRepoCall).data;
      expect(edus.isNotEmpty, isTrue);
      final firstEduId = edus.first.id;

      final delRes = await repository.deletePersonEducation(firstEduId);
      expect(delRes, isA<SuccessRepoCall>());

      final afterRes = await repository.getPersonEducations('person-anirban-sen');
      final afterEdus = (afterRes as SuccessRepoCall).data;
      expect(afterEdus.any((e) => e.id == firstEduId), isFalse);
    });

    test('deletePersonWorkExperience deletes experience', () async {
      final expsRes = await repository.getPersonWorkExperiences('person-anirban-sen');
      expect(expsRes, isA<SuccessRepoCall>());
      final exps = (expsRes as SuccessRepoCall).data;
      expect(exps.isNotEmpty, isTrue);
      final firstExpId = exps.first.id;

      final delRes = await repository.deletePersonWorkExperience(firstExpId);
      expect(delRes, isA<SuccessRepoCall>());

      final afterRes = await repository.getPersonWorkExperiences('person-anirban-sen');
      final afterExps = (afterRes as SuccessRepoCall).data;
      expect(afterExps.any((e) => e.id == firstExpId), isFalse);
    });
  });
}

