// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) => _NoticeModel(
  id: json['id'] as String,
  organizationId: json['organizationId'] as String,
  pathshalaId: json['pathshalaId'] as String?,
  title: json['title'] as String,
  content: json['content'] as String,
  status: $enumDecode(_$NoticeStatusEnumMap, json['status']),
  publishedAt: json['publishedAt'] == null
      ? null
      : DateTime.parse(json['publishedAt'] as String),
  createdByUserId: json['createdByUserId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$NoticeModelToJson(_NoticeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'pathshalaId': instance.pathshalaId,
      'title': instance.title,
      'content': instance.content,
      'status': _$NoticeStatusEnumMap[instance.status]!,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'createdByUserId': instance.createdByUserId,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$NoticeStatusEnumMap = {
  NoticeStatus.draft: 'draft',
  NoticeStatus.published: 'published',
  NoticeStatus.archived: 'archived',
};
