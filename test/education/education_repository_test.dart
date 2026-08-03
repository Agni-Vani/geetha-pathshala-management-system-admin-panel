import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/education/data/datasources/mock_education_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/education/data/repositories/education_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/education/domain/entities/entities.dart';
import 'package:geetha_pathshala_management_web/src/features/education/domain/params/params.dart';

void main() {
  group('EducationRepositoryImpl Tests', () {
    late MockEducationDatasource mockDatasource;
    late EducationRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockEducationDatasource(processingDelay: Duration.zero);
      repository = EducationRepositoryImpl(datasource: mockDatasource);
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

    test('listEducationalGroups returns matching groups', () async {
      final response = await repository.listEducationalGroups(
        const ListGroupsParams(pathshalaId: 'pathshala-dhaka-central'),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, greaterThanOrEqualTo(1));
    });

    test('recordAttendance records session and attendance entries', () async {
      final response = await repository.recordAttendance(
        RecordAttendanceParams(
          groupId: 'group-gita-basic-01',
          sessionDate: DateTime.now(),
          takenByUserId: 'usr-teacher-madhuri',
          entries: const [
            IndividualAttendanceEntry(
              personId: 'person-subhash-roy',
              status: AttendanceStatus.present,
            ),
          ],
        ),
      );
      expect(response, isA<SuccessRepoCall>());
    });
  });
}
