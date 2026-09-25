import '../../../../core/async_handlers/async_request.dart';
import '../../../../core/async_handlers/response.dart';
import '../../../../core/error_handler/error_handler.dart';
import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../../domain/repositories/areas_repository.dart';
import '../datasources/areas_datasource.dart';

final class AreasRepositoryImpl with ErrorHandler implements AreasRepository {
  final AreasDatasource datasource;

  const AreasRepositoryImpl(this.datasource);

  @override
  AsyncRequest<List<District>> listDistricts([ListDistrictsParams? params]) {
    return _request(() => datasource.listDistricts(params: params));
  }

  @override
  AsyncRequest<District> createDistrict(CreateDistrictParams params) {
    return _request(() => datasource.createDistrict(params));
  }

  @override
  AsyncRequest<List<Upazila>> listUpazilas([ListUpazilasParams? params]) {
    return _request(() => datasource.listUpazilas(params: params));
  }

  @override
  AsyncRequest<Upazila> createUpazila(CreateUpazilaParams params) {
    return _request(() => datasource.createUpazila(params));
  }

  AsyncRequest<T> _request<T>(Future<T> Function() request) {
    return asyncTryCatch<T>(
      tryFunc: () async {
        final data = await request();
        return SuccessRepoCall<T>(data: data);
      },
    );
  }
}
