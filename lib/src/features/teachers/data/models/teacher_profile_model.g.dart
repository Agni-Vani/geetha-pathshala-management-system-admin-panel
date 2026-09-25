// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeacherProfileModel _$TeacherProfileModelFromJson(Map<String, dynamic> json) =>
    _TeacherProfileModel(
      id: json['id'] as String,
      personId: json['personId'] as String,
      organizationId: json['organizationId'] as String,
      status: $enumDecode(_$TeacherStatusEnumMap, json['status']),
      joinedDate: DateTime.parse(json['joinedDate'] as String),
    );

Map<String, dynamic> _$TeacherProfileModelToJson(
  _TeacherProfileModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'personId': instance.personId,
  'organizationId': instance.organizationId,
  'status': _$TeacherStatusEnumMap[instance.status]!,
  'joinedDate': instance.joinedDate.toIso8601String(),
};

const _$TeacherStatusEnumMap = {
  TeacherStatus.active: 'active',
  TeacherStatus.onLeave: 'onLeave',
  TeacherStatus.inactive: 'inactive',
  TeacherStatus.resigned: 'resigned',
};
