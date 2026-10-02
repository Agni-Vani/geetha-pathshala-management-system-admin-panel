import '../../domain/params/params.dart';
import '../models/models.dart';

abstract class EventsDatasource {
  Future<List<EventModel>> listEvents(ListEventsParams params);
  Future<EventModel> createEvent(CreateEventParams params);
  Future<EventModel> updateEvent(UpdateEventParams params);
  Future<bool> deleteEvent(DeleteEventParams params);
}
