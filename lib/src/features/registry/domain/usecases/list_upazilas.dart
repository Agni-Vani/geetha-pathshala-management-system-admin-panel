import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Lists administrative upazilas / thanas.
final class ListUpazilas
    implements AsyncUsecase<List<Upazila>, ListUpazilasParams?> {
  final RegistryRepository repository;

  const ListUpazilas(this.repository);

  @override
  AsyncRequest<List<Upazila>> call([ListUpazilasParams? params]) {
    return repository.listUpazilas(params);
  }
}
