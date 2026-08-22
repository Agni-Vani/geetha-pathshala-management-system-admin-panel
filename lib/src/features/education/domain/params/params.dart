import '../entities/education_enums.dart';

final class AdmitStudentParams {
  final String organizationId;
  final String pathshalaId;
  final String personId;
  final String rollNumber;

  const AdmitStudentParams({
    required this.organizationId,
    required this.pathshalaId,
    required this.personId,
    required this.rollNumber,
  });
}

final class TransferStudentParams {
  final String personId;
  final String fromPathshalaId;
  final String toPathshalaId;
  final String reason;

  const TransferStudentParams({
    required this.personId,
    required this.fromPathshalaId,
    required this.toPathshalaId,
    required this.reason,
  });
}

final class ListGroupsParams {
  final String pathshalaId;
  final String? academicYearId;

  const ListGroupsParams({
    required this.pathshalaId,
    this.academicYearId,
  });
}

final class ListStudentAdmissionsParams {
  final String pathshalaId;

  const ListStudentAdmissionsParams({required this.pathshalaId});
}

final class ListTeacherAssignmentsParams {
  final String pathshalaId;

  const ListTeacherAssignmentsParams({required this.pathshalaId});
}

final class IndividualAttendanceEntry {
  final String personId;
  final AttendanceStatus status;
  final String? remarks;

  const IndividualAttendanceEntry({
    required this.personId,
    required this.status,
    this.remarks,
  });
}

final class RecordAttendanceParams {
  final String groupId;
  final DateTime sessionDate;
  final String takenByUserId;
  final List<IndividualAttendanceEntry> entries;

  const RecordAttendanceParams({
    required this.groupId,
    required this.sessionDate,
    required this.takenByUserId,
    required this.entries,
  });
}

final class CreateTeacherProfileParams {
  final String personId;
  final String organizationId;

  const CreateTeacherProfileParams({
    required this.personId,
    required this.organizationId,
  });
}

final class AssignTeacherParams {
  final String teacherProfileId;
  final String pathshalaId;
  final String groupId;
  final String role;
  final DateTime effectiveFrom;
  final DateTime? effectiveTo;

  const AssignTeacherParams({
    required this.teacherProfileId,
    required this.pathshalaId,
    required this.groupId,
    required this.role,
    required this.effectiveFrom,
    this.effectiveTo,
  });
}
