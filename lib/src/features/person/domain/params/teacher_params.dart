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

final class ListTeacherAssignmentsParams {
  final String pathshalaId;

  const ListTeacherAssignmentsParams({required this.pathshalaId});
}

final class ListTeachersParams {
  final String? pathshalaId;
  final String? subject;
  final String? search;

  const ListTeachersParams({
    this.pathshalaId,
    this.subject,
    this.search,
  });
}
