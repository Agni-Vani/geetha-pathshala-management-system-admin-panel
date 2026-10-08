import '../../domain/params/params.dart';
import '../models/models.dart';

abstract class ClassesDatasource {
  Future<List<EducationalGroupModel>> listEducationalGroups(
    ListGroupsParams params,
  );
  Future<List<AcademicYearModel>> listAcademicYears(String organizationId);
  Future<List<ClassScheduleModel>> listClassSchedules(
    ListClassSchedulesParams params,
  );

  Future<List<AcademicProgramModel>> listAcademicPrograms();
  Future<AcademicProgramModel> createAcademicProgram(
    CreateAcademicProgramParams params,
  );
  Future<List<AcademicLevelModel>> listAcademicLevels(String programId);
  Future<AcademicLevelModel> createAcademicLevel(
    CreateAcademicLevelParams params,
  );
  Future<EducationalGroupModel> createEducationalGroup(
    CreateEducationalGroupParams params,
  );
  Future<EducationalGroupModel> assignClassTeacher(
    AssignClassTeacherParams params,
  );
}
