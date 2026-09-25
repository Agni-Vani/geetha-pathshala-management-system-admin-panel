import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Registers a new administrative upazila / thana under a district.
final class CreateUpazila
    implements AsyncUsecase<Upazila, CreateUpazilaParams> {
  final RegistryRepository repository;

  const CreateUpazila(this.repository);

  @override
  AsyncRequest<Upazila> call(CreateUpazilaParams params) {
    return repository.createUpazila(params);
  }
}
