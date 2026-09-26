import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

abstract interface class AttendanceRepository {
  AsyncRequest<AttendanceSession> recordAttendance(
    RecordAttendanceParams params,
  );
  AsyncRequest<List<AttendanceRecord>> getSessionAttendance(String sessionId);
  AsyncRequest<AttendanceOverview> getAttendanceOverview(
    GetAttendanceOverviewParams params,
  );
}
