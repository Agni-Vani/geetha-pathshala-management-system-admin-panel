import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

final class ListPermissions implements AsyncUsecase<List<Permission>, NoParams> {
  final IamRepository repository;

  const ListPermissions({required this.repository});

  @override
  AsyncRequest<List<Permission>> call(NoParams params) {
    return repository.listPermissions();
  }
}
