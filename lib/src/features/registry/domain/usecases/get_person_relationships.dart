import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Loads family or guardian relationships attached to a person.
final class GetPersonRelationships
    implements AsyncUsecase<List<PersonRelationship>, String> {
  final RegistryRepository repository;

  const GetPersonRelationships(this.repository);

  @override
  AsyncRequest<List<PersonRelationship>> call(String params) {
    return repository.getPersonRelationships(params);
  }
}
