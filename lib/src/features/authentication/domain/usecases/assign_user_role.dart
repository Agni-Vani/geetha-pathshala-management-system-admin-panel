import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

final class AssignUserRole
    implements AsyncUsecase<UserRole, AssignUserRoleParams> {
  final IamRepository repository;

  const AssignUserRole({required this.repository});

  @override
  AsyncRequest<UserRole> call(AssignUserRoleParams params) {
    return repository.assignUserRole(params);
  }
}
