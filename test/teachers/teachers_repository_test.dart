import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/teachers/data/datasources/mock_teachers_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/teachers/data/repositories/teachers_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/teachers/domain/params/params.dart';

void main() {
  group('TeachersRepositoryImpl Tests', () {
    late MockTeachersDatasource mockDatasource;
    late TeachersRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockTeachersDatasource(processingDelay: Duration.zero);
      repository = TeachersRepositoryImpl(datasource: mockDatasource);
    });

    test('createTeacherProfile creates a teacher profile', () async {
      final response = await repository.createTeacherProfile(
        const CreateTeacherProfileParams(
          personId: 'person-anirban-sen',
          organizationId: 'org-gp-central',
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.personId, equals('person-anirban-sen'));
    });

    test('assignTeacher creates a teacher assignment', () async {
      final response = await repository.assignTeacher(
        AssignTeacherParams(
          teacherProfileId: 'teacher-001',
          pathshalaId: 'pathshala-dhaka-central',
          groupId: 'group-gita-basic-01',
          role: 'Lead Teacher',
          effectiveFrom: DateTime.now(),
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.role, equals('Lead Teacher'));
    });

    test('listTeacherAssignments returns assignments', () async {
      await repository.assignTeacher(
        AssignTeacherParams(
          teacherProfileId: 'teacher-001',
          pathshalaId: 'pathshala-dhaka-central',
          groupId: 'group-gita-basic-01',
          role: 'Lead Teacher',
          effectiveFrom: DateTime.now(),
        ),
      );
      final response = await repository.listTeacherAssignments(
        const ListTeacherAssignmentsParams(pathshalaId: 'pathshala-dhaka-central'),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, equals(1));
    });

    test('listTeachers returns seeded teachers', () async {
      final response = await repository.listTeachers(const ListTeachersParams());
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, equals(7));
      expect(success.data.first.name, equals('রমেশ শাস্ত্রী'));
    });
  });
}
