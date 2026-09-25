// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_transfer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentTransferModel _$StudentTransferModelFromJson(
  Map<String, dynamic> json,
) => _StudentTransferModel(
  id: json['id'] as String,
  personId: json['personId'] as String,
  fromPathshalaId: json['fromPathshalaId'] as String,
  toPathshalaId: json['toPathshalaId'] as String,
  requestedDate: DateTime.parse(json['requestedDate'] as String),
  status: $enumDecode(_$TransferStatusEnumMap, json['status']),
  reason: json['reason'] as String?,
  approvedByUserId: json['approvedByUserId'] as String?,
);

Map<String, dynamic> _$StudentTransferModelToJson(
  _StudentTransferModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'personId': instance.personId,
  'fromPathshalaId': instance.fromPathshalaId,
  'toPathshalaId': instance.toPathshalaId,
  'requestedDate': instance.requestedDate.toIso8601String(),
  'status': _$TransferStatusEnumMap[instance.status]!,
  'reason': instance.reason,
  'approvedByUserId': instance.approvedByUserId,
};

const _$TransferStatusEnumMap = {
  TransferStatus.requested: 'requested',
  TransferStatus.approved: 'approved',
  TransferStatus.rejected: 'rejected',
  TransferStatus.completed: 'completed',
  TransferStatus.cancelled: 'cancelled',
};
