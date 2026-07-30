import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Lists governance committees for an organization or Pathshala.
final class ListCommittees
    implements AsyncUsecase<List<Committee>, ListCommitteesParams> {
  final RegistryRepository repository;

  const ListCommittees(this.repository);

  @override
  AsyncRequest<List<Committee>> call(ListCommitteesParams params) {
    return repository.listCommittees(params);
  }
}
