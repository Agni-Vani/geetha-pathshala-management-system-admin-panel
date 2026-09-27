import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class ListEvents
    implements AsyncUsecase<List<Event>, ListEventsParams> {
  final EventsRepository repository;

  const ListEvents({required this.repository});

  @override
  AsyncRequest<List<Event>> call(ListEventsParams params) {
    return repository.listEvents(params);
  }
}
