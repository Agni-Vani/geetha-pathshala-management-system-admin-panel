import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Loads the central governing organization registry record.
final class GetOrganization implements AsyncUsecase<Organization, String> {
  final PathshalaRepository repository;

  const GetOrganization(this.repository);

  @override
  AsyncRequest<Organization> call(String params) {
    return repository.getOrganization(params);
  }
}
