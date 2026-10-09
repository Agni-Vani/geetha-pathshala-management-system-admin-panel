import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

final class ListUserAccounts implements AsyncUsecase<List<UserAccount>, NoParams> {
  final IamRepository repository;

  const ListUserAccounts({required this.repository});

  @override
  AsyncRequest<List<UserAccount>> call(NoParams params) {
    return repository.listUserAccounts();
  }
}
