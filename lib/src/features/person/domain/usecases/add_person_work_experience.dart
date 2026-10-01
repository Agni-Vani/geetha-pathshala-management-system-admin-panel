import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Adds a work or volunteer experience to a person's profile.
final class AddPersonWorkExperience
    implements
        AsyncUsecase<PersonWorkExperience, CreatePersonWorkExperienceParams> {
  final PersonRepository repository;

  const AddPersonWorkExperience(this.repository);

  @override
  AsyncRequest<PersonWorkExperience> call(
    CreatePersonWorkExperienceParams params,
  ) {
    return repository.addPersonWorkExperience(params);
  }
}
