import '../../domain/entities/entities.dart';
import '../../domain/params/params.dart';
import '../models/models.dart';
import 'education_datasource.dart';

final class MockEducationDatasource implements EducationDatasource {
  final Duration processingDelay;
  final List<AcademicYearModel> _academicYears;
  final List<StudentAdmissionModel> _admissions;
  final List<StudentTransferModel> _transfers;
  final List<EducationalGroupModel> _groups;
  final List<AttendanceSessionModel> _sessions;
  final List<AttendanceRecordModel> _records;
  final List<TeacherProfileModel> _teacherProfiles;
  final List<TeacherAssignmentModel> _teacherAssignments;

  MockEducationDatasource({
    this.processingDelay = const Duration(milliseconds: 300),
  }) : _academicYears = _seedAcademicYears(),
       _admissions = _seedAdmissions(),
       _transfers = [],
       _groups = _seedGroups(),
       _sessions = [],
       _records = [],
       _teacherProfiles = [],
       _teacherAssignments = [];

  @override
  Future<StudentAdmissionModel> admitStudent(AdmitStudentParams params) async {
    await _simulateProcessing();
    final admission = StudentAdmissionModel(
      id: 'adm-${DateTime.now().millisecondsSinceEpoch}',
      organizationId: params.organizationId,
      pathshalaId: params.pathshalaId,
      personId: params.personId,
      rollNumber: params.rollNumber,
      admissionDate: DateTime.now(),
      status: AdmissionStatus.active,
      createdAt: DateTime.now(),
    );
    _admissions.add(admission);
    return admission;
  }

  @override
  Future<StudentTransferModel> transferStudent(
    TransferStudentParams params,
  ) async {
    await _simulateProcessing();
    final transfer = StudentTransferModel(
      id: 'trf-${DateTime.now().millisecondsSinceEpoch}',
      personId: params.personId,
      fromPathshalaId: params.fromPathshalaId,
      toPathshalaId: params.toPathshalaId,
      requestedDate: DateTime.now(),
      status: TransferStatus.requested,
      reason: params.reason,
      approvedByUserId: null,
    );
    _transfers.add(transfer);
    return transfer;
  }

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
  Future<List<StudentAdmissionModel>> listStudentAdmissions(
    ListStudentAdmissionsParams params,
  ) async {
    await _simulateProcessing();
    return _admissions.where((a) => a.pathshalaId == params.pathshalaId).toList();
  }

  @override
  Future<List<TeacherAssignmentModel>> listTeacherAssignments(
    ListTeacherAssignmentsParams params,
  ) async {
    await _simulateProcessing();
    return _teacherAssignments.where((a) => a.pathshalaId == params.pathshalaId).toList();
  }

  @override
  Future<AttendanceSessionModel> recordAttendance(
    RecordAttendanceParams params,
  ) async {
    await _simulateProcessing();
    final sessionId = 'att-sess-${DateTime.now().millisecondsSinceEpoch}';
    final session = AttendanceSessionModel(
      id: sessionId,
      groupId: params.groupId,
      sessionDate: params.sessionDate,
      takenByUserId: params.takenByUserId,
      status: SessionStatus.submitted,
      createdAt: DateTime.now(),
    );
    _sessions.add(session);

    for (final entry in params.entries) {
      _records.add(
        AttendanceRecordModel(
          id: 'att-rec-${DateTime.now().millisecondsSinceEpoch}-${entry.personId}',
          sessionId: sessionId,
          personId: entry.personId,
          status: entry.status,
          remarks: entry.remarks,
        ),
      );
    }
    return session;
  }

  @override
  Future<List<AttendanceRecordModel>> getSessionAttendance(
    String sessionId,
  ) async {
    await _simulateProcessing();
    return _records.where((r) => r.sessionId == sessionId).toList();
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
  Future<TeacherProfileModel> createTeacherProfile(
    CreateTeacherProfileParams params,
  ) async {
    await _simulateProcessing();
    final profile = TeacherProfileModel(
      id: 'teacher-${DateTime.now().millisecondsSinceEpoch}',
      personId: params.personId,
      organizationId: params.organizationId,
      status: TeacherStatus.active,
      joinedDate: DateTime.now(),
    );
    _teacherProfiles.add(profile);
    return profile;
  }

  @override
  Future<TeacherAssignmentModel> assignTeacher(
    AssignTeacherParams params,
  ) async {
    await _simulateProcessing();
    final assignment = TeacherAssignmentModel(
      id: 'assign-${DateTime.now().millisecondsSinceEpoch}',
      teacherProfileId: params.teacherProfileId,
      pathshalaId: params.pathshalaId,
      groupId: params.groupId,
      role: params.role,
      effectiveFrom: params.effectiveFrom,
      effectiveTo: params.effectiveTo,
    );
    _teacherAssignments.add(assignment);
    return assignment;
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

  static List<StudentAdmissionModel> _seedAdmissions() {
    return [
      StudentAdmissionModel(
        id: 'adm-001',
        organizationId: 'org-gp-central',
        pathshalaId: 'pathshala-dhaka-central',
        personId: 'person-subhash-roy',
        rollNumber: 'DH-2026-001',
        admissionDate: DateTime(2026, 1, 15),
        status: AdmissionStatus.active,
        createdAt: DateTime(2026, 1, 15),
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
