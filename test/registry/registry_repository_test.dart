import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/data/datasources/mock_registry_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/data/repositories/registry_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/domain/params/params.dart';

void main() {
  group('RegistryRepositoryImpl Tests', () {
    late MockRegistryDatasource mockDatasource;
    late RegistryRepositoryImpl repository;

    setUp(() {
      mockDatasource = MockRegistryDatasource(processingDelay: Duration.zero);
      repository = RegistryRepositoryImpl(datasource: mockDatasource);
    });

    test('getOrganization returns SuccessRepoCall with Organization', () async {
      final response = await repository.getOrganization('org-gp-central');
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.id, equals('org-gp-central'));
    });

    test('listPathshalas returns list of Pathshalas', () async {
      final response = await repository.listPathshalas(
        const ListPathshalasParams(
          organizationId: 'org-gp-central',
          status: null,
          searchQuery: null,
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, greaterThanOrEqualTo(1));
    });

    test('createPathshala creates a new Pathshala record', () async {
      final response = await repository.createPathshala(
        const CreatePathshalaParams(
          organizationId: 'org-gp-central',
          code: 'PATH-SYL-001',
          name: 'Sylhet Central Gita Pathshala',
          addressLine1: 'Zindabazar',
          addressLine2: 'Temple Road',
          city: 'Sylhet',
          district: 'Sylhet',
          postalCode: '3100',
          latitude: 24.8949,
          longitude: 91.8687,
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.name, equals('Sylhet Central Gita Pathshala'));
      expect(success.data.address.addressLine1, equals('Zindabazar'));
      expect(success.data.address.addressLine2, equals('Temple Road'));
      expect(success.data.address.city, equals('Sylhet'));
      expect(success.data.address.region, equals('Sylhet'));
      expect(success.data.address.country, equals('Bangladesh'));
      expect(success.data.address.postalCode, equals('3100'));
      expect(success.data.coordinate?.latitude, equals(24.8949));
      expect(success.data.coordinate?.longitude, equals(91.8687));
    });

    test('searchPeople returns filtered people list', () async {
      final response = await repository.searchPeople(
        const SearchPeopleParams(
          organizationId: 'org-gp-central',
          query: 'Anirban',
          dateOfBirth: null,
          phone: null,
          email: null,
        ),
      );
      expect(response, isA<SuccessRepoCall>());
      final success = response as SuccessRepoCall;
      expect(success.data.length, greaterThanOrEqualTo(1));
    });
  });
}
