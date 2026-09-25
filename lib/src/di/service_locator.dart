import 'package:get_it/get_it.dart';

import '../features/areas/data/areas_data.dart';
import '../features/areas/domain/areas_domain.dart';
import '../features/areas/presentation/controller/geographic_areas_controller.dart';
import '../features/attendance/data/attendance_data.dart';
import '../features/attendance/domain/attendance_domain.dart';
import '../features/authentication/data/authentication_data.dart';
import '../features/authentication/domain/authentication_domain.dart';
import '../features/classes/data/classes_data.dart';
import '../features/classes/domain/classes_domain.dart';
import '../features/notices/data/notices_data.dart';
import '../features/notices/domain/notices_domain.dart';
import '../features/pathshala/data/pathshala_data.dart';
import '../features/pathshala/domain/pathshala_domain.dart';
import '../features/pathshala/presentation/controller/create_pathshala_controller.dart';
import '../features/pathshala/presentation/controller/list_pathshalas_controller.dart';
import '../features/pathshala/presentation/controller/pathshala_details_controller.dart';
import '../features/person/data/person_data.dart';
import '../features/person/domain/person_domain.dart';
import '../features/person/presentation/controller/create_person_controller.dart';
import '../features/person/presentation/controller/list_people_controller.dart';
import '../features/students/data/students_data.dart';
import '../features/students/domain/students_domain.dart';
import '../features/teachers/data/teachers_data.dart';
import '../features/teachers/domain/teachers_domain.dart';

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
    sl.registerLazySingleton<StudentsDatasource>(
      () => MockStudentsDatasource(processingDelay: Duration.zero),
    );
    sl.registerLazySingleton<TeachersDatasource>(
      () => MockTeachersDatasource(processingDelay: Duration.zero),
    );
    sl.registerLazySingleton<AttendanceDatasource>(
      () => MockAttendanceDatasource(processingDelay: Duration.zero),
    );
    sl.registerLazySingleton<ClassesDatasource>(
      () => MockClassesDatasource(processingDelay: Duration.zero),
    );
    sl.registerLazySingleton<NoticesDatasource>(
      () => MockNoticesDatasource(processingDelay: Duration.zero),
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
    sl.registerLazySingleton<StudentsDatasource>(
      () => SupabaseStudentsDatasource(),
    );
    sl.registerLazySingleton<TeachersDatasource>(
      () => SupabaseTeachersDatasource(),
    );
    sl.registerLazySingleton<AttendanceDatasource>(
      () => SupabaseAttendanceDatasource(),
    );
    sl.registerLazySingleton<ClassesDatasource>(
      () => SupabaseClassesDatasource(),
    );
    sl.registerLazySingleton<NoticesDatasource>(
      () => SupabaseNoticesDatasource(),
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
  sl.registerLazySingleton<StudentsRepository>(
    () => StudentsRepositoryImpl(datasource: sl<StudentsDatasource>()),
  );
  sl.registerLazySingleton<TeachersRepository>(
    () => TeachersRepositoryImpl(datasource: sl<TeachersDatasource>()),
  );
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(datasource: sl<AttendanceDatasource>()),
  );
  sl.registerLazySingleton<ClassesRepository>(
    () => ClassesRepositoryImpl(datasource: sl<ClassesDatasource>()),
  );
  sl.registerLazySingleton<NoticesRepository>(
    () => NoticesRepositoryImpl(
      datasource: sl<NoticesDatasource>(),
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

  // Students Use Cases
  sl.registerLazySingleton(
    () => AdmitStudent(repository: sl<StudentsRepository>()),
  );
  sl.registerLazySingleton(
    () => TransferStudent(repository: sl<StudentsRepository>()),
  );
  sl.registerLazySingleton(
    () => ListStudentAdmissions(repository: sl<StudentsRepository>()),
  );

  // Teachers Use Cases
  sl.registerLazySingleton(
    () => CreateTeacherProfile(repository: sl<TeachersRepository>()),
  );
  sl.registerLazySingleton(
    () => AssignTeacher(repository: sl<TeachersRepository>()),
  );
  sl.registerLazySingleton(
    () => ListTeacherAssignments(repository: sl<TeachersRepository>()),
  );

  // Attendance Use Cases
  sl.registerLazySingleton(
    () => RecordAttendance(repository: sl<AttendanceRepository>()),
  );
  sl.registerLazySingleton(
    () => GetSessionAttendance(repository: sl<AttendanceRepository>()),
  );

  // Classes Use Cases
  sl.registerLazySingleton(
    () => ListEducationalGroups(repository: sl<ClassesRepository>()),
  );
  sl.registerLazySingleton(
    () => ListAcademicYears(repository: sl<ClassesRepository>()),
  );

  // Notices Use Cases
  sl.registerLazySingleton(
    () => PublishNotice(repository: sl<NoticesRepository>()),
  );
  sl.registerLazySingleton(
    () => GetNotices(repository: sl<NoticesRepository>()),
  );
  sl.registerLazySingleton(
    () => RecordReadReceipt(repository: sl<NoticesRepository>()),
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
