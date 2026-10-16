import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geetha_pathshala_management_web/src/core/theme/app_theme.dart';
import 'package:geetha_pathshala_management_web/src/di/service_locator.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/data/datasources/areas_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/data/datasources/mock_areas_datasource.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/data/models/models.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/data/repositories/areas_repository_impl.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/domain/areas_domain.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/presentation/controller/geographic_areas_controller.dart';
import 'package:geetha_pathshala_management_web/src/features/areas/presentation/widgets/geographic_areas_management_widget.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  late _TestAreasDatasource datasource;
  late GeographicAreasController controller;

  setUp(() async {
    datasource = _TestAreasDatasource();
    controller = _createController(datasource);
    await controller.load();
  });

  tearDown(() => controller.dispose());

  test(
    'empty division clears the previous district and its upazilas',
    () async {
      await controller.setDivisionFilter('Rangpur');
      expect(controller.selectedDistrict!.name, 'Dinajpur');
      expect(controller.upazilas, isNotEmpty);
      await controller.setDivisionFilter(null);
      expect(controller.selectedDistrict!.name, 'Dinajpur');

      await controller.setDivisionFilter('Barishal');
      expect(controller.districts, isEmpty);
      expect(controller.selectedDistrict, isNull);
      expect(controller.upazilas, isEmpty);
      expect(controller.isLoadingUpazilas, isFalse);

      await controller.setDivisionFilter(null);
      expect(controller.selectedDistrict, isNotNull);
      expect(controller.upazilas, isNotEmpty);
    },
  );

  test('division change selects only a visible district', () async {
    await controller.setDivisionFilter('Rangpur');
    await controller.setDivisionFilter('Dhaka');
    expect(controller.selectedDistrict!.name, 'Dhaka');
    expect(controller.upazilas, isNotEmpty);
    expect(
      controller.upazilas.every(
        (u) => u.districtId == controller.selectedDistrict!.id,
      ),
      isTrue,
    );
    await controller.selectDistrict(
      (await datasource.seed.listDistricts()).firstWhere(
        (d) => d.name == 'Dinajpur',
      ),
    );
    expect(controller.selectedDistrict!.name, 'Dhaka');
  });

  test('district searches also reconcile the detail selection', () async {
    await controller.setSearchQuery('Dinajpur');
    expect(controller.selectedDistrict!.name, 'Dinajpur');
    await controller.setSearchQuery('missing district');
    expect(controller.selectedDistrict, isNull);
    expect(controller.upazilas, isEmpty);
    await controller.setSearchQuery('');
    expect(controller.selectedDistrict, isNotNull);
  });

  test(
    'reloading with a division selected retains the full registry',
    () async {
      await controller.setDivisionFilter('Rangpur');
      await controller.load();
      await controller.setDivisionFilter('Dhaka');
      expect(controller.districts.single.name, 'Dhaka');
      expect(controller.selectedDistrict!.name, 'Dhaka');
    },
  );

  test('pending old results cannot repopulate an empty division', () async {
    datasource.holdUpazilas = true;
    final loading = controller.setDivisionFilter('Rangpur');
    final request = datasource.pending['dist-dinajpur']!;
    expect(controller.upazilas, isEmpty);
    expect(controller.isLoadingUpazilas, isTrue);

    await controller.setDivisionFilter('Barishal');
    request.complete(
      await datasource.seed.listUpazilas(
        params: const ListUpazilasParams(districtId: 'dist-dinajpur'),
      ),
    );
    await loading;
    expect(controller.selectedDistrict, isNull);
    expect(controller.upazilas, isEmpty);
    expect(controller.isLoadingUpazilas, isFalse);
  });

  test(
    'old results cannot overwrite a newer district or its loading state',
    () async {
      datasource.holdUpazilas = true;
      final firstLoad = controller.setDivisionFilter('Rangpur');
      final secondLoad = controller.setDivisionFilter('Dhaka');
      datasource.pending['dist-dinajpur']!.complete(
        await datasource.seed.listUpazilas(
          params: const ListUpazilasParams(districtId: 'dist-dinajpur'),
        ),
      );
      await firstLoad;
      expect(controller.selectedDistrict!.name, 'Dhaka');
      expect(controller.isLoadingUpazilas, isTrue);
      expect(controller.upazilas, isEmpty);

      datasource.pending['dist-dhaka']!.complete(
        await datasource.seed.listUpazilas(
          params: const ListUpazilasParams(districtId: 'dist-dhaka'),
        ),
      );
      await secondLoad;
      expect(controller.isLoadingUpazilas, isFalse);
      expect(controller.upazilas, isNotEmpty);
      expect(
        controller.upazilas.every((u) => u.districtId == 'dist-dhaka'),
        isTrue,
      );
    },
  );
  test('returning to a district still ignores its earlier request', () async {
    datasource.holdUpazilas = true;
    final oldLoad = controller.setDivisionFilter('Rangpur');
    final oldRequest = datasource.pending['dist-dinajpur']!;
    await controller.setDivisionFilter('Barishal');
    final currentLoad = controller.setDivisionFilter('Rangpur');
    datasource.pending['dist-dinajpur']!.complete(
      await datasource.seed.listUpazilas(
        params: const ListUpazilasParams(districtId: 'dist-dinajpur'),
      ),
    );
    await currentLoad;
    oldRequest.complete([]);
    await oldLoad;
    expect(controller.selectedDistrict!.name, 'Dinajpur');
    expect(controller.upazilas, isNotEmpty);
    expect(controller.isLoadingUpazilas, isFalse);
  });

  testWidgets('timeout stops loading and retry ignores the late response', (
    tester,
  ) async {
    await controller.setDivisionFilter('Rangpur');
    datasource.holdUpazilas = true;
    final loading = controller.setDivisionFilter('Dhaka');
    final oldRequest = datasource.pending['dist-dhaka']!;
    await tester.pump(const Duration(seconds: 15));
    await loading;
    expect(controller.isLoadingUpazilas, isFalse);
    expect(controller.upazilasError, contains('বেশি সময়'));
    expect(controller.upazilas, isEmpty);

    datasource.holdUpazilas = false;
    await controller.loadUpazilasForDistrict('dist-dhaka');
    expect(controller.upazilasError, isNull);
    expect(controller.upazilas, isNotEmpty);
    oldRequest.complete([]);
    await tester.pump();
    expect(controller.upazilas, isNotEmpty);
  });

  test(
    'request failure stays distinct from an empty successful result',
    () async {
      await controller.setDivisionFilter('Rangpur');
      datasource.failUpazilas = true;
      await controller.setDivisionFilter('Dhaka');
      expect(controller.isLoadingUpazilas, isFalse);
      expect(controller.upazilasError, contains('আনা যায়নি'));

      await controller.setDivisionFilter('Barishal');
      expect(controller.upazilasError, isNull);
      datasource.failUpazilas = false;
      datasource.emptyUpazilas = true;
      await controller.setDivisionFilter('Dhaka');
      expect(controller.upazilas, isEmpty);
      expect(controller.upazilasError, isNull);
    },
  );

  testWidgets('loading message becomes a timeout message with working retry', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    datasource.holdUpazilas = true;
    sl.pushNewScope();
    sl.registerFactory<GeographicAreasController>(
      () => _createController(datasource),
    );
    addTearDown(sl.popScope);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme().lightTheme,
        home: const Scaffold(
          body: SingleChildScrollView(child: GeographicAreasManagementWidget()),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('উপজেলার তথ্য লোড হচ্ছে...'), findsOneWidget);
    await tester.pump(const Duration(seconds: 15));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.textContaining('বেশি সময়'), findsOneWidget);
    expect(find.text('আবার চেষ্টা করুন'), findsOneWidget);
    expect(find.textContaining('কোন উপজেলা যোগ করা হয়নি'), findsNothing);

    datasource.holdUpazilas = false;
    await tester.tap(find.text('আবার চেষ্টা করুন'));
    await tester.pumpAndSettle();
    expect(find.text('আবার চেষ্টা করুন'), findsNothing);
    expect(find.textContaining('বেশি সময়'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  test('editDistrict updates district name and division', () async {
    final dinajpur = controller.districts.firstWhere((d) => d.name == 'Dinajpur');
    await controller.selectDistrict(dinajpur);
    final success = await controller.editDistrict(
      districtId: dinajpur.id,
      name: 'Dinajpur Updated',
      division: 'Rangpur',
    );
    expect(success, isTrue);
    expect(controller.districts.any((d) => d.name == 'Dinajpur Updated'), isTrue);
    expect(controller.selectedDistrict?.name, 'Dinajpur Updated');
  });

  test('removeDistrict removes district and re-syncs selected district', () async {
    final dinajpur = controller.districts.firstWhere((d) => d.name == 'Dinajpur');
    final success = await controller.removeDistrict(
      districtId: dinajpur.id,
    );
    expect(success, isTrue);
    expect(controller.districts.any((d) => d.id == dinajpur.id), isFalse);
    expect(controller.selectedDistrict?.name, 'Dhaka');
  });

  test('editUpazila updates the upazila in current list', () async {
    await controller.setDivisionFilter('Dhaka');
    expect(controller.upazilas, isNotEmpty);
    final upz = controller.upazilas.first;
    final success = await controller.editUpazila(
      upazilaId: upz.id,
      name: 'Edited Upazila Name',
    );
    expect(success, isTrue);
    expect(controller.upazilas.any((u) => u.name == 'Edited Upazila Name'), isTrue);
  });

  test('removeUpazila deletes upazila from current list', () async {
    await controller.setDivisionFilter('Dhaka');
    expect(controller.upazilas, isNotEmpty);
    final upz = controller.upazilas.first;
    final success = await controller.removeUpazila(
      upazilaId: upz.id,
    );
    expect(success, isTrue);
    expect(controller.upazilas.any((u) => u.id == upz.id), isFalse);
  });
}

GeographicAreasController _createController(_TestAreasDatasource datasource) {
  final repository = AreasRepositoryImpl(datasource);
  return GeographicAreasController(
    listDivisions: ListDivisions(repository),
    createDivision: CreateDivision(repository),
    listDistricts: ListDistricts(repository),
    createDistrict: CreateDistrict(repository),
    updateDistrict: UpdateDistrict(repository),
    deleteDistrict: DeleteDistrict(repository),
    listUpazilas: ListUpazilas(repository),
    createUpazila: CreateUpazila(repository),
    updateUpazila: UpdateUpazila(repository),
    deleteUpazila: DeleteUpazila(repository),
  );
}

/// A registry with no Barishal districts and controllable upazila responses.
class _TestAreasDatasource implements AreasDatasource {
  final seed = MockAreasDatasource(processingDelay: Duration.zero);
  bool holdUpazilas = false;
  bool failUpazilas = false;
  bool emptyUpazilas = false;
  final pending = <String, Completer<List<UpazilaModel>>>{};

  @override
  Future<List<DivisionModel>> listDivisions({ListDivisionsParams? params}) =>
      seed.listDivisions(params: params);

  @override
  Future<List<DistrictModel>> listDistricts({
    ListDistrictsParams? params,
  }) async => (await seed.listDistricts(params: params))
      .where((district) => ['Dinajpur', 'Dhaka'].contains(district.name))
      .toList();

  @override
  Future<List<UpazilaModel>> listUpazilas({ListUpazilasParams? params}) {
    if (failUpazilas) return Future.error(Exception('Network unavailable'));
    if (emptyUpazilas) return Future.value([]);
    if (!holdUpazilas) return seed.listUpazilas(params: params);
    final response = Completer<List<UpazilaModel>>();
    pending[params!.districtId!] = response;
    return response.future;
  }

  @override
  Future<DivisionModel> createDivision(CreateDivisionParams params) =>
      seed.createDivision(params);

  @override
  Future<DistrictModel> createDistrict(CreateDistrictParams params) =>
      seed.createDistrict(params);

  @override
  Future<DistrictModel> updateDistrict(UpdateDistrictParams params) =>
      seed.updateDistrict(params);

  @override
  Future<void> deleteDistrict(DeleteDistrictParams params) =>
      seed.deleteDistrict(params);

  @override
  Future<UpazilaModel> createUpazila(CreateUpazilaParams params) =>
      seed.createUpazila(params);

  @override
  Future<UpazilaModel> updateUpazila(UpdateUpazilaParams params) =>
      seed.updateUpazila(params);

  @override
  Future<void> deleteUpazila(DeleteUpazilaParams params) =>
      seed.deleteUpazila(params);
}
