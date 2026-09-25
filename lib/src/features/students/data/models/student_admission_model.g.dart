// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_admission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentAdmissionModel _$StudentAdmissionModelFromJson(
  Map<String, dynamic> json,
) => _StudentAdmissionModel(
  id: json['id'] as String,
  organizationId: json['organizationId'] as String,
  pathshalaId: json['pathshalaId'] as String,
  personId: json['personId'] as String,
  rollNumber: json['rollNumber'] as String,
  admissionDate: DateTime.parse(json['admissionDate'] as String),
  status: $enumDecode(_$AdmissionStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$StudentAdmissionModelToJson(
  _StudentAdmissionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'organizationId': instance.organizationId,
  'pathshalaId': instance.pathshalaId,
  'personId': instance.personId,
  'rollNumber': instance.rollNumber,
  'admissionDate': instance.admissionDate.toIso8601String(),
  'status': _$AdmissionStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$AdmissionStatusEnumMap = {
  AdmissionStatus.pending: 'pending',
  AdmissionStatus.active: 'active',
  AdmissionStatus.transferred: 'transferred',
  AdmissionStatus.graduated: 'graduated',
  AdmissionStatus.withdrawn: 'withdrawn',
};
