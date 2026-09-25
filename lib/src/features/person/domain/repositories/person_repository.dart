import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

abstract class PersonRepository {
  AsyncRequest<Person> getPersonById(String personId);
  AsyncRequest<List<Person>> searchPeople(SearchPeopleParams params);
  AsyncRequest<Person> createPerson(CreatePersonParams params);
  AsyncRequest<List<PersonContact>> getPersonContacts(String personId);
  AsyncRequest<List<PersonRelationship>> getPersonRelationships(String personId);
}
