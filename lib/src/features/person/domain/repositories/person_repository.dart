import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

abstract class PersonRepository {
  AsyncRequest<Person> getPersonById(String personId);
  AsyncRequest<List<Person>> searchPeople(SearchPeopleParams params);
  AsyncRequest<Person> createPerson(CreatePersonParams params);
  AsyncRequest<Person> updatePerson(UpdatePersonParams params);
  AsyncRequest<List<PersonContact>> getPersonContacts(String personId);
  AsyncRequest<List<PersonRelationship>> getPersonRelationships(String personId);
  AsyncRequest<List<PersonEducation>> getPersonEducations(String personId);
  AsyncRequest<PersonEducation> addPersonEducation(CreatePersonEducationParams params);
  AsyncRequest<void> deletePersonEducation(String id);
  AsyncRequest<List<PersonWorkExperience>> getPersonWorkExperiences(String personId);
  AsyncRequest<PersonWorkExperience> addPersonWorkExperience(CreatePersonWorkExperienceParams params);
  AsyncRequest<void> deletePersonWorkExperience(String id);
  AsyncRequest<void> assignPersonAsTeacher(AssignPersonAsTeacherParams params);
  AsyncRequest<void> admitPersonAsStudent(AdmitPersonAsStudentParams params);
}
