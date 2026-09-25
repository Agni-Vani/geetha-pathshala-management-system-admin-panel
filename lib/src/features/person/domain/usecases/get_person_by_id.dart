import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Loads a single person registry record by ID.
final class GetPersonById implements AsyncUsecase<Person, String> {
  final PersonRepository repository;

  const GetPersonById(this.repository);

  @override
  AsyncRequest<Person> call(String params) {
    return repository.getPersonById(params);
  }
}
