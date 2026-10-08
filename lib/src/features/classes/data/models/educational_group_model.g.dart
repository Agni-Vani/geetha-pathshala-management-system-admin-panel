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
  programId: json['programId'] as String?,
  levelId: json['levelId'] as String?,
  classTeacherId: json['classTeacherId'] as String?,
  classTeacherName: json['classTeacherName'] as String?,
  room: json['room'] as String?,
  maxCapacity: (json['maxCapacity'] as num?)?.toInt(),
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
  'programId': instance.programId,
  'levelId': instance.levelId,
  'classTeacherId': instance.classTeacherId,
  'classTeacherName': instance.classTeacherName,
  'room': instance.room,
  'maxCapacity': instance.maxCapacity,
};

const _$GroupStatusEnumMap = {
  GroupStatus.active: 'active',
  GroupStatus.merged: 'merged',
  GroupStatus.completed: 'completed',
  GroupStatus.archived: 'archived',
};
