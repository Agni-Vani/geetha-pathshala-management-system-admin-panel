// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_enrollment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupEnrollmentModel _$GroupEnrollmentModelFromJson(
  Map<String, dynamic> json,
) => _GroupEnrollmentModel(
  id: json['id'] as String,
  groupId: json['groupId'] as String,
  studentAdmissionId: json['studentAdmissionId'] as String,
  personId: json['personId'] as String,
  status: $enumDecode(_$AdmissionStatusEnumMap, json['status']),
  enrolledAt: DateTime.parse(json['enrolledAt'] as String),
);

Map<String, dynamic> _$GroupEnrollmentModelToJson(
  _GroupEnrollmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'groupId': instance.groupId,
  'studentAdmissionId': instance.studentAdmissionId,
  'personId': instance.personId,
  'status': _$AdmissionStatusEnumMap[instance.status]!,
  'enrolledAt': instance.enrolledAt.toIso8601String(),
};

const _$AdmissionStatusEnumMap = {
  AdmissionStatus.pending: 'pending',
  AdmissionStatus.active: 'active',
  AdmissionStatus.transferred: 'transferred',
  AdmissionStatus.graduated: 'graduated',
  AdmissionStatus.withdrawn: 'withdrawn',
};
