import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

/// Contract defining pathshala, organization, and committee registry data operations.
abstract interface class PathshalaRepository {
  AsyncRequest<Pathshala> createPathshala(CreatePathshalaParams params);
  AsyncRequest<Pathshala> getPathshalaById(String id);
  AsyncRequest<List<Pathshala>> listPathshalas(ListPathshalasParams params);
  AsyncRequest<Pathshala> updatePathshala(UpdatePathshalaParams params);

  AsyncRequest<Organization> getOrganization(String id);

  AsyncRequest<Committee> getCommitteeById(String id);
  AsyncRequest<List<Committee>> listCommittees(ListCommitteesParams params);
  AsyncRequest<List<CommitteeMembership>> listCommitteeMemberships(
    ListCommitteeMembershipsParams params,
  );
}
