import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../repositories/repositories.dart';

/// Deletes a work/volunteer experience record from a person's profile.
final class DeletePersonWorkExperience implements AsyncUsecase<void, String> {
  final PersonRepository repository;

  const DeletePersonWorkExperience(this.repository);

  @override
  AsyncRequest<void> call(String id) {
    return repository.deletePersonWorkExperience(id);
  }
}
