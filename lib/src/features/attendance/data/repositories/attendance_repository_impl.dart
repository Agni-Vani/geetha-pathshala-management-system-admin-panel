import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/datasources.dart';

final class AttendanceRepositoryImpl
    with ErrorHandler
    implements AttendanceRepository {
  final AttendanceDatasource datasource;

  const AttendanceRepositoryImpl({required this.datasource});

  @override
  AsyncRequest<AttendanceSession> recordAttendance(
    RecordAttendanceParams params,
  ) {
    return _request(() => datasource.recordAttendance(params));
  }

  @override
  AsyncRequest<List<AttendanceRecord>> getSessionAttendance(String sessionId) {
    return _request(() => datasource.getSessionAttendance(sessionId));
  }

  AsyncRequest<T> _request<T>(Future<T> Function() request) {
    return asyncTryCatch<T>(
      tryFunc: () async {
        final data = await request();
        return SuccessRepoCall<T>(data: data);
      },
    );
  }
}
