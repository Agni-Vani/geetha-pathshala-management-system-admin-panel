import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

final class ListUserRoles implements AsyncUsecase<List<UserRole>, String> {
  final IamRepository repository;

  const ListUserRoles({required this.repository});

  @override
  AsyncRequest<List<UserRole>> call(String params) {
    return repository.listUserRoles(params);
  }
}
