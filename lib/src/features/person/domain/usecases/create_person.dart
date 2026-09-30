import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Creates a new root human identity in the person registry.
final class CreatePerson implements AsyncUsecase<Person, CreatePersonParams> {
  final PersonRepository repository;

  const CreatePerson(this.repository);

  @override
  AsyncRequest<Person> call(CreatePersonParams params) {
    return repository.createPerson(params);
  }
}
