import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Updates an administrative upazila's details.
final class UpdateUpazila
    implements AsyncUsecase<Upazila, UpdateUpazilaParams> {
  final AreasRepository repository;

  const UpdateUpazila(this.repository);

  @override
  AsyncRequest<Upazila> call(UpdateUpazilaParams params) {
    return repository.updateUpazila(params);
  }
}
