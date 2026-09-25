import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class CheckPermission
    implements AsyncUsecase<bool, CheckPermissionParams> {
  final IamRepository repository;

  const CheckPermission({required this.repository});

  @override
  AsyncRequest<bool> call(CheckPermissionParams params) {
    return repository.checkPermission(params);
  }
}
