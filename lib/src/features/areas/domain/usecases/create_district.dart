import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Registers a new administrative district.
final class CreateDistrict
    implements AsyncUsecase<District, CreateDistrictParams> {
  final AreasRepository repository;

  const CreateDistrict(this.repository);

  @override
  AsyncRequest<District> call(CreateDistrictParams params) {
    return repository.createDistrict(params);
  }
}
