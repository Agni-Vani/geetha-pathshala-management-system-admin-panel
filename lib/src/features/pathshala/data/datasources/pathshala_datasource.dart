import '../../domain/params/params.dart';
import '../models/models.dart';

/// Data-source contract for pathshala, organization, and committee persistence.
abstract interface class PathshalaDatasource {
  /// Returns the governing organization by ID.
  Future<OrganizationModel> getOrganization(String organizationId);

  /// Lists Pathshalas using optional filters.
  Future<List<PathshalaModel>> listPathshalas(ListPathshalasParams params);

  /// Returns a Pathshala model by ID.
  Future<PathshalaModel> getPathshalaById(String pathshalaId);

  /// Creates a new Pathshala model in backing source.
  Future<PathshalaModel> createPathshala(CreatePathshalaParams params);

  /// Updates an existing Pathshala model in backing source.
  Future<PathshalaModel> updatePathshala(UpdatePathshalaParams params);

  /// Lists governance committees using optional filters.
  Future<List<CommitteeModel>> listCommittees(ListCommitteesParams params);

  /// Returns a committee model by ID.
  Future<CommitteeModel> getCommitteeById(String committeeId);

  /// Lists committee memberships using optional filters.
  Future<List<CommitteeMembershipModel>> listCommitteeMemberships(
    ListCommitteeMembershipsParams params,
  );
}
