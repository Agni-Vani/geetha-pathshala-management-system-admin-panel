import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class LoginWithEmail implements AsyncUsecase<UserAccount, LoginParams> {
  final IamRepository repository;

  const LoginWithEmail(this.repository);

  @override
  AsyncRequest<UserAccount> call(LoginParams params) {
    return repository.loginWithEmail(params);
  }
}
