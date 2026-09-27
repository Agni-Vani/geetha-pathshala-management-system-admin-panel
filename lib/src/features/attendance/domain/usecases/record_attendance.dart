import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class RecordAttendance
    implements AsyncUsecase<AttendanceSession, RecordAttendanceParams> {
  final AttendanceRepository repository;

  const RecordAttendance({required this.repository});

  @override
  AsyncRequest<AttendanceSession> call(RecordAttendanceParams params) {
    return repository.recordAttendance(params);
  }
}
