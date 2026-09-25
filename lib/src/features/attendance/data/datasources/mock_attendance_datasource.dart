import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'attendance_datasource.dart';

final class MockAttendanceDatasource implements AttendanceDatasource {
  final Duration processingDelay;
  final List<AttendanceSessionModel> _sessions;
  final List<AttendanceRecordModel> _records;

  MockAttendanceDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _sessions = [],
       _records = [];

  @override
  Future<AttendanceSessionModel> recordAttendance(
    RecordAttendanceParams params,
  ) async {
    await _simulateProcessing();
    final sessionId = 'att-sess-${DateTime.now().millisecondsSinceEpoch}';
    final session = AttendanceSessionModel(
      id: sessionId,
      groupId: params.groupId,
      sessionDate: params.sessionDate,
      takenByUserId: params.takenByUserId,
      status: SessionStatus.submitted,
      createdAt: DateTime.now(),
    );
    _sessions.add(session);

    for (final entry in params.entries) {
      _records.add(
        AttendanceRecordModel(
          id:
              'att-rec-${DateTime.now().millisecondsSinceEpoch}-${entry.personId}',
          sessionId: sessionId,
          personId: entry.personId,
          status: entry.status,
          remarks: entry.remarks,
        ),
      );
    }
    return session;
  }

  @override
  Future<List<AttendanceRecordModel>> getSessionAttendance(
    String sessionId,
  ) async {
    await _simulateProcessing();
    return _records.where((r) => r.sessionId == sessionId).toList();
  }

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }
}
