import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Registers a new Pathshala in the central registry.
final class CreatePathshala
    implements AsyncUsecase<Pathshala, CreatePathshalaParams> {
  final PathshalaRepository repository;

  const CreatePathshala(this.repository);

  @override
  AsyncRequest<Pathshala> call(CreatePathshalaParams params) {
    return repository.createPathshala(params);
  }
}
