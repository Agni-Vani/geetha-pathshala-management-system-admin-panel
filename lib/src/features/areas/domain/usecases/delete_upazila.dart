import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Deletes or soft-deletes an administrative upazila.
final class DeleteUpazila
    implements AsyncUsecase<bool, DeleteUpazilaParams> {
  final AreasRepository repository;

  const DeleteUpazila(this.repository);

  @override
  AsyncRequest<bool> call(DeleteUpazilaParams params) {
    return repository.deleteUpazila(params);
  }
}

