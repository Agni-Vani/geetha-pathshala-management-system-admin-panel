import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Updates an existing Pathshala's registry details.
final class UpdatePathshala
    implements AsyncUsecase<Pathshala, UpdatePathshalaParams> {
  final RegistryRepository repository;

  const UpdatePathshala(this.repository);

  @override
  AsyncRequest<Pathshala> call(UpdatePathshalaParams params) {
    return repository.updatePathshala(params);
  }
}
