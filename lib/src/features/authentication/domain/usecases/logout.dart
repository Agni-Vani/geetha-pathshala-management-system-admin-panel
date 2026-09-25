import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../repositories/repositories.dart';

final class Logout implements AsyncUsecase<void, NoParams> {
  final IamRepository repository;

  const Logout({required this.repository});

  @override
  AsyncRequest<void> call(NoParams params) {
    return repository.logout();
  }
}
