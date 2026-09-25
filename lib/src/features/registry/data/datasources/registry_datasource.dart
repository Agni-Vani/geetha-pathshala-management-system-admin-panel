import '../../domain/params/params.dart';
import '../models/models.dart';

/// Data-source contract for registry persistence and backend access.
abstract interface class RegistryDatasource {
  /// Returns the governing organization by ID.
  Future<OrganizationModel> getOrganization(String organizationId);

  /// Searches people using duplicate-prevention criteria.
  Future<List<PersonModel>> searchPeople(SearchPeopleParams params);

  /// Returns a person model by ID.
  Future<PersonModel> getPersonById(String personId);

  /// Creates a person model in the backing source.
  Future<PersonModel> createPerson(CreatePersonParams params);

  /// Returns contacts attached to a person.
  Future<List<PersonContactModel>> getPersonContacts(String personId);

  /// Returns relationships attached to a person.
  Future<List<PersonRelationshipModel>> getPersonRelationships(String personId);

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

  /// Lists administrative districts.
  Future<List<DistrictModel>> listDistricts([ListDistrictsParams? params]);

  /// Creates a new district model.
  Future<DistrictModel> createDistrict(CreateDistrictParams params);

  /// Lists administrative upazilas.
  Future<List<UpazilaModel>> listUpazilas([ListUpazilasParams? params]);

  /// Creates a new upazila model under a district.
  Future<UpazilaModel> createUpazila(CreateUpazilaParams params);
}
