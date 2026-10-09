import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

final class ListRoles implements AsyncUsecase<List<Role>, NoParams> {
  final IamRepository repository;

  const ListRoles({required this.repository});

  @override
  AsyncRequest<List<Role>> call(NoParams params) {
    return repository.listRoles();
  }
}
