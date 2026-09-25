import 'attendance_enums.dart';

abstract class AttendanceSession {
  const AttendanceSession();

  String get id;
  String get groupId;
  DateTime get sessionDate;
  String get takenByUserId;
  SessionStatus get status;
  DateTime get createdAt;
}
