import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'attendance_datasource.dart';

final class MockAttendanceDatasource implements AttendanceDatasource {
  final Duration processingDelay;
  final List<AttendanceSessionModel> _sessions;
  final List<AttendanceRecordModel> _records;
  final AttendanceOverviewModel _overview;

  MockAttendanceDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _sessions = [],
       _records = [],
       _overview = _seedOverview();

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

  @override
  Future<AttendanceOverviewModel> getAttendanceOverview(
    GetAttendanceOverviewParams params,
  ) async {
    await _simulateProcessing();
    if (params.pathshalaId == null || params.pathshalaId == 'All Pathshalas') {
      return _overview;
    }
    final filteredRows = _overview.attendanceRows
        .where((r) => r.pathshala == params.pathshalaId)
        .toList();
    return AttendanceOverviewModel(
      summaryStats: _overview.summaryStats,
      attendanceRows: filteredRows,
    );
  }

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }

  static AttendanceOverviewModel _seedOverview() {
    return const AttendanceOverviewModel(
      summaryStats: [
        AttendanceSummaryStatModel(
          iconName: 'groups_outlined',
          value: '৮৫',
          label: 'Total Students',
          tintValue: 0xFF1565C0,
        ),
        AttendanceSummaryStatModel(
          iconName: 'check_circle_outline',
          value: '৭৮',
          label: 'Present',
          tintValue: 0xFF1E7B34,
        ),
        AttendanceSummaryStatModel(
          iconName: 'cancel_outlined',
          value: '৭',
          label: 'Absent',
          tintValue: 0xFFBA1A1A,
        ),
        AttendanceSummaryStatModel(
          iconName: 'pie_chart_outline',
          value: '৯২%',
          label: 'Attendance %',
          tintValue: 0xFFAD6800,
        ),
      ],
      attendanceRows: [
        AttendanceRowItemModel(
          id: 'att-001',
          name: 'অনন্যা শর্মা',
          studentClass: 'শ্রেণি ৫',
          pathshala: 'Chattogram North Gita Pathshala',
          isPresent: true,
        ),
        AttendanceRowItemModel(
          id: 'att-002',
          name: 'বিবান পাটেল',
          studentClass: 'শ্রেণি ৬',
          pathshala: 'Dhaka Central Gita Pathshala',
          isPresent: true,
        ),
        AttendanceRowItemModel(
          id: 'att-003',
          name: 'ইশিকা ভার্মা',
          studentClass: 'শ্রেণি ৪',
          pathshala: 'Sylhet East Gita Pathshala',
          isPresent: false,
        ),
        AttendanceRowItemModel(
          id: 'att-004',
          name: 'কৃষ্ণ তিওয়ারি',
          studentClass: 'শ্রেণি ৭',
          pathshala: 'Chattogram North Gita Pathshala',
          isPresent: true,
        ),
        AttendanceRowItemModel(
          id: 'att-005',
          name: 'মায়রা জোশী',
          studentClass: 'শ্রেণি ৩',
          pathshala: 'Dhaka Central Gita Pathshala',
          isPresent: true,
        ),
      ],
    );
  }
}
