import 'attendance_enums.dart';

abstract class AttendanceRecord {
  const AttendanceRecord();

  String get id;
  String get sessionId;
  String get personId;
  AttendanceStatus get status;
  String? get remarks;
}
