// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_target_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoticeTargetModel _$NoticeTargetModelFromJson(Map<String, dynamic> json) =>
    _NoticeTargetModel(
      id: json['id'] as String,
      noticeId: json['noticeId'] as String,
      targetType: $enumDecode(_$NoticeTargetTypeEnumMap, json['targetType']),
      targetId: json['targetId'] as String?,
    );

Map<String, dynamic> _$NoticeTargetModelToJson(_NoticeTargetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noticeId': instance.noticeId,
      'targetType': _$NoticeTargetTypeEnumMap[instance.targetType]!,
      'targetId': instance.targetId,
    };

const _$NoticeTargetTypeEnumMap = {
  NoticeTargetType.all: 'all',
  NoticeTargetType.organization: 'organization',
  NoticeTargetType.pathshala: 'pathshala',
  NoticeTargetType.group: 'group',
  NoticeTargetType.role: 'role',
};
