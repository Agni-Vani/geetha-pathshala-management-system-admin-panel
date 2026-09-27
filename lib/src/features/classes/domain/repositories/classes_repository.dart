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
}
