import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class GetNotices implements AsyncUsecase<List<Notice>, GetNoticesParams> {
  final CommunicationRepository repository;

  const GetNotices({required this.repository});

  @override
  AsyncRequest<List<Notice>> call(GetNoticesParams params) {
    return repository.getNotices(params);
  }
}
