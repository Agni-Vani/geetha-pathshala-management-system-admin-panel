// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceSessionModel _$AttendanceSessionModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceSessionModel(
  id: json['id'] as String,
  groupId: json['groupId'] as String,
  sessionDate: DateTime.parse(json['sessionDate'] as String),
  takenByUserId: json['takenByUserId'] as String,
  status: $enumDecode(_$SessionStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AttendanceSessionModelToJson(
  _AttendanceSessionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'groupId': instance.groupId,
  'sessionDate': instance.sessionDate.toIso8601String(),
  'takenByUserId': instance.takenByUserId,
  'status': _$SessionStatusEnumMap[instance.status]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$SessionStatusEnumMap = {
  SessionStatus.open: 'open',
  SessionStatus.submitted: 'submitted',
  SessionStatus.approved: 'approved',
  SessionStatus.corrected: 'corrected',
};
