import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Lists person memberships for a governance committee.
final class ListCommitteeMemberships
    implements
        AsyncUsecase<
          List<CommitteeMembership>,
          ListCommitteeMembershipsParams
        > {
  final RegistryRepository repository;

  const ListCommitteeMemberships(this.repository);

  @override
  AsyncRequest<List<CommitteeMembership>> call(
    ListCommitteeMembershipsParams params,
  ) {
    return repository.listCommitteeMemberships(params);
  }
}
