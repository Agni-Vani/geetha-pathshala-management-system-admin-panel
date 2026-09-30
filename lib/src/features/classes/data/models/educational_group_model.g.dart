// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'educational_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EducationalGroupModel _$EducationalGroupModelFromJson(
  Map<String, dynamic> json,
) => _EducationalGroupModel(
  id: json['id'] as String,
  pathshalaId: json['pathshalaId'] as String,
  academicYearId: json['academicYearId'] as String,
  name: json['name'] as String,
  gradeLevel: json['gradeLevel'] as String,
  status: $enumDecode(_$GroupStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$EducationalGroupModelToJson(
  _EducationalGroupModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'pathshalaId': instance.pathshalaId,
  'academicYearId': instance.academicYearId,
  'name': instance.name,
  'gradeLevel': instance.gradeLevel,
  'status': _$GroupStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$GroupStatusEnumMap = {
  GroupStatus.active: 'active',
  GroupStatus.merged: 'merged',
  GroupStatus.completed: 'completed',
  GroupStatus.archived: 'archived',
};
