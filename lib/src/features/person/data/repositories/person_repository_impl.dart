import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/person_repository.dart';
import '../datasources/person_datasource.dart';

final class PersonRepositoryImpl
    with ErrorHandler
    implements PersonRepository {
  final PersonDatasource datasource;

  const PersonRepositoryImpl(this.datasource);

  @override
  AsyncRequest<Person> getPersonById(String personId) {
    return _request(() => datasource.getPersonById(personId));
  }

  @override
  AsyncRequest<List<Person>> searchPeople(SearchPeopleParams params) {
    return _request(() => datasource.searchPeople(params));
  }

  @override
  AsyncRequest<Person> createPerson(CreatePersonParams params) {
    return _request(() => datasource.createPerson(params));
  }

  @override
  AsyncRequest<Person> updatePerson(UpdatePersonParams params) {
    return _request(() => datasource.updatePerson(params));
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
  AsyncRequest<List<PersonEducation>> getPersonEducations(String personId) {
    return _request(() => datasource.getPersonEducations(personId));
  }

  @override
  AsyncRequest<PersonEducation> addPersonEducation(
    CreatePersonEducationParams params,
  ) {
    return _request(() => datasource.createPersonEducation(params));
  }

  @override
  AsyncRequest<List<PersonWorkExperience>> getPersonWorkExperiences(
    String personId,
  ) {
    return _request(() => datasource.getPersonWorkExperiences(personId));
  }

  @override
  AsyncRequest<PersonWorkExperience> addPersonWorkExperience(
    CreatePersonWorkExperienceParams params,
  ) {
    return _request(() => datasource.createPersonWorkExperience(params));
  }

  AsyncRequest<T> _request<T>(Future<T> Function() request) {
    return asyncTryCatch<T>(
      tryFunc: () async {
        final data = await request();
        return SuccessRepoCall<T>(data: data);
      },
    );
  }
}
