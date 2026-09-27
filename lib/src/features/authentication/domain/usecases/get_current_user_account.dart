import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

final class GetCurrentUserAccount
    implements AsyncUsecase<UserAccount?, NoParams> {
  final IamRepository repository;

  const GetCurrentUserAccount({required this.repository});

  @override
  AsyncRequest<UserAccount?> call(NoParams params) {
    return repository.getCurrentUserAccount();
  }
}
