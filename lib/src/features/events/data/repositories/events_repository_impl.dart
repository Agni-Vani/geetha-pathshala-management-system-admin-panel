import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/datasources.dart';

final class EventsRepositoryImpl with ErrorHandler implements EventsRepository {
  final EventsDatasource datasource;

  const EventsRepositoryImpl({required this.datasource});

  @override
  AsyncRequest<List<Event>> listEvents(ListEventsParams params) {
    return _request(() => datasource.listEvents(params));
  }

  AsyncRequest<T> _request<T>(Future<T> Function() request) {
    return asyncTryCatch<T>(
      tryFunc: () async {
        final data = await request();
        return SuccessRepoCall<T>(data: data);
      },
    );
  }
}
