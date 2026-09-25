import '../../domain/params/params.dart';
import '../models/models.dart';

abstract class AttendanceDatasource {
  Future<AttendanceSessionModel> recordAttendance(
    RecordAttendanceParams params,
  );
  Future<List<AttendanceRecordModel>> getSessionAttendance(String sessionId);
}
