// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_assignment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeacherAssignmentModel _$TeacherAssignmentModelFromJson(
  Map<String, dynamic> json,
) => _TeacherAssignmentModel(
  id: json['id'] as String,
  teacherProfileId: json['teacherProfileId'] as String,
  pathshalaId: json['pathshalaId'] as String,
  groupId: json['groupId'] as String,
  role: json['role'] as String,
  effectiveFrom: DateTime.parse(json['effectiveFrom'] as String),
  effectiveTo: json['effectiveTo'] == null
      ? null
      : DateTime.parse(json['effectiveTo'] as String),
);

Map<String, dynamic> _$TeacherAssignmentModelToJson(
  _TeacherAssignmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'teacherProfileId': instance.teacherProfileId,
  'pathshalaId': instance.pathshalaId,
  'groupId': instance.groupId,
  'role': instance.role,
  'effectiveFrom': instance.effectiveFrom.toIso8601String(),
  'effectiveTo': instance.effectiveTo?.toIso8601String(),
};
