import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Updates an existing person's details in the person registry.
final class UpdatePerson implements AsyncUsecase<Person, UpdatePersonParams> {
  final PersonRepository repository;

  const UpdatePerson(this.repository);

  @override
  AsyncRequest<Person> call(UpdatePersonParams params) {
    return repository.updatePerson(params);
  }
}
