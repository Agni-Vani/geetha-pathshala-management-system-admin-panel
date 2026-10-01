import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Loads work and volunteer experiences for a registered person.
final class GetPersonWorkExperiences
    implements AsyncUsecase<List<PersonWorkExperience>, String> {
  final PersonRepository repository;

  const GetPersonWorkExperiences(this.repository);

  @override
  AsyncRequest<List<PersonWorkExperience>> call(String params) {
    return repository.getPersonWorkExperiences(params);
  }
}
