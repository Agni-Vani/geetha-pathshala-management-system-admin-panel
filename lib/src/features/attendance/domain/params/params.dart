import '../entities/attendance_enums.dart';

final class IndividualAttendanceEntry {
  final String personId;
  final AttendanceStatus status;
  final String? remarks;

  const IndividualAttendanceEntry({
    required this.personId,
    required this.status,
    this.remarks,
  });
}

final class RecordAttendanceParams {
  final String groupId;
  final DateTime sessionDate;
  final String takenByUserId;
  final List<IndividualAttendanceEntry> entries;

  const RecordAttendanceParams({
    required this.groupId,
    required this.sessionDate,
    required this.takenByUserId,
    required this.entries,
  });
}
