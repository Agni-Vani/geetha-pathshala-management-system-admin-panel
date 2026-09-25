import 'package:geetha_pathshala_management_web/src/app/controller/pathshala_details_controller.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/controller/create_pathshala_controller.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/controller/create_person_controller.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/controller/geographic_areas_controller.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/controller/list_pathshalas_controller.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/controller/list_people_controller.dart';
import 'package:get_it/get_it.dart';

import '../features/communication/data/communication_data.dart';
import '../features/communication/domain/communication_domain.dart';
import '../features/education/data/education_data.dart';
import '../features/education/domain/education_domain.dart';
import '../features/iam/data/iam_data.dart';
import '../features/iam/domain/iam_domain.dart';
import '../features/registry/data/registry_data.dart';
import '../features/registry/domain/registry_domain.dart';

final GetIt sl = GetIt.instance;

/// Central Service Locator initialization under `lib/src/di/service_locator.dart`.
/// Set [useMockData] to seamlessly switch between Mock and Supabase Real Datasources.
Future<void> setupServiceLocator({bool useMockData = true}) async {
  // Reset service locator if re-initializing
  await sl.reset();

  // ==========================================================================
  // 1. DATASOURCES (Mock vs Supabase Real)
  // ==========================================================================
  if (useMockData) {
    sl.registerLazySingleton<RegistryDatasource>(
      () => MockRegistryDatasource(processingDelay: Duration.zero),
    );
    sl.registerLazySingleton<IamDatasource>(
      () => MockIamDatasource(processingDelay: Duration.zero),
    );
    sl.registerLazySingleton<EducationDatasource>(
      () => MockEducationDatasource(processingDelay: Duration.zero),
    );
    sl.registerLazySingleton<CommunicationDatasource>(
      () => MockCommunicationDatasource(processingDelay: Duration.zero),
    );
  } else {
    sl.registerLazySingleton<RegistryDatasource>(
      () => SupabaseRegistryDatasource(),
    );
    sl.registerLazySingleton<IamDatasource>(
      () => SupabaseIamDatasource(),
    );
    sl.registerLazySingleton<EducationDatasource>(
      () => SupabaseEducationDatasource(),
    );
    sl.registerLazySingleton<CommunicationDatasource>(
      () => SupabaseCommunicationDatasource(),
    );
  }

  // ==========================================================================
  // 2. REPOSITORIES
  // ==========================================================================
  sl.registerLazySingleton<RegistryRepository>(
    () => RegistryRepositoryImpl(datasource: sl<RegistryDatasource>()),
  );
  sl.registerLazySingleton<IamRepository>(
    () => IamRepositoryImpl(datasource: sl<IamDatasource>()),
  );
  sl.registerLazySingleton<EducationRepository>(
    () => EducationRepositoryImpl(datasource: sl<EducationDatasource>()),
  );
  sl.registerLazySingleton<CommunicationRepository>(
    () => CommunicationRepositoryImpl(
      datasource: sl<CommunicationDatasource>(),
    ),
  );

  // ==========================================================================
  // 3. USE CASES
  // ==========================================================================

  // Registry Use Cases (Positional)
  sl.registerLazySingleton(() => GetOrganization(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => SearchPeople(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => GetPersonById(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => CreatePerson(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => ListPathshalas(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => GetPathshalaById(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => CreatePathshala(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => UpdatePathshala(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => ListCommittees(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => GetCommitteeById(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => ListCommitteeMemberships(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => ListDistricts(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => CreateDistrict(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => ListUpazilas(sl<RegistryRepository>()));
  sl.registerLazySingleton(() => CreateUpazila(sl<RegistryRepository>()));

  // IAM Use Cases (Named)
  sl.registerLazySingleton(
    () => GetUserAccount(repository: sl<IamRepository>()),
  );
  sl.registerLazySingleton(
    () => CheckPermission(repository: sl<IamRepository>()),
  );
  sl.registerLazySingleton(
    () => ListUserRoles(repository: sl<IamRepository>()),
  );
  sl.registerLazySingleton(
    () => AssignUserRole(repository: sl<IamRepository>()),
  );
  sl.registerLazySingleton(
    () => LoginWithEmail(repository: sl<IamRepository>()),
  );
  sl.registerLazySingleton(() => Logout(repository: sl<IamRepository>()));
  sl.registerLazySingleton(
    () => GetCurrentUserAccount(repository: sl<IamRepository>()),
  );

  // Education Use Cases (Named)
  sl.registerLazySingleton(
    () => AdmitStudent(repository: sl<EducationRepository>()),
  );
  sl.registerLazySingleton(
    () => TransferStudent(repository: sl<EducationRepository>()),
  );
  sl.registerLazySingleton(
    () => ListEducationalGroups(repository: sl<EducationRepository>()),
  );
  sl.registerLazySingleton(
    () => RecordAttendance(repository: sl<EducationRepository>()),
  );
  sl.registerLazySingleton(
    () => CreateTeacherProfile(repository: sl<EducationRepository>()),
  );
  sl.registerLazySingleton(
    () => AssignTeacher(repository: sl<EducationRepository>()),
  );
  sl.registerLazySingleton(
    () => ListStudentAdmissions(repository: sl<EducationRepository>()),
  );
  sl.registerLazySingleton(
    () => ListTeacherAssignments(repository: sl<EducationRepository>()),
  );

  // Communication Use Cases (Named)
  sl.registerLazySingleton(
    () => PublishNotice(repository: sl<CommunicationRepository>()),
  );
  sl.registerLazySingleton(
    () => GetNotices(repository: sl<CommunicationRepository>()),
  );
  sl.registerLazySingleton(
    () => RecordReadReceipt(repository: sl<CommunicationRepository>()),
  );


  // Registry controllers
  sl.registerFactory(
    () => CreatePathshalaController(
      createPathshala: sl<CreatePathshala>(),
      updatePathshala: sl<UpdatePathshala>(),
      listDistricts: sl<ListDistricts>(),
      listUpazilas: sl<ListUpazilas>(),
    ),
  );
  sl.registerFactory(
    () => CreatePersonController(createPerson: sl<CreatePerson>()),
  );
  sl.registerFactory(
    () => ListPathshalasController(listPathshalas: sl<ListPathshalas>()),
  );
  sl.registerFactory(
    () => ListPeopleController(searchPeople: sl<SearchPeople>()),
  );
  sl.registerFactory(
    () => GeographicAreasController(
      listDistricts: sl<ListDistricts>(),
      createDistrict: sl<CreateDistrict>(),
      listUpazilas: sl<ListUpazilas>(),
      createUpazila: sl<CreateUpazila>(),
    ),
  );
  sl.registerFactory(
    () => PathshalaDetailsController(
      listCommittees: sl<ListCommittees>(),
      listCommitteeMemberships: sl<ListCommitteeMemberships>(),
      getPersonById: sl<GetPersonById>(),
      getNotices: sl<GetNotices>(),
      listStudentAdmissions: sl<ListStudentAdmissions>(),
      listTeacherAssignments: sl<ListTeacherAssignments>(),
    ),
  );
}
