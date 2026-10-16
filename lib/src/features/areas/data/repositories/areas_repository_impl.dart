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
  AsyncRequest<List<Division>> listDivisions([ListDivisionsParams? params]) {
    return _request(() => datasource.listDivisions(params: params));
  }

  @override
  AsyncRequest<Division> createDivision(CreateDivisionParams params) {
    return _request(() => datasource.createDivision(params));
  }

  @override
  AsyncRequest<List<District>> listDistricts([ListDistrictsParams? params]) {
    return _request(() => datasource.listDistricts(params: params));
  }

  @override
  AsyncRequest<District> createDistrict(CreateDistrictParams params) {
    return _request(() => datasource.createDistrict(params));
  }

  @override
  AsyncRequest<District> updateDistrict(UpdateDistrictParams params) {
    return _request(() => datasource.updateDistrict(params));
  }

  @override
  AsyncRequest<bool> deleteDistrict(DeleteDistrictParams params) {
    return _request(() async {
      await datasource.deleteDistrict(params);
      return true;
    });
  }

  @override
  AsyncRequest<List<Upazila>> listUpazilas([ListUpazilasParams? params]) {
    return _request(() => datasource.listUpazilas(params: params));
  }

  @override
  AsyncRequest<Upazila> createUpazila(CreateUpazilaParams params) {
    return _request(() => datasource.createUpazila(params));
  }

  @override
  AsyncRequest<Upazila> updateUpazila(UpdateUpazilaParams params) {
    return _request(() => datasource.updateUpazila(params));
  }

  @override
  AsyncRequest<bool> deleteUpazila(DeleteUpazilaParams params) {
    return _request(() async {
      await datasource.deleteUpazila(params);
      return true;
    });
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
