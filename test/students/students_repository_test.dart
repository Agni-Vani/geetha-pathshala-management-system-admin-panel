import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/students/data/datasources/mock_students_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/students/data/repositories/students_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/students/domain/params/params.dart';

void main() {
  group('StudentsRepositoryImpl Tests', () {
    late MockStudentsDatasource mockDatasource;
    late StudentsRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockStudentsDatasource(processingDelay: Duration.zero);
      repository = StudentsRepositoryImpl(datasource: mockDatasource);
    });

    test('admitStudent creates a student admission record', () async {
      final response = await repository.admitStudent(
        const AdmitStudentParams(
          organizationId: 'org-gp-central',
          pathshalaId: 'pathshala-dhaka-central',
          personId: 'person-anirban-sen',
          rollNumber: 'DH-2026-002',
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.rollNumber, equals('DH-2026-002'));
    });

    test('listStudentAdmissions returns student admissions', () async {
      final response = await repository.listStudentAdmissions(
        const ListStudentAdmissionsParams(pathshalaId: 'pathshala-dhaka-central'),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, greaterThanOrEqualTo(1));
    });
  });
}
