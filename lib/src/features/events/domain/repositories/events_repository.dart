import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

abstract interface class EventsRepository {
  AsyncRequest<List<Event>> listEvents(ListEventsParams params);
}
