import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'classes_datasource.dart';

final class MockClassesDatasource implements ClassesDatasource {
  final Duration processingDelay;
  final List<AcademicYearModel> _academicYears;
  final List<EducationalGroupModel> _groups;
  final List<ClassScheduleModel> _schedules;

  MockClassesDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _academicYears = _seedAcademicYears(),
       _groups = _seedGroups(),
       _schedules = _seedSchedules();

  @override
  Future<List<EducationalGroupModel>> listEducationalGroups(
    ListGroupsParams params,
  ) async {
    await _simulateProcessing();
    return _groups.where((g) {
      if (g.pathshalaId != params.pathshalaId) return false;
      if (params.academicYearId != null &&
          g.academicYearId != params.academicYearId) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<List<AcademicYearModel>> listAcademicYears(
    String organizationId,
  ) async {
    await _simulateProcessing();
    return _academicYears
        .where((ay) => ay.organizationId == organizationId)
        .toList();
  }

  @override
  Future<List<ClassScheduleModel>> listClassSchedules(
    ListClassSchedulesParams params,
  ) async {
    await _simulateProcessing();
    return _schedules.where((s) {
      if (params.pathshalaId != null &&
          params.pathshalaId != 'All Pathshalas' &&
          s.pathshalaId != null &&
          s.pathshalaId != params.pathshalaId) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> _simulateProcessing() async {
    if (processingDelay > Duration.zero) {
      await Future.delayed(processingDelay);
    }
  }

  static List<AcademicYearModel> _seedAcademicYears() {
    return [
      AcademicYearModel(
        id: 'ay-2026',
        organizationId: 'org-gp-central',
        name: 'Academic Year 2026',
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
        status: AcademicYearStatus.active,
        createdAt: DateTime(2026, 1, 1),
      ),
    ];
  }

  static List<EducationalGroupModel> _seedGroups() {
    return [
      EducationalGroupModel(
        id: 'group-gita-basic-01',
        pathshalaId: 'pathshala-dhaka-central',
        academicYearId: 'ay-2026',
        name: 'Gita Shloka Beginners Group A',
        gradeLevel: 'Level 1',
        status: GroupStatus.active,
        createdAt: DateTime(2026, 1, 15),
      ),
    ];
  }

  static List<ClassScheduleModel> _seedSchedules() {
    return const [
      ClassScheduleModel(
        id: 'cs-001',
        subject: 'শ্রীমদ্ভগবদ্গীতা',
        day: 'শনিবার',
        time: 'সকাল ১০:০০ - ১১:৩০',
        teacher: 'অনির্বাণ সেন',
      ),
      ClassScheduleModel(
        id: 'cs-002',
        subject: 'সংস্কৃত',
        day: 'শনিবার',
        time: 'সকাল ১১:৩০ - ১২:৩০',
        teacher: 'ইশিতা পাল',
      ),
      ClassScheduleModel(
        id: 'cs-003',
        subject: 'ভজন ও কীর্তন',
        day: 'রবিবার',
        time: 'বিকাল ৪:০০ - ৫:০০',
        teacher: 'অনির্বাণ সেন',
      ),
    ];
  }
}
