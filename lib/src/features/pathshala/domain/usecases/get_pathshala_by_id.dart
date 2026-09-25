import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Loads a single Pathshala registry record by ID.
final class GetPathshalaById implements AsyncUsecase<Pathshala, String> {
  final PathshalaRepository repository;

  const GetPathshalaById(this.repository);

  @override
  AsyncRequest<Pathshala> call(String params) {
    return repository.getPathshalaById(params);
  }
}
