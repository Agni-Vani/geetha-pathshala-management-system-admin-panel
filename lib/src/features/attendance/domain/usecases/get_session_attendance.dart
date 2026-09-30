import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

final class GetSessionAttendance
    implements AsyncUsecase<List<AttendanceRecord>, String> {
  final AttendanceRepository repository;

  const GetSessionAttendance({required this.repository});

  @override
  AsyncRequest<List<AttendanceRecord>> call(String sessionId) {
    return repository.getSessionAttendance(sessionId);
  }
}
