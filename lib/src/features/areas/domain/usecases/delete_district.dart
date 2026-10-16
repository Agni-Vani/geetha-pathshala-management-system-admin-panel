import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Deletes or soft-deletes an administrative district.
final class DeleteDistrict
    implements AsyncUsecase<bool, DeleteDistrictParams> {
  final AreasRepository repository;

  const DeleteDistrict(this.repository);

  @override
  AsyncRequest<bool> call(DeleteDistrictParams params) {
    return repository.deleteDistrict(params);
  }
}

