import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class ListClassSchedules
    implements AsyncUsecase<List<ClassSchedule>, ListClassSchedulesParams> {
  final ClassesRepository repository;

  const ListClassSchedules({required this.repository});

  @override
  AsyncRequest<List<ClassSchedule>> call(ListClassSchedulesParams params) {
    return repository.listClassSchedules(params);
  }
}
