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
}
