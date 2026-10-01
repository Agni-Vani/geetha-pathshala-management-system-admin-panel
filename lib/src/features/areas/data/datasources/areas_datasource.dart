import '../../domain/params/params.dart';
import '../models/models.dart';

abstract class AreasDatasource {
  Future<List<DivisionModel>> listDivisions({ListDivisionsParams? params});
  Future<DivisionModel> createDivision(CreateDivisionParams params);
  Future<List<DistrictModel>> listDistricts({ListDistrictsParams? params});
  Future<DistrictModel> createDistrict(CreateDistrictParams params);
  Future<List<UpazilaModel>> listUpazilas({ListUpazilasParams? params});
  Future<UpazilaModel> createUpazila(CreateUpazilaParams params);
}
