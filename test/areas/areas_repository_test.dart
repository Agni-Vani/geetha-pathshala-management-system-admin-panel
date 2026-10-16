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

    test('updateDistrict edits an existing district name and division', () async {
      final created = await repository.createDistrict(
        const CreateDistrictParams(
          name: 'Mistake Zilla',
          division: 'Dhaka',
        ),
      );
      final createdDistrict = (created as SuccessRepoCall).data;

      final updated = await repository.updateDistrict(
        UpdateDistrictParams(
          districtId: createdDistrict.id,
          name: 'Corrected Zilla',
          division: 'Chattogram',
        ),
      );
      expect(updated, isA<SuccessRepoCall>());
      final success = updated as SuccessRepoCall;
      expect(success.data.name, equals('Corrected Zilla'));
      expect(success.data.division, equals('Chattogram'));
    });

    test('deleteDistrict removes the district', () async {
      final created = await repository.createDistrict(
        const CreateDistrictParams(
          name: 'To Delete Zilla',
          division: 'Dhaka',
        ),
      );
      final createdDistrict = (created as SuccessRepoCall).data;

      final deleted = await repository.deleteDistrict(
        DeleteDistrictParams(districtId: createdDistrict.id),
      );
      expect(deleted, isA<SuccessRepoCall>());
      expect((deleted as SuccessRepoCall).data, isTrue);

      final list = await repository.listDistricts();
      final districts = (list as SuccessRepoCall).data;
      expect(districts.any((d) => d.id == createdDistrict.id), isFalse);
    });

    test('updateUpazila edits an existing upazila name', () async {
      final created = await repository.createUpazila(
        const CreateUpazilaParams(
          districtId: 'dist-dhaka',
          name: 'Wrong Spelled Upazila',
        ),
      );
      final createdUpz = (created as SuccessRepoCall).data;

      final updated = await repository.updateUpazila(
        UpdateUpazilaParams(
          upazilaId: createdUpz.id,
          name: 'Corrected Upazila',
        ),
      );
      expect(updated, isA<SuccessRepoCall>());
      final success = updated as SuccessRepoCall;
      expect(success.data.name, equals('Corrected Upazila'));
    });

    test('deleteUpazila removes the upazila', () async {
      final created = await repository.createUpazila(
        const CreateUpazilaParams(
          districtId: 'dist-dhaka',
          name: 'Upazila To Delete',
        ),
      );
      final createdUpz = (created as SuccessRepoCall).data;

      final deleted = await repository.deleteUpazila(
        DeleteUpazilaParams(upazilaId: createdUpz.id),
      );
      expect(deleted, isA<SuccessRepoCall>());
      expect((deleted as SuccessRepoCall).data, isTrue);

      final list = await repository.listUpazilas(
        const ListUpazilasParams(districtId: 'dist-dhaka'),
      );
      final upazilas = (list as SuccessRepoCall).data;
      expect(upazilas.any((u) => u.id == createdUpz.id), isFalse);
    });
  });
}
