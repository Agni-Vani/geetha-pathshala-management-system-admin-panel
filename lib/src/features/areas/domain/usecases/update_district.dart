import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Updates an administrative district's details.
final class UpdateDistrict
    implements AsyncUsecase<District, UpdateDistrictParams> {
  final AreasRepository repository;

  const UpdateDistrict(this.repository);

  @override
  AsyncRequest<District> call(UpdateDistrictParams params) {
    return repository.updateDistrict(params);
  }
}
