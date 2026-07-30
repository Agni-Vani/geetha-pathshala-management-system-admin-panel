import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Loads a single governance committee by ID.
final class GetCommitteeById implements AsyncUsecase<Committee, String> {
  final RegistryRepository repository;

  const GetCommitteeById(this.repository);

  @override
  AsyncRequest<Committee> call(String params) {
    return repository.getCommitteeById(params);
  }
}
