import '../../domain/params/params.dart';
import '../models/models.dart';

abstract class EventsDatasource {
  Future<List<EventModel>> listEvents(ListEventsParams params);
}
