import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

/// Domain contract for authoritative registry workflows and lookups.
abstract interface class RegistryRepository {
  /// Returns the governing organization by ID.
  AsyncRequest<Organization> getOrganization(String organizationId);

  /// Searches people before creation or assignment to reduce duplicates.
  AsyncRequest<List<Person>> searchPeople(SearchPeopleParams params);

  /// Returns a single registered person by ID.
  AsyncRequest<Person> getPersonById(String personId);

  /// Creates a new person registry record with optional contacts and relations.
  AsyncRequest<Person> createPerson(CreatePersonParams params);

  /// Returns contact methods attached to a person.
  AsyncRequest<List<PersonContact>> getPersonContacts(String personId);

  /// Returns family or guardian relationships attached to a person.
  AsyncRequest<List<PersonRelationship>> getPersonRelationships(
    String personId,
  );

  /// Lists Pathshalas visible within the caller's effective access.
  AsyncRequest<List<Pathshala>> listPathshalas(ListPathshalasParams params);

  /// Returns a single Pathshala registry record by ID.
  AsyncRequest<Pathshala> getPathshalaById(String pathshalaId);

  /// Registers a new local Pathshala record.
  AsyncRequest<Pathshala> createPathshala(CreatePathshalaParams params);

  /// Lists governance committees within organization or Pathshala scope.
  AsyncRequest<List<Committee>> listCommittees(ListCommitteesParams params);

  /// Returns a single committee by ID.
  AsyncRequest<Committee> getCommitteeById(String committeeId);

  /// Lists people serving in a committee, optionally filtered by status.
  AsyncRequest<List<CommitteeMembership>> listCommitteeMemberships(
    ListCommitteeMembershipsParams params,
  );
}
