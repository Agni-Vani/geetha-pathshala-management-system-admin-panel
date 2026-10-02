import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class DeleteEvent
    implements AsyncUsecase<bool, DeleteEventParams> {
  final EventsRepository repository;

  const DeleteEvent({required this.repository});

  @override
  AsyncRequest<bool> call(DeleteEventParams params) {
    return repository.deleteEvent(params);
  }
}
