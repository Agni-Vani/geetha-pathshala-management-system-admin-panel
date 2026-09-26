import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/classes/data/datasources/mock_classes_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/classes/data/repositories/classes_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/classes/domain/params/params.dart';

void main() {
  group('ClassesRepositoryImpl Tests', () {
    late MockClassesDatasource mockDatasource;
    late ClassesRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockClassesDatasource(processingDelay: Duration.zero);
      repository = ClassesRepositoryImpl(datasource: mockDatasource);
    });

    test('listEducationalGroups returns matching groups', () async {
      final response = await repository.listEducationalGroups(
        const ListGroupsParams(pathshalaId: 'pathshala-dhaka-central'),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, greaterThanOrEqualTo(1));
    });

    test('listAcademicYears returns matching academic years', () async {
      final response = await repository.listAcademicYears('org-gp-central');
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, greaterThanOrEqualTo(1));
    });

    test('listClassSchedules returns seeded schedules', () async {
      final response = await repository.listClassSchedules(
        const ListClassSchedulesParams(pathshalaId: 'pathshala-dhaka-central'),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, greaterThanOrEqualTo(1));
      expect(success.data.first.subject, isNotEmpty);
    });
  });
}
