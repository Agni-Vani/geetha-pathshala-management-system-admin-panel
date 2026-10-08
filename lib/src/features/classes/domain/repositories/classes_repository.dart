import '../../../../core/async_handlers/async_request.dart';
import '../entities/entities.dart';
import '../params/params.dart';

abstract interface class ClassesRepository {
  AsyncRequest<List<EducationalGroup>> listEducationalGroups(
    ListGroupsParams params,
  );
  AsyncRequest<List<AcademicYear>> listAcademicYears(String organizationId);
  AsyncRequest<List<ClassSchedule>> listClassSchedules(
    ListClassSchedulesParams params,
  );

  AsyncRequest<List<AcademicProgram>> listAcademicPrograms();
  AsyncRequest<AcademicProgram> createAcademicProgram(
    CreateAcademicProgramParams params,
  );
  AsyncRequest<List<AcademicLevel>> listAcademicLevels(String programId);
  AsyncRequest<AcademicLevel> createAcademicLevel(
    CreateAcademicLevelParams params,
  );
  AsyncRequest<EducationalGroup> createEducationalGroup(
    CreateEducationalGroupParams params,
  );
  AsyncRequest<EducationalGroup> assignClassTeacher(
    AssignClassTeacherParams params,
  );
}
