import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Searches the person registry before create, admission, or assignment workflows.
final class SearchPeople
    implements AsyncUsecase<List<Person>, SearchPeopleParams> {
  final RegistryRepository repository;

  const SearchPeople(this.repository);

  @override
  AsyncRequest<List<Person>> call(SearchPeopleParams params) {
    return repository.searchPeople(params);
  }
}
