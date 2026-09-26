import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/attendance/data/datasources/mock_attendance_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/attendance/domain/entities/entities.dart';
import 'package:geetha_pathshala_management_web/src/features/attendance/domain/params/params.dart';

void main() {
  group('AttendanceRepositoryImpl Tests', () {
    late MockAttendanceDatasource mockDatasource;
    late AttendanceRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockAttendanceDatasource(processingDelay: Duration.zero);
      repository = AttendanceRepositoryImpl(datasource: mockDatasource);
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
      final success = response as SuccessRepoCall;
      expect(success.data.groupId, equals('group-gita-basic-01'));

      final recordsResponse = await repository.getSessionAttendance(success.data.id);
      expect(recordsResponse, isA<SuccessRepoCall>());
      final recordsSuccess = recordsResponse as SuccessRepoCall;
      expect(recordsSuccess.data.length, equals(1));
    });

    test('getAttendanceOverview returns seeded summary and rows', () async {
      final response = await repository.getAttendanceOverview(
        const GetAttendanceOverviewParams(),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.summaryStats.length, equals(4));
      expect(success.data.attendanceRows.length, equals(5));
      expect(success.data.attendanceRows.first.name, equals('অনন্যা শর্মা'));
    });
  });
}
