import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Loads contact methods attached to a person.
final class GetPersonContacts
    implements AsyncUsecase<List<PersonContact>, String> {
  final RegistryRepository repository;

  const GetPersonContacts(this.repository);

  @override
  AsyncRequest<List<PersonContact>> call(String params) {
    return repository.getPersonContacts(params);
  }
}
