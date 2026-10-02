import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class UpdateEvent
    implements AsyncUsecase<Event, UpdateEventParams> {
  final EventsRepository repository;

  const UpdateEvent({required this.repository});

  @override
  AsyncRequest<Event> call(UpdateEventParams params) {
    return repository.updateEvent(params);
  }
}
