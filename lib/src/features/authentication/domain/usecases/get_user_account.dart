import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

final class GetUserAccount implements AsyncUsecase<UserAccount, String> {
  final IamRepository repository;

  const GetUserAccount({required this.repository});

  @override
  AsyncRequest<UserAccount> call(String params) {
    return repository.getUserAccount(params);
  }
}
