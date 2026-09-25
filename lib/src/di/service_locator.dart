import 'package:get_it/get_it.dart';

import '../features/areas/data/areas_data.dart';
import '../features/areas/domain/areas_domain.dart';
import '../features/areas/presentation/controller/geographic_areas_controller.dart';
import '../features/authentication/data/authentication_data.dart';
import '../features/authentication/domain/authentication_domain.dart';
import '../features/communication/data/communication_data.dart';
import '../features/communication/domain/communication_domain.dart';
import '../features/education/data/education_data.dart';
import '../features/education/domain/education_domain.dart';
import '../features/pathshala/data/pathshala_data.dart';
import '../features/pathshala/domain/pathshala_domain.dart';
import '../features/pathshala/presentation/controller/create_pathshala_controller.dart';
import '../features/pathshala/presentation/controller/list_pathshalas_controller.dart';
import '../features/pathshala/presentation/controller/pathshala_details_controller.dart';
import '../features/person/data/person_data.dart';
import '../features/person/domain/person_domain.dart';
import '../features/person/presentation/controller/create_person_controller.dart';
import '../features/person/presentation/controller/list_people_controller.dart';

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
    sl.registerLazySingleton<AreasDatasource>(
      () => MockAreasDatasource(processingDelay: Duration.zero),
    );
    sl.registerLazySingleton<PersonDatasource>(
      () => MockPersonDatasource(processingDelay: Duration.zero),
    );
    sl.registerLazySingleton<PathshalaDatasource>(
      () => MockPathshalaDatasource(processingDelay: Duration.zero),
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
    sl.registerLazySingleton<AreasDatasource>(
      () => SupabaseAreasDatasource(),
    );
    sl.registerLazySingleton<PersonDatasource>(
      () => SupabasePersonDatasource(),
    );
    sl.registerLazySingleton<PathshalaDatasource>(
      () => SupabasePathshalaDatasource(),
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
  sl.registerLazySingleton<AreasRepository>(
    () => AreasRepositoryImpl(sl<AreasDatasource>()),
  );
  sl.registerLazySingleton<PersonRepository>(
    () => PersonRepositoryImpl(sl<PersonDatasource>()),
  );
  sl.registerLazySingleton<PathshalaRepository>(
    () => PathshalaRepositoryImpl(sl<PathshalaDatasource>()),
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

  // Areas Use Cases
  sl.registerLazySingleton(() => ListDistricts(sl<AreasRepository>()));
  sl.registerLazySingleton(() => CreateDistrict(sl<AreasRepository>()));
  sl.registerLazySingleton(() => ListUpazilas(sl<AreasRepository>()));
  sl.registerLazySingleton(() => CreateUpazila(sl<AreasRepository>()));

  // Person Use Cases
  sl.registerLazySingleton(() => SearchPeople(sl<PersonRepository>()));
  sl.registerLazySingleton(() => GetPersonById(sl<PersonRepository>()));
  sl.registerLazySingleton(() => CreatePerson(sl<PersonRepository>()));
  sl.registerLazySingleton(() => GetPersonContacts(sl<PersonRepository>()));
  sl.registerLazySingleton(() => GetPersonRelationships(sl<PersonRepository>()));

  // Pathshala Use Cases
  sl.registerLazySingleton(() => GetOrganization(sl<PathshalaRepository>()));
  sl.registerLazySingleton(() => ListPathshalas(sl<PathshalaRepository>()));
  sl.registerLazySingleton(() => GetPathshalaById(sl<PathshalaRepository>()));
  sl.registerLazySingleton(() => CreatePathshala(sl<PathshalaRepository>()));
  sl.registerLazySingleton(() => UpdatePathshala(sl<PathshalaRepository>()));
  sl.registerLazySingleton(() => ListCommittees(sl<PathshalaRepository>()));
  sl.registerLazySingleton(() => GetCommitteeById(sl<PathshalaRepository>()));
  sl.registerLazySingleton(
    () => ListCommitteeMemberships(sl<PathshalaRepository>()),
  );

  // IAM / Authentication Use Cases
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

  // Education Use Cases
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

  // Communication Use Cases
  sl.registerLazySingleton(
    () => PublishNotice(repository: sl<CommunicationRepository>()),
  );
  sl.registerLazySingleton(
    () => GetNotices(repository: sl<CommunicationRepository>()),
  );
  sl.registerLazySingleton(
    () => RecordReadReceipt(repository: sl<CommunicationRepository>()),
  );

  // ==========================================================================
  // 4. CONTROLLERS
  // ==========================================================================
  sl.registerFactory(
    () => GeographicAreasController(
      listDistricts: sl<ListDistricts>(),
      createDistrict: sl<CreateDistrict>(),
      listUpazilas: sl<ListUpazilas>(),
      createUpazila: sl<CreateUpazila>(),
    ),
  );
  sl.registerFactory(
    () => CreatePersonController(createPerson: sl<CreatePerson>()),
  );
  sl.registerFactory(
    () => ListPeopleController(searchPeople: sl<SearchPeople>()),
  );
  sl.registerFactory(
    () => CreatePathshalaController(
      createPathshala: sl<CreatePathshala>(),
      updatePathshala: sl<UpdatePathshala>(),
      listDistricts: sl<ListDistricts>(),
      listUpazilas: sl<ListUpazilas>(),
    ),
  );
  sl.registerFactory(
    () => ListPathshalasController(listPathshalas: sl<ListPathshalas>()),
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
