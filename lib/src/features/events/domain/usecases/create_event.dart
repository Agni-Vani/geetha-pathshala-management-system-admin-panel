import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class CreateEvent
    implements AsyncUsecase<Event, CreateEventParams> {
  final EventsRepository repository;

  const CreateEvent({required this.repository});

  @override
  AsyncRequest<Event> call(CreateEventParams params) {
    return repository.createEvent(params);
  }
}
