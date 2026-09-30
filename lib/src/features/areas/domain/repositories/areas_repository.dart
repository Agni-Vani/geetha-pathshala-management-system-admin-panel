import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

abstract class AreasRepository {
  AsyncRequest<List<District>> listDistricts([ListDistrictsParams? params]);
  AsyncRequest<District> createDistrict(CreateDistrictParams params);
  AsyncRequest<List<Upazila>> listUpazilas([ListUpazilasParams? params]);
  AsyncRequest<Upazila> createUpazila(CreateUpazilaParams params);
}
