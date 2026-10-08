final class ListGroupsParams {
  final String pathshalaId;
  final String? academicYearId;

  const ListGroupsParams({
    required this.pathshalaId,
    this.academicYearId,
  });
}

final class ListClassSchedulesParams {
  final String? pathshalaId;

  const ListClassSchedulesParams({this.pathshalaId});
}

final class CreateAcademicProgramParams {
  final String name;
  final String code;
  final String levelTermLabel;
  final String? description;

  const CreateAcademicProgramParams({
    required this.name,
    required this.code,
    required this.levelTermLabel,
    this.description,
  });
}

final class CreateAcademicLevelParams {
  final String programId;
  final String name;
  final String code;
  final int sequence;
  final String? description;

  const CreateAcademicLevelParams({
    required this.programId,
    required this.name,
    required this.code,
    required this.sequence,
    this.description,
  });
}

final class CreateEducationalGroupParams {
  final String pathshalaId;
  final String academicYearId;
  final String programId;
  final String levelId;
  final String name;
  final String gradeLevel;
  final String? classTeacherId;
  final String? classTeacherName;
  final String? room;
  final int? maxCapacity;

  const CreateEducationalGroupParams({
    required this.pathshalaId,
    required this.academicYearId,
    required this.programId,
    required this.levelId,
    required this.name,
    required this.gradeLevel,
    this.classTeacherId,
    this.classTeacherName,
    this.room,
    this.maxCapacity,
  });
}

final class AssignClassTeacherParams {
  final String groupId;
  final String teacherId;
  final String teacherName;

  const AssignClassTeacherParams({
    required this.groupId,
    required this.teacherId,
    required this.teacherName,
  });
}
