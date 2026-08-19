import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

/// Registry repository backed by a data source implementation.
final class RegistryRepositoryImpl
    with ErrorHandler
    implements RegistryRepository {
  final RegistryDatasource datasource;

  const RegistryRepositoryImpl({required this.datasource});

  @override
  AsyncRequest<Organization> getOrganization(String organizationId) {
    return _request(() => datasource.getOrganization(organizationId));
  }

  @override
  AsyncRequest<List<Person>> searchPeople(SearchPeopleParams params) {
    return _request(() => datasource.searchPeople(params));
  }

  @override
  AsyncRequest<Person> getPersonById(String personId) {
    return _request(() => datasource.getPersonById(personId));
  }

  @override
  AsyncRequest<Person> createPerson(CreatePersonParams params) {
    return _request(() => datasource.createPerson(params));
  }

  @override
  AsyncRequest<List<PersonContact>> getPersonContacts(String personId) {
    return _request(() => datasource.getPersonContacts(personId));
  }

  @override
  AsyncRequest<List<PersonRelationship>> getPersonRelationships(
    String personId,
  ) {
    return _request(() => datasource.getPersonRelationships(personId));
  }

  @override
  AsyncRequest<List<Pathshala>> listPathshalas(ListPathshalasParams params) {
    return _request(() => datasource.listPathshalas(params));
  }

  @override
  AsyncRequest<Pathshala> getPathshalaById(String pathshalaId) {
    return _request(() => datasource.getPathshalaById(pathshalaId));
  }

  @override
  AsyncRequest<Pathshala> createPathshala(CreatePathshalaParams params) {
    return _request(() => datasource.createPathshala(params));
  }

  @override
  AsyncRequest<Pathshala> updatePathshala(UpdatePathshalaParams params) {
    return _request(() => datasource.updatePathshala(params));
  }

  @override
  AsyncRequest<List<Committee>> listCommittees(ListCommitteesParams params) {
    return _request(() => datasource.listCommittees(params));
  }

  @override
  AsyncRequest<Committee> getCommitteeById(String committeeId) {
    return _request(() => datasource.getCommitteeById(committeeId));
  }

  @override
  AsyncRequest<List<CommitteeMembership>> listCommitteeMemberships(
    ListCommitteeMembershipsParams params,
  ) {
    return _request(() => datasource.listCommitteeMemberships(params));
  }

  /// Runs datasource work through the shared repository error boundary.
  AsyncRequest<T> _request<T>(Future<T> Function() request) {
    return asyncTryCatch<T>(
      tryFunc: () async {
        final data = await request();
        return SuccessRepoCall<T>(data: data);
      },
    );
  }
}
