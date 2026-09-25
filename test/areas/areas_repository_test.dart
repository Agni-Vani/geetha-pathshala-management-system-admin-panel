import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/data/datasources/mock_areas_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/data/repositories/areas_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/domain/params/params.dart';

void main() {
  group('AreasRepositoryImpl Tests', () {
    late MockAreasDatasource mockDatasource;
    late AreasRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockAreasDatasource(processingDelay: Duration.zero);
      repository = AreasRepositoryImpl(mockDatasource);
    });

    test('listDistricts returns seeded districts of Bangladesh', () async {
      final response = await repository.listDistricts();
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, greaterThanOrEqualTo(64));
    });

    test('createDistrict successfully adds a new district', () async {
      final response = await repository.createDistrict(
        const CreateDistrictParams(
          name: 'Test Zilla',
          division: 'Dhaka',
          status: 'active',
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.name, equals('Test Zilla'));
      expect(success.data.division, equals('Dhaka'));
    });

    test('listUpazilas returns upazilas for a district', () async {
      final distResponse = await repository.listDistricts(
        const ListDistrictsParams(searchQuery: 'Dhaka'),
      );
      final distSuccess = distResponse as SuccessRepoCall;
      final dhaka = distSuccess.data.first;

      final upzResponse = await repository.listUpazilas(
        ListUpazilasParams(districtId: dhaka.id),
      );
      expect(upzResponse, isA<SuccessRepoCall>());
      final upzSuccess = upzResponse as SuccessRepoCall;
      expect(upzSuccess.data.length, greaterThanOrEqualTo(1));
    });

    test('createUpazila adds a new upazila under a district', () async {
      final response = await repository.createUpazila(
        const CreateUpazilaParams(
          districtId: 'dist-dhaka',
          name: 'New Test Upazila',
          status: 'active',
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.name, equals('New Test Upazila'));
      expect(success.data.districtId, equals('dist-dhaka'));
    });
  });
}
