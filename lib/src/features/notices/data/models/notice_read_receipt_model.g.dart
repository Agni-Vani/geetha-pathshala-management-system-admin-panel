// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_read_receipt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoticeReadReceiptModel _$NoticeReadReceiptModelFromJson(
  Map<String, dynamic> json,
) => _NoticeReadReceiptModel(
  id: json['id'] as String,
  noticeId: json['noticeId'] as String,
  personId: json['personId'] as String,
  userAccountId: json['userAccountId'] as String,
  readAt: DateTime.parse(json['readAt'] as String),
);

Map<String, dynamic> _$NoticeReadReceiptModelToJson(
  _NoticeReadReceiptModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'noticeId': instance.noticeId,
  'personId': instance.personId,
  'userAccountId': instance.userAccountId,
  'readAt': instance.readAt.toIso8601String(),
};
