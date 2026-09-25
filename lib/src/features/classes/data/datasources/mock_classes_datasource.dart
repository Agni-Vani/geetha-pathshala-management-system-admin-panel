import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'classes_datasource.dart';

final class MockClassesDatasource implements ClassesDatasource {
  final Duration processingDelay;
  final List<AcademicYearModel> _academicYears;
  final List<EducationalGroupModel> _groups;

  MockClassesDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _academicYears = _seedAcademicYears(),
       _groups = _seedGroups();

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
}
