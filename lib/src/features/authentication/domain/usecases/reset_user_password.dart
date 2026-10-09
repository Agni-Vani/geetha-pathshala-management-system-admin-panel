import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class ResetUserPassword
    implements AsyncUsecase<void, ResetUserPasswordParams> {
  final IamRepository repository;

  const ResetUserPassword({required this.repository});

  @override
  AsyncRequest<void> call(ResetUserPasswordParams params) {
    return repository.resetUserPassword(params);
  }
}
