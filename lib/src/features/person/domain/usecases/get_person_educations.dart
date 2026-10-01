import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Loads educational qualifications for a registered person.
final class GetPersonEducations
    implements AsyncUsecase<List<PersonEducation>, String> {
  final PersonRepository repository;

  const GetPersonEducations(this.repository);

  @override
  AsyncRequest<List<PersonEducation>> call(String params) {
    return repository.getPersonEducations(params);
  }
}
