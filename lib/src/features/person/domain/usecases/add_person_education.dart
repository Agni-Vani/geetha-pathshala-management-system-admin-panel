import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Adds an educational qualification to a person's profile.
final class AddPersonEducation implements AsyncUsecase<PersonEducation, CreatePersonEducationParams> {
  final PersonRepository repository;

  const AddPersonEducation(this.repository);

  @override
  AsyncRequest<PersonEducation> call(CreatePersonEducationParams params) {
    return repository.addPersonEducation(params);
  }
}
