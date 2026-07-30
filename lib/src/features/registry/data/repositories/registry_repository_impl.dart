import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/datasources.dart';

/// Registry repository backed by a data source implementation.
final class RegistryRepositoryImpl implements RegistryRepository {
  final RegistryDatasource datasource;

  const RegistryRepositoryImpl({required this.datasource});

  @override
  AsyncRequest<Organization> getOrganization(String organizationId) {
    return _guard(() => datasource.getOrganization(organizationId));
  }

  @override
  AsyncRequest<List<Person>> searchPeople(SearchPeopleParams params) {
    return _guard(() => datasource.searchPeople(params));
  }

  @override
  AsyncRequest<Person> getPersonById(String personId) {
    return _guard(() => datasource.getPersonById(personId));
  }

  @override
  AsyncRequest<Person> createPerson(CreatePersonParams params) {
    return _guard(() => datasource.createPerson(params));
  }

  @override
  AsyncRequest<List<PersonContact>> getPersonContacts(String personId) {
    return _guard(() => datasource.getPersonContacts(personId));
  }

  @override
  AsyncRequest<List<PersonRelationship>> getPersonRelationships(
    String personId,
  ) {
    return _guard(() => datasource.getPersonRelationships(personId));
  }

  @override
  AsyncRequest<List<Pathshala>> listPathshalas(ListPathshalasParams params) {
    return _guard(() => datasource.listPathshalas(params));
  }

  @override
  AsyncRequest<Pathshala> getPathshalaById(String pathshalaId) {
    return _guard(() => datasource.getPathshalaById(pathshalaId));
  }

  @override
  AsyncRequest<List<Committee>> listCommittees(ListCommitteesParams params) {
    return _guard(() => datasource.listCommittees(params));
  }

  @override
  AsyncRequest<Committee> getCommitteeById(String committeeId) {
    return _guard(() => datasource.getCommitteeById(committeeId));
  }

  @override
  AsyncRequest<List<CommitteeMembership>> listCommitteeMemberships(
    ListCommitteeMembershipsParams params,
  ) {
    return _guard(() => datasource.listCommitteeMemberships(params));
  }

  Future<RepoResponse<T>> _guard<T>(Future<T> Function() request) async {
    try {
      final data = await request();
      return SuccessRepoCall<T>(data: data);
    } catch (error, stackTrace) {
      final exception = error is Exception
          ? error
          : Exception(error.toString());
      return FailedRepoCall<T>(
        message: exception.toString(),
        exception: exception,
        stackTrace: stackTrace,
      );
    }
  }
}
