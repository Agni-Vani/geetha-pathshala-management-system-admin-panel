import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

abstract class AreasRepository {
  AsyncRequest<List<Division>> listDivisions([ListDivisionsParams? params]);
  AsyncRequest<Division> createDivision(CreateDivisionParams params);
  AsyncRequest<List<District>> listDistricts([ListDistrictsParams? params]);
  AsyncRequest<District> createDistrict(CreateDistrictParams params);
  AsyncRequest<District> updateDistrict(UpdateDistrictParams params);
  AsyncRequest<bool> deleteDistrict(DeleteDistrictParams params);
  AsyncRequest<List<Upazila>> listUpazilas([ListUpazilasParams? params]);
  AsyncRequest<Upazila> createUpazila(CreateUpazilaParams params);
  AsyncRequest<Upazila> updateUpazila(UpdateUpazilaParams params);
  AsyncRequest<bool> deleteUpazila(DeleteUpazilaParams params);
}

