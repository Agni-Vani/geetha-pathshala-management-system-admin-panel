import '../../domain/params/params.dart';
import '../models/models.dart';

abstract class PersonDatasource {
  Future<PersonModel> getPersonById(String personId);
  Future<List<PersonModel>> searchPeople(SearchPeopleParams params);
  Future<PersonModel> createPerson(CreatePersonParams params);
  Future<List<PersonContactModel>> getPersonContacts(String personId);
  Future<List<PersonRelationshipModel>> getPersonRelationships(String personId);
}
