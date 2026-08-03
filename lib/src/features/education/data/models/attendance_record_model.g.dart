// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceRecordModel _$AttendanceRecordModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceRecordModel(
  id: json['id'] as String,
  sessionId: json['sessionId'] as String,
  personId: json['personId'] as String,
  status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
  remarks: json['remarks'] as String?,
);

Map<String, dynamic> _$AttendanceRecordModelToJson(
  _AttendanceRecordModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'sessionId': instance.sessionId,
  'personId': instance.personId,
  'status': _$AttendanceStatusEnumMap[instance.status]!,
  'remarks': instance.remarks,
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.absent: 'absent',
  AttendanceStatus.late: 'late',
  AttendanceStatus.excused: 'excused',
};
