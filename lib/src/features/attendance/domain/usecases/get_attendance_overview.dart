import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class GetAttendanceOverview
    implements AsyncUsecase<AttendanceOverview, GetAttendanceOverviewParams> {
  final AttendanceRepository repository;

  const GetAttendanceOverview({required this.repository});

  @override
  AsyncRequest<AttendanceOverview> call(GetAttendanceOverviewParams params) {
    return repository.getAttendanceOverview(params);
  }
}
