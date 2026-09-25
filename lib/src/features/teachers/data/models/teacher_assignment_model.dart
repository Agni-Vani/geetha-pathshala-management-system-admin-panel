import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/entities.dart';

part 'teacher_assignment_model.freezed.dart';
part 'teacher_assignment_model.g.dart';

@freezed
abstract class TeacherAssignmentModel extends TeacherAssignment
    with _$TeacherAssignmentModel {
  const TeacherAssignmentModel._() : super();

  const factory TeacherAssignmentModel({
    required String id,
    required String teacherProfileId,
    required String pathshalaId,
    required String groupId,
    required String role,
    required DateTime effectiveFrom,
    required DateTime? effectiveTo,
  }) = _TeacherAssignmentModel;

  factory TeacherAssignmentModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherAssignmentModelFromJson(json);
}
