import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../repositories/repositories.dart';

/// Deletes an educational qualification from a person's profile.
final class DeletePersonEducation implements AsyncUsecase<void, String> {
  final PersonRepository repository;

  const DeletePersonEducation(this.repository);

  @override
  AsyncRequest<void> call(String id) {
    return repository.deletePersonEducation(id);
  }
}
