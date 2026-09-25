import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../entities/entities.dart';
import '../params/params.dart';
import '../repositories/repositories.dart';

/// Lists administrative districts.
final class ListDistricts
    implements AsyncUsecase<List<District>, ListDistrictsParams?> {
  final AreasRepository repository;

  const ListDistricts(this.repository);

  @override
  AsyncRequest<List<District>> call([ListDistrictsParams? params]) {
    return repository.listDistricts(params);
  }
}
